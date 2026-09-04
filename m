Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938F3B42F7;
	Fri,  4 Sep 2026 06:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502286; cv=none; b=PIxgAOIVPr4LjE5ONFOiedhOgG5G8Xdzty8Su+fPj9I54aDQCqOLP8wZ7iXCK2Y0qB3Fsn3FiuWgp4QFQL2DYszdpGsbwO7DF7HoAd30UHmnKozQNVY0rPsUu9eBJ+RYyW2Zhsaz2IzP/leVBw2Do4i3VaazXljy2LXcskSB2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502286; c=relaxed/simple;
	bh=0t682lkUxWEOhShx+iPCm3qRTAWAb1iMWghudvdN9qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K4XVnwXQOgGspCB45NT3dZgjRvV0AAEMczRwVPmnBCo7lUU9fVDPT3zKMIbXOUFer5z60j8eGYRYse/+drQcYqhkNrv9Ap6xrThVML1mgTegySASEbviHD2xAaZCOZZ2M+oQCVhKKaF0m0Fht9mF02CYBhK2qQswtinIDyPUNqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YS/7pAnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YS/7pAnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E8C1F00A3D;
	Fri,  4 Sep 2026 06:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502285;
	bh=+Rg1mFcfP0N1Ypzc/FucShA1kqe9G8q86KOS3lIa+DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YS/7pAnZ/OLkD3hdrJLtNHmkTURAFL4e1BWmq09w5U//h8PxXv6EhaW9UhJaQPuyH
	 JYOWmrc1QaWT4c6Dr2iOnviJq8DoQfH0ip4ymC8kcN7YzKffMiS0fuV7gd60WyCbJu
	 ClZ91yU0AF+rc+zojEFI9iejNHrVTkejMUnJs8/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.12 154/403] alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()
Date: Fri,  4 Sep 2026 06:59:17 +0200
Message-ID: <20260904045738.351456729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

commit 651fb94aaf245430590216d497fb8b02dd73d5f9 upstream.

pci_legacy_write() in arch/alpha/kernel/pci-sysfs.c passes its arguments to
outb(), outw() and outl() in the wrong order:

  outb(port, val);

The Alpha I/O accessors in arch/alpha/include/asm/io.h take the value first
and the port second:

  extern void outb(u8 b, unsigned long port);

So the port number is written as data to the I/O address taken from the
user-supplied value, and the intended write to the requested port never
happens.

The arguments have been reversed since the file was added, and the function
returns the access size regardless, so the caller sees success while the
requested port is left untouched.

Fixes: 10a0ef39fbd1 ("PCI/alpha: pci sysfs resources")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260706175423.98305-1-kwilczynski@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/pci-sysfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -364,17 +364,17 @@ int pci_legacy_write(struct pci_bus *bus
 
 	switch(size) {
 	case 1:
-		outb(port, val);
+		outb(val, port);
 		return 1;
 	case 2:
 		if (port & 1)
 			return -EINVAL;
-		outw(port, val);
+		outw(val, port);
 		return 2;
 	case 4:
 		if (port & 3)
 			return -EINVAL;
-		outl(port, val);
+		outl(val, port);
 		return 4;
 	}
 	return -EINVAL;


