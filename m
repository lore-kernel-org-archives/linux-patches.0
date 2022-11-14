Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1822D2F34
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A393C433D7;
	Mon, 14 Nov 2022 12:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430259;
	bh=nBlm+v1dOqo1wbfiEy6ePI7Hn9qcD82yOUJzcIHMbHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/B24uEce2ntB05o2EgHJEMt0k65ocv54T2DQhuTeaB2kSx19yO8wPR8Yu/hiv5t9
	 /H+jDCUzWr594dUQABnk3Tuzmx5jxCjM5ocqA0n/OjHSiPeb0t6nIkC1aTHyCH4HQO
	 dqQEger/flAJEmomwVqWuA6vp6cdhYa+dmDMa+vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/95] net: atlantic: macsec: clear encryption keys from the stack
Date: Mon, 14 Nov 2022 13:45:39 +0100
Message-Id: <20221114124444.402791650@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 879785def0f5e71d54399de0f8a5cb399db14171 ]

Commit aaab73f8fba4 ("macsec: clear encryption keys from the stack after
setting up offload") made sure to clean encryption keys from the stack
after setting up offloading, but the atlantic driver made a copy and did
not clear it. Fix this.

[4 Fixes tags below, all part of the same series, no need to split this]

Fixes: 9ff40a751a6f ("net: atlantic: MACSec ingress offload implementation")
Fixes: b8f8a0b7b5cb ("net: atlantic: MACSec ingress offload HW bindings")
Fixes: 27736563ce32 ("net: atlantic: MACSec egress offload implementation")
Fixes: 9d106c6dd81b ("net: atlantic: MACSec egress offload HW bindings")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_macsec.c |  2 ++
 .../aquantia/atlantic/macsec/macsec_api.c      | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 7c6e0811f2e6..ee823a18294c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -585,6 +585,7 @@ static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_egress_sakey_record(hw, &key_rec, sa_idx);
 
+	memzero_explicit(&key_rec, sizeof(key_rec));
 	return ret;
 }
 
@@ -932,6 +933,7 @@ static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
 
 	ret = aq_mss_set_ingress_sakey_record(hw, &sa_key_record, sa_idx);
 
+	memzero_explicit(&sa_key_record, sizeof(sa_key_record));
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 36c7cf05630a..431924959520 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -757,6 +757,7 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 			 u16 table_index)
 {
 	u16 packed_record[18];
+	int ret;
 
 	if (table_index >= NUMROWS_INGRESSSAKEYRECORD)
 		return -EINVAL;
@@ -789,9 +790,12 @@ set_ingress_sakey_record(struct aq_hw_s *hw,
 
 	packed_record[16] = rec->key_len & 0x3;
 
-	return set_raw_ingress_record(hw, packed_record, 18, 2,
-				      ROWOFFSET_INGRESSSAKEYRECORD +
-					      table_index);
+	ret = set_raw_ingress_record(hw, packed_record, 18, 2,
+				     ROWOFFSET_INGRESSSAKEYRECORD +
+				     table_index);
+
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_ingress_sakey_record(struct aq_hw_s *hw,
@@ -1739,14 +1743,14 @@ static int set_egress_sakey_record(struct aq_hw_s *hw,
 	ret = set_raw_egress_record(hw, packed_record, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index);
 	if (unlikely(ret))
-		return ret;
+		goto clear_key;
 	ret = set_raw_egress_record(hw, packed_record + 8, 8, 2,
 				    ROWOFFSET_EGRESSSAKEYRECORD + table_index -
 					    32);
-	if (unlikely(ret))
-		return ret;
 
-	return 0;
+clear_key:
+	memzero_explicit(packed_record, sizeof(packed_record));
+	return ret;
 }
 
 int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
-- 
2.35.1



