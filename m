Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD869951;
	Wed, 21 Feb 2024 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522782; cv=none; b=haq2aACCJtvmj9lGdSlv7ju+Gz1BomQBuuwqgHusL6Pn4VZhKiZiutXy9x4M+xhOk2zwRv01V3IQkNo/Lf6zutplS1EpMqAzX/lkMMpU5lqMVGPHa7Hd5nk/sYocgkwDtUhjBGNcyNTmdwfIJffezlyqay8Ik1E1QFWpMQxVSGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522782; c=relaxed/simple;
	bh=EEwodmqQtAoa4WU8QGT7gK0ghA4qutvTU3ADe66WybI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrukoJTea6XKs36wjYRnl8d0E4nNfyROWXIUG8Kq2vC1vZ6zwKlaLbPdAaH+6uRP1E566wPCHjzLoruhxmSfOvQbENuXKczmd6CIEgi10qidwVGb0hDFj9nw8xRLT0pUs0QNg79yg69227eTy/pB+5SvZSbBZ6ojcycw1F1MngY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l65dnrja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l65dnrja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF2BC433C7;
	Wed, 21 Feb 2024 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522782;
	bh=EEwodmqQtAoa4WU8QGT7gK0ghA4qutvTU3ADe66WybI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l65dnrjaObkj/MaMML68HLE3LJS4wgVmjpgYLFDzLQwZJgblXlhcZanCiUXLmruGZ
	 G/i0yKZ9FmEESsjjumScGeLgNVU1VwGnKXA1CkaHuFj9ldl9/QJ7ItlKEBSkFWnQsQ
	 EPIsZlJfofVbC9tdSsm8Gm5wel0A1HiOvpzYMyVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/476] PCI: Fix 64GT/s effective data rate calculation
Date: Wed, 21 Feb 2024 14:05:07 +0100
Message-ID: <20240221130017.306694966@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ac4f1897fa5433a1b07a625503a91b6aa9d7e643 ]

Unlike the lower rates, the PCIe 64GT/s Data Rate uses 1b/1b encoding, not
128b/130b (PCIe r6.1 sec 1.2, Table 1-1).  Correct the PCIE_SPEED2MBS_ENC()
calculation to reflect that.

Link: https://lore.kernel.org/r/20240102172701.65501-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 72280e9b23b2..2b5337980da7 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -312,7 +312,7 @@ void pci_bus_put(struct pci_bus *bus);
 
 /* PCIe speed to Mb/s reduced by encoding overhead */
 #define PCIE_SPEED2MBS_ENC(speed) \
-	((speed) == PCIE_SPEED_64_0GT ? 64000*128/130 : \
+	((speed) == PCIE_SPEED_64_0GT ? 64000*1/1 : \
 	 (speed) == PCIE_SPEED_32_0GT ? 32000*128/130 : \
 	 (speed) == PCIE_SPEED_16_0GT ? 16000*128/130 : \
 	 (speed) == PCIE_SPEED_8_0GT  ?  8000*128/130 : \
-- 
2.43.0



