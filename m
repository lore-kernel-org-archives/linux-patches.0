Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4A7B3E7;
	Mon,  4 Mar 2024 21:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588696; cv=none; b=Xg/50kpC/ZH/V92yh2DQdDF8SO4O2v0SjKmwsuDzNVWXZpd4f9VTI/axjwOPMDapYM9RFEUSvSNSSvpTAVWPmoBHmE+Ag/Ht4vZBUQiCZuIN6yNiLNvRxvcUVEGrFPGu20JlG5HoJphuw/trmpgMz3juFCpxQ6PgYtctPpe2HXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588696; c=relaxed/simple;
	bh=t2UHTZZ/nNBDwjFyyZNsd9PxvVFFsHklIpQRBV142IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOtWauWOW1LkpNxWaOxYHLkNepv909Zp26iuQsn1bFGqYXqQkYZqqLJAbWJf+0F1cTo4Hl23uh7zfjPDRJ96h88+KGhzN5yopi842RM6I/21E3b4cntaiYbYqPIu1b3QKUogm8oVzW6ZMKFVmjTjm/QXI2aKMsqPbMOZyCfTDaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFESQ8MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFESQ8MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823D0C433C7;
	Mon,  4 Mar 2024 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588695;
	bh=t2UHTZZ/nNBDwjFyyZNsd9PxvVFFsHklIpQRBV142IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFESQ8MQHgMZkk9RBiW8ZiFbthgVO9tCMLjaH21TUhoiTtulyLVE9kn3fzksNsJYv
	 560PNm6f8KkH8F5b/xAQYJl5DEjksGsof7UneuOEs/OrF0eSSNw4U2RZgAD+vS2IBs
	 ukCpp3C5fPjbLpZ1fZhsyZ3odSEzU5Poyt878onE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/215] net: hsr: Use correct offset for HSR TLV values in supervisory HSR frames
Date: Mon,  4 Mar 2024 21:22:04 +0000
Message-ID: <20240304211558.913669980@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 51dd4ee0372228ffb0f7709fa7aa0678d4199d06 ]

Current HSR implementation uses following supervisory frame (even for
HSRv1 the HSR tag is not is not present):

00000000: 01 15 4e 00 01 2d XX YY ZZ 94 77 10 88 fb 00 01
00000010: 7e 1c 17 06 XX YY ZZ 94 77 10 1e 06 XX YY ZZ 94
00000020: 77 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000030: 00 00 00 00 00 00 00 00 00 00 00 00

The current code adds extra two bytes (i.e. sizeof(struct hsr_sup_tlv))
when offset for skb_pull() is calculated.
This is wrong, as both 'struct hsrv1_ethhdr_sp' and 'hsrv0_ethhdr_sp'
already have 'struct hsr_sup_tag' defined in them, so there is no need
for adding extra two bytes.

This code was working correctly as with no RedBox support, the check for
HSR_TLV_EOT (0x00) was off by two bytes, which were corresponding to
zeroed padded bytes for minimal packet size.

Fixes: eafaa88b3eb7 ("net: hsr: Add support for redbox supervision frames")
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240228085644.3618044-1-lukma@denx.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 80cdc6f6b34c9..0323ab5023c69 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -83,7 +83,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 		return false;
 
 	/* Get next tlv */
-	total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tag->tlv.HSR_TLV_length;
+	total_length += hsr_sup_tag->tlv.HSR_TLV_length;
 	if (!pskb_may_pull(skb, total_length))
 		return false;
 	skb_pull(skb, total_length);
-- 
2.43.0



