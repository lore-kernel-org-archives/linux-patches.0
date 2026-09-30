Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B758517BAF;
	Wed, 30 Sep 2026 18:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792574; cv=none; b=CwEoUYHwiq0d5zdYpvJtPB+TKPicg+J6G+nc9DYoOFlt5ylJCJ/FvtM8KbFsw9lL2Sm81TIrrva/4fu9Py6+Cv/tY/io9wOBl1mhc9u9WH49IkDavk3ckLxL2+8MmiwF67ngBO2LgYhUJlgchovN1T+QY3T48fTd3yJ1bXcXhyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792574; c=relaxed/simple;
	bh=NVXo1rYRCyANz+moLDZUIiJQsd3Ai45sx4j4Dlf9Hs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBAdiMNQlG7kebZ+zrGjtYM+BwmYQzDVd6Z3PRYTggFkFgf34I1fvzdenyg+s74ylxapSnMTq40wuxaWF8KwXfcMjObAj1vF4i4rhhDCmqiYrtkTyH7AmYGYe5OiEO0CGDhR1YxUKlIeT+zamX/lyVPr1lkHeUeTs/AL0QERE1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuHoMdzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuHoMdzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76111F000FF;
	Wed, 30 Sep 2026 18:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792573;
	bh=1yGcd19YAcfeXlt3g18izXU7ipAB06+uloEd1V6ReDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuHoMdznHE8Dt9hCY/GFeyAlxj0/X2c6Y1bE4RqvE/BTWo0kP4TLimRWDiRfymdVT
	 Pi6WcMGA5ZBIAi9oV+J9c5dVfNkBWNW74JkILjp/It4ScQsfFQC0dUk0hUNUMO113d
	 2VcGobWtAzHr/ThiB1z76CeU1Lm5ngUPK60NFy5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 657/752] nfc: llcp: fix sdreq TLV list leak on parse/alloc/send failure
Date: Wed, 30 Sep 2026 17:28:47 +0200
Message-ID: <20260930152412.473069862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 66f4300206b82b0b143ef0d9be90cd8d29f23a47 ]

nfc_genl_llc_sdreq() builds a list of TLV nodes while walking nested
netlink attrs, but 3 error paths (nested-attr parse failure, TLV alloc
ENOMEM, nfc_llcp_send_snl_sdreq() failure) all skip freeing what was
already queued.

Route them through a new free_list label, mirroring the SDRES path in
the same file which already does this. Harmless on the success path
too -- send_snl_sdreq() drains the list as it moves nodes, so it's
already empty by the time free_list runs.

Fixes: d9b8d8e19b07 ("NFC: llcp: Service Name Lookup netlink interface")
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260914121129.2098606-1-congnt264@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index eb4f70a827e4d..8293b0419c797 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1178,7 +1178,7 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 		if (rc != 0) {
 			rc = -EINVAL;
-			goto put_local;
+			goto free_list;
 		}
 
 		if (!sdp_attrs[NFC_SDP_ATTR_URI])
@@ -1197,7 +1197,7 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 		sdreq = nfc_llcp_build_sdreq_tlv(tid, uri, uri_len);
 		if (sdreq == NULL) {
 			rc = -ENOMEM;
-			goto put_local;
+			goto free_list;
 		}
 
 		tlvs_len += sdreq->tlv_len;
@@ -1212,6 +1212,9 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 	rc = nfc_llcp_send_snl_sdreq(local, &sdreq_list, tlvs_len);
 
+free_list:
+	nfc_llcp_free_sdp_tlv_list(&sdreq_list);
+
 put_local:
 	nfc_llcp_local_put(local);
 
-- 
2.53.0



