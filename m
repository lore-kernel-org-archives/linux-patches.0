Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE5F351C35;
	Fri,  4 Sep 2026 05:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499778; cv=none; b=LUyZGX5xZAD0wNrBYqpHF41+VeKNX4zSi9rbppim/9kJ3KI+4CSOzKl/TOwGFyUDE6UQsb3AEO3TBr7Buj9Yyr8VKcE/MgyDtOIbQ5dHpqw92vC9McUvGX7VjAzhHnBiVjeRherwvcbvLXmf+EleaTODaykEbhBpGBKFdRQ92+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499778; c=relaxed/simple;
	bh=/DGlaIYKS5zPaGjoOChESjtjZRWpPa8+L+tzvVGGkuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdPs342ClBTqZoUxXOiHiwhq80B4wdeJ5lyQ2S+b2l/E2OMGGCbD+UD4JhJly+dqhmhWlM2d7/0C7Y/7TybS8jilG4i7mIduOkq2Uu6J0BBJWmAsbp9Pykudd4+0Z3zk2zjm26ypa6ACw3PTC8eM9vdz9aFvDWL2+AVUCBDeKFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3UzjpVT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3UzjpVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECA71F00A3D;
	Fri,  4 Sep 2026 05:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499776;
	bh=HeNp3EE8qlzCwxbEN7Km7kl61mWHFPeChAIfZHJ01MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3UzjpVTA1FwiUQAyVJRfXRDs12VBiWiwFmh8E+DLc+QYuXEiVjLg7AbQdnqGpI8C
	 h6OCEGdtF3GpmtP9zK4esOrZM/X8Gfx1lLOCLn/5gaXKh+EP4mFwqBB4M3Pf7QU+0C
	 ghaQq/ArkXIrMBS3QRY+gN0LauOzIv8g/ZMndjBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.2 535/713] PCI/proc: Use file_ns_capable() when checking config space read access
Date: Fri,  4 Sep 2026 06:58:23 +0200
Message-ID: <20260904045815.813072738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -39,7 +39,7 @@ static ssize_t proc_bus_pci_read(struct
 	 * undefined locations (think of Intel PIIX4 as a typical example).
 	 */
 
-	if (capable(CAP_SYS_ADMIN))
+	if (file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN))
 		size = dev->cfg_size;
 	else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 		size = 128;


