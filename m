Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949171DF277;
	Wed, 19 Feb 2025 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957439; cv=none; b=bBtBtmv6ep8O2MduSmfum3ML3yFHSvxswKKn/t3iHKRfjdQTh15ZqUeOAvjuGHBPT5P/zXVwZLK88tS5CCjPCH4iyotKnJajPrKbVHzKvbXlSPCWPMTrqIiPBvevcQPPnFcPY4bUTgJ2SQ1fCD8GgDQbLNCKHtYd8xbd5TiAHUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957439; c=relaxed/simple;
	bh=b/8/GqFzR0aIaA3BV7kzlR7ffuZGcqbZ5rfEZG9OpcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8xbTuTGhkwYmnEfgIXZKc7sD6Kmj8XPmOAnZQ5oAvzDfJ2yCW2DgkbAxdEnawi1yv6ckG3RAfHqd361uFkTyjkPi85W4x1k3RnXQ9n7IILXjoH9t5nqL4BfvSjqiAVD7BOhOtHqp/dmkX6RxH3drgEsyiUSde8h84NeCZ+Y5T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT69F5XV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT69F5XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BD0C4CED1;
	Wed, 19 Feb 2025 09:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957439;
	bh=b/8/GqFzR0aIaA3BV7kzlR7ffuZGcqbZ5rfEZG9OpcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT69F5XVFAWGgCD43DqxoUpFgULXxOy2/wgjIQ+S0RLqODBbV1hEnA/zw7P+nYpME
	 OjiqDisB02qTgexpbuuqzpSZGPkxx12N9Dh37ZiX33o+cr/vCRuMXZftlnsLaaVPQD
	 exYPis354hSLG5ya2sTz8TK+wE/Eb0kMWXBewPXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 485/578] PCI/DPC: Quirk PIO log size for Intel Raptor Lake-P
Date: Wed, 19 Feb 2025 09:28:09 +0100
Message-ID: <20250219082712.079848919@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b198499c7d2508a76243b98e7cca992f6fd2b7f7 ]

Apparently the Raptor Lake-P reference firmware configures the PIO log size
correctly, but some vendor BIOSes, including at least ASUSTeK COMPUTER INC.
Zenbook UX3402VA_UX3402VA, do not.

Apply the quirk for Raptor Lake-P.  This prevents kernel complaints like:

  DPC: RP PIO log size 0 is invalid

and also enables the DPC driver to dump the RP PIO Log registers when DPC
is triggered.

Note that the bug report also mentions 8086:a76e, which has been already
added by 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake
Root Ports").

Link: https://lore.kernel.org/r/20250102164315.7562-1-tiwai@suse.de
Link: https://bugzilla.suse.com/show_bug.cgi?id=1234623
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 2b3df65005ca8..c16c8507d048e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6139,6 +6139,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa72f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
-- 
2.39.5



