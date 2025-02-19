Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128DE1CAA68;
	Wed, 19 Feb 2025 08:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954904; cv=none; b=A8L2REjCHNFxom0mxboQKB7H/XUir27S0r+mLizUGwXMesnUvlD5KSSopk7b8EDyCsNe7QnOUesZezE0AhK02BeQVFsIR8ngKXO1MjxYX/FbxdMDOqRb1FwNM13G8ZBB5PauvKC/1yrg2ePxZH06SwxOiVVjqFq+1IX2P1spDr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954904; c=relaxed/simple;
	bh=fktvcBNKtM03xA2WMx2T2hn1W5zFzrEtD9OtJe1CJZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KsoO5QfZmwJD+Fjdj8vZQEcqg58dtpZPErEpCYLAU+B4pbPTy7zTiLs2nAandIpvvwTbD/n6LdAShV6ZDg7+yhpOscYDPJ+60T5N+50Zp6h/cqYpqeAvK6brBw6aXtgcyM6Y1Qu4TtycIr41y4htfCYcypNng53BIgz7Zf+9eak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOXbxwpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOXbxwpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1FBC4CED1;
	Wed, 19 Feb 2025 08:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954903;
	bh=fktvcBNKtM03xA2WMx2T2hn1W5zFzrEtD9OtJe1CJZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOXbxwplIHZtL5sy2d+E+a1Y9jwd3ANSMc/s436IcjRK9Ub2bLuQRWRYplWNVommM
	 VDW0HUpvkV8J6iY55eFM/mDSiLj3vZCpff1Latmo1nvW8e+jsY3WK7UGv3ifQg6AGF
	 GxyD0txHDdBo1AFAeDzcGRneqKKjClMAB2H0gkWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/230] PCI/DPC: Quirk PIO log size for Intel Raptor Lake-P
Date: Wed, 19 Feb 2025 09:26:29 +0100
Message-ID: <20250219082604.525002041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8103bc24a54ea..11fe6869ec3ab 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6254,6 +6254,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa72f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
-- 
2.39.5



