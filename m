Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81EB26B094;
	Thu, 13 Feb 2025 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459427; cv=none; b=WpyLmgSQTRmm6Cyly89Mz1CTPNH0i1NAVikgj4HLMFS1XjhTildHUuQeXs5y61DgOMcmT2mdc+HABxrZSIMKah58ZBy74cwNoqJUAJ+tuU4kTntdwOrq2LEwWunLTZYFye54G68vnPd6P1MHTl35v55pxsvgYV2anGE8xv5R5Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459427; c=relaxed/simple;
	bh=yULXNnE2H5L3o3iF5e6QnaUA7kRwz7wxejOcHM6+ujc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIThmrscYo9EODaTCnNt9kRsKIjAj5aR6OjrHr5ZYDBIObN6wj8hXeoB+ZCVKx3fR53yz+W5T3jrlpOSKoWTjFcgeIFuxnJAsVSHgoLH7oeHtRGaSfWy6f5C382z4gdPs+SbU81IX45jz0vSamOrfazjWkLUBpcSuetPEEpp+2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVWtigYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVWtigYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9E6C4CEE4;
	Thu, 13 Feb 2025 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459427;
	bh=yULXNnE2H5L3o3iF5e6QnaUA7kRwz7wxejOcHM6+ujc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVWtigYYB1O8qVPENOXZJGQJ0T/68GUs6R3WOqGRsoj6JDtVH8QP0yrfeuCH5122o
	 FmiCNiBwVjidoX3guE0hEauIBtxg3vv6huhn/V2LV4Z3miv4B8ot0e1KDvf8aeV4RI
	 7vJnOnkZ63E+jVy/J2tZ1XQAPHD335HMnY9R+tpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.13 261/443] MIPS: pci-legacy: Override pci_address_to_pio
Date: Thu, 13 Feb 2025 15:27:06 +0100
Message-ID: <20250213142450.688540081@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit df1b8d6e89db0edd572a1e375f5d3dd5575b9a9b upstream.

pci-legacy systems are not using logic_pio to managed PIO
allocations, thus the generic pci_address_to_pio won't work
when PCI_IOBASE is defined.

Override the function to use architecture implementation to
fix the problem.

Cc: stable@vger.kernel.org
Fixes: 4bfb53e7d317 ("mips: add <asm-generic/io.h> including")
Reported-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Closes: https://lore.kernel.org/r/99f75c66-4c2d-45dc-a808-b5ba440c7551@app.fastmail.com/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/pci/pci-legacy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/mips/pci/pci-legacy.c
+++ b/arch/mips/pci/pci-legacy.c
@@ -29,6 +29,14 @@ static LIST_HEAD(controllers);
 
 static int pci_initialized;
 
+unsigned long pci_address_to_pio(phys_addr_t address)
+{
+	if (address > IO_SPACE_LIMIT)
+		return (unsigned long)-1;
+
+	return (unsigned long) address;
+}
+
 /*
  * We need to avoid collisions with `mirrored' VGA ports
  * and other strange ISA hardware, so we always want the


