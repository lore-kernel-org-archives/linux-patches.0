Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75A6320A37;
	Wed, 30 Sep 2026 19:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796968; cv=none; b=XpHQCafBKUlmHG0Nd2/HtXx7WWSPVsqvRcWxpvJWfeuvEC3gtXXJ//4qdNlku5A4j9rOVLHr4u9cAEiMENEkz0AAxREZmuSRBd5DfyM8qM605xIXOqKXvaEgeH6SGBX6ddOqsUwORG/iKKOLYF2KHfyJjPGkEyi9cAOz0Z4MUU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796968; c=relaxed/simple;
	bh=AUlXTPy+jlbzG87+RVzy4naPXzUbFCDx5EOR2GfNCtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxnjend13B36yHcbxbbVnTOO0+fIftWeLHUPwm+ufvgzdZuRXQxSEmZrwecKcESiTkmqssllVlkhMpRG1BBeuVudsfVCMUpsQz9F+j5lRIkr5B3e5F1yTvZlUOpJ4hTk8b364n2NFsbBFUuQIINvuKI87MOt6ln4fUQgC97P2Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZZyae6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZZyae6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2C01F000FF;
	Wed, 30 Sep 2026 19:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796966;
	bh=6WCeVR/nSGSqE3yPwwbsr98LKlhNJ5P0uYFwZZiMFJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZZyae6BkN6KBc47PNm+6it0n9HH/n4S84USB6CWeItypVsfgVqQhNB8iRfYiIXwV
	 8ZlzAgweIbn7GlCXbmQ/OLGTxVaCE0MCDlLreq74N1rMD2P2GeU97NnmD4XVlFtIi8
	 YX+8W4juQB35ES8oFZ9P0RUMNDNorNPO6KbviaCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1045/1193] nfc: llcp: fix sdreq TLV list leak on parse/alloc/send failure
Date: Wed, 30 Sep 2026 17:28:49 +0200
Message-ID: <20260930152457.436987733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa1dbf654c3e5..162549b10b7ee 100644
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



