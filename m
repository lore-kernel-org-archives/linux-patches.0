Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B7237F30B;
	Sat, 12 Sep 2026 19:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241499; cv=none; b=HsLY4xIEoIl7Qa1OtH5wtjLFZib2X+IsCO5JfQfvLktm+7ZG9KILVPZeqqf1mOvsECy6BV5ZqrQsSZFvyJht2miopT1zpV/TJSN6Cg/OZkLH4pSlMInmhMChdkaMpjOc60yqhHmlrI1N4ik8HlCkGceDdq8q6vNn9J6Tl4N15lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241499; c=relaxed/simple;
	bh=U+Vm5Qi2ZrgE3ffaxA2Aton/drUxdEwSWYJkIF00xPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkZ/6dBI/DIRmgM1riUjIWPOMhIyloCXNt8cGTxyRDxdh5gdH1Dg+UaXXQrXPRhyMcImcCDTFkT8gMlHOJP5R6UujwKos32+9lpmoeUzcIPyjKYYH5H6ZkfS+oKjIMV0tNrf9jt8FFMIF4qgaPfafWs0s40dgrYY8pji4ptWc3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghXjFKoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghXjFKoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AB41F000FF;
	Sat, 12 Sep 2026 19:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241498;
	bh=QooRkk1n39PnjzVm6JGimimkDx5K7swLVGolE8YUtIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghXjFKoUjNcdxLf0wLz7eGlZgGRzcOvy3WH1j/jID3zx1YGRfwHqDlFvmThebajOL
	 BkWQxDAS6GzC0VwZ85wbBLk08XQ0AtXhICdEXqhbMRzJ1SQ4yodabFskuWBO36hl6T
	 w/K0GIlI9EXJUsLmWNliSODAr600ovkSkOfzNa4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 146/798] PCI/proc: Use file_ns_capable() when checking config space read access
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065520.338919032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

commit f82f53e75eff382fc8f56b73279b54f7cf5a5c65 upstream.

proc_bus_pci_read() decides how much of the config space is readable based
on capable(CAP_SYS_ADMIN), which checks the credentials of the task calling
read(), not the credentials of the process that opened the file.

The sysfs equivalent, pci_read_config(), has checked the credentials of the
opening process since commit de139a339395 ("pci: check caps from sysfs file
open to read device dependent config space"), so a privileged process can
open the config space file and pass the file descriptor to an unprivileged
process (for example, a process running a KVM guest with an assigned
device), which can then read the entire config space.  The check was
subsequently routed through the LSM framework in commit 47970b1b2aa6 ("pci:
use security_capable() when checking capablities during config space read")
and converted to the dedicated helper in commit ab0fa82b2df9 ("pci-sysfs:
use proper file capability helper function").

Thus, the two interfaces check the same capability against different
credentials.  Checking the credentials of the task calling read() makes the
outcome depend on who reads rather than who opened, so the restriction is
bypassed whenever a more privileged process reads through the descriptor.
Checking the credentials recorded in file->f_cred settles the decision at
open() time and ties it to the file, where it cannot change with the
caller.

Use file_ns_capable() to check CAP_SYS_ADMIN against the credentials in
effect when the file was opened, bringing the procfs interface in line with
the sysfs behaviour.

As a result, a file descriptor opened by a privileged process and passed to
an unprivileged one now allows the entire config space to be read through
procfs, matching sysfs.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260720204145.1500105-1-kwilczynski@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -38,7 +38,7 @@ static ssize_t proc_bus_pci_read(struct
 	 * undefined locations (think of Intel PIIX4 as a typical example).
 	 */
 
-	if (capable(CAP_SYS_ADMIN))
+	if (file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN))
 		size = dev->cfg_size;
 	else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 		size = 128;


