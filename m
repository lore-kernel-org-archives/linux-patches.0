Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8581779B1;
	Tue,  8 Oct 2024 12:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390890; cv=none; b=XJPDsPRbPktJ3DpE52yz1/S++C3eXz0fX+SZTfvCegRDGUlhmJP8ITbCIak0Sig6vIXfv9POXPuxEm1VwRfA06qaKSNdZMRrCm7KVA5QFWXTmYzhR4MPkkrnCEA354neP9vgmFqNCbzHMVxywol+l7l5fkvBs8YxWyffuoggnjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390890; c=relaxed/simple;
	bh=AXBiwQ/uCbNSWHe4YoIpTYiZzVPgvalqk+BVZ2reGX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm9RKwIIR/1ym44qoMlsjL6zF/6IV7C+/ty3HTxLI04+g5VaIwBq2+QXpbaGIexkjzoZX1XR+Xrydl2k+towmQoC6WjfXjsXIsIvQHm+akQm83fU5tY81eCh0ugQekH83tP/AfLnVXoC4Sd1iKZJPPqPjqrP32wuZY7Y1zNkCzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00dG9I+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00dG9I+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6045C4CEC7;
	Tue,  8 Oct 2024 12:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390890;
	bh=AXBiwQ/uCbNSWHe4YoIpTYiZzVPgvalqk+BVZ2reGX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00dG9I+WDwY4mADmKzQfqO05d08+3CsfzEwcxRqLab3J7UCEMo9gVYEuOGxHTWnm8
	 CxmrDKksmxCTNHwIKSB8a9en/oRkBRonnhSK3djWybciuM4/ZmVkwaBvA7DJPsgSwD
	 xbGjsDztsTNi2pawkd+xhDZ22p2agVjlH/tVifFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 423/482] net: pcs: xpcs: fix the wrong register that was written back
Date: Tue,  8 Oct 2024 14:08:06 +0200
Message-ID: <20241008115705.049759543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 93ef6ee5c20e9330477930ec6347672c9e0cf5a6 upstream.

The value is read from the register TXGBE_RX_GEN_CTL3, and it should be
written back to TXGBE_RX_GEN_CTL3 when it changes some fields.

Cc: stable@vger.kernel.org
Fixes: f629acc6f210 ("net: pcs: xpcs: support to switch mode for Wangxun NICs")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20240924022857.865422-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pcs/pcs-xpcs-wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pcs/pcs-xpcs-wx.c
+++ b/drivers/net/pcs/pcs-xpcs-wx.c
@@ -109,7 +109,7 @@ static void txgbe_pma_config_1g(struct d
 	txgbe_write_pma(xpcs, TXGBE_DFE_TAP_CTL0, 0);
 	val = txgbe_read_pma(xpcs, TXGBE_RX_GEN_CTL3);
 	val = u16_replace_bits(val, 0x4, TXGBE_RX_GEN_CTL3_LOS_TRSHLD0);
-	txgbe_write_pma(xpcs, TXGBE_RX_EQ_ATTN_CTL, val);
+	txgbe_write_pma(xpcs, TXGBE_RX_GEN_CTL3, val);
 
 	txgbe_write_pma(xpcs, TXGBE_MPLLA_CTL0, 0x20);
 	txgbe_write_pma(xpcs, TXGBE_MPLLA_CTL3, 0x46);


