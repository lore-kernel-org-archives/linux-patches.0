Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0202F9D83;
	Wed, 25 Feb 2026 06:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002723; cv=none; b=AhIi0au2prjRfeWw1dODHSjPEktXTqP5wKYt92nlrLtgGUFLxjCshkZu7OSl3LBbl3q397AxpOXlRAc0dNCDmNj9cRq/E6Rh29PHlAcd61Nd28MnLAShaIkkqHofZkbmv7zl5xzPHpe9fyyp/NLXkF4oRrA/hL3Z7JBzVJYADlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002723; c=relaxed/simple;
	bh=wFbgwDVLEUAalHcVib4+uYKu1+txj2YS9hylUtT4ER8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfKUh2P34Dogmbx2llmyJDgIEsQ64hxgQw6GhMfejU+amr/n0K/mi9js1qQqseDY/UfGmSBHrMggsVC9R90DEAqTCyJ7C7mdAqTXGQYkLAGo68BekTVbyIGykbTNTPQktvW5nBO1t3w6DCVcWWXVLiz2RmcHuycRH+Wrtmk+qqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3l2rlWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3l2rlWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B7CC19422;
	Wed, 25 Feb 2026 06:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002722;
	bh=wFbgwDVLEUAalHcVib4+uYKu1+txj2YS9hylUtT4ER8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3l2rlWsX8NZLTBzQAIym/ZSc1x1gCWGhdRUs5lipTrbcRCUNmqOwQqQeomo5u7Gb
	 e92ARpcB737mh3cxtTIOJGz/sM6zJmKYG4AwKOyjlUvev9MTvJxnLw84f21kbLN6Ni
	 YTA/8fBY+hP5NyergX4OsDSgDlO24XaBgtwS2oCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/641] eth: fbnic: set DMA_HINT_L4 for all flows
Date: Tue, 24 Feb 2026 17:24:19 -0800
Message-ID: <20260225012401.444916464@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bobby Eshleman <bobbyeshleman@meta.com>

[ Upstream commit 0f30a31b55c4179fc55613a75ef41d496687d465 ]

fbnic always advertises ETHTOOL_TCP_DATA_SPLIT_ENABLED via ethtool
.get_ringparam. To enable proper splitting for all flow types, even for
IP/Ethernet flows, this patch sets DMA_HINT_L4 unconditionally for all
RSS and NFC flow steering rules. According to the spec, L4 falls back to
L3 if no valid L4 is found, and L3 falls back to L2 if no L3 is found.
This makes sure that the correct header boundary is used regardless of
traffic type. This is important for zero-copy use cases where we must
ensure that all ZC packets are split correctly.

Fixes: 2b30fc01a6c7 ("eth: fbnic: Add support for HDS configuration")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/20260211-fbnic-tcp-hds-fixes-v1-3-55d050e6f606@meta.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c | 3 +++
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c     | 5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
index 95fac020eb93c..08aed4103323e 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
@@ -1142,6 +1142,9 @@ static int fbnic_set_cls_rule_ins(struct fbnic_net *fbn,
 		return -EINVAL;
 	}
 
+	dest |= FIELD_PREP(FBNIC_RPC_ACT_TBL0_DMA_HINT,
+			   FBNIC_RCD_HDR_AL_DMA_HINT_L4);
+
 	/* Write action table values */
 	act_tcam->dest = dest;
 	act_tcam->rss_en_mask = fbnic_flow_hash_2_rss_en_mask(fbn, hash_idx);
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
index 7f31e890031c0..42a186db43ea9 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
@@ -338,9 +338,8 @@ void fbnic_rss_reinit(struct fbnic_dev *fbd, struct fbnic_net *fbn)
 		else if (tstamp_mask & (1u << flow_type))
 			dest |= FBNIC_RPC_ACT_TBL0_TS_ENA;
 
-		if (act1_value[flow_type] & FBNIC_RPC_TCAM_ACT1_L4_VALID)
-			dest |= FIELD_PREP(FBNIC_RPC_ACT_TBL0_DMA_HINT,
-					   FBNIC_RCD_HDR_AL_DMA_HINT_L4);
+		dest |= FIELD_PREP(FBNIC_RPC_ACT_TBL0_DMA_HINT,
+				   FBNIC_RCD_HDR_AL_DMA_HINT_L4);
 
 		rss_en_mask = fbnic_flow_hash_2_rss_en_mask(fbn, flow_type);
 
-- 
2.51.0



