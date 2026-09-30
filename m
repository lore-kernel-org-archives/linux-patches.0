Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD7B3624BF;
	Wed, 30 Sep 2026 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787281; cv=none; b=LnKzDZtsG3yCep6HwoVzWHRMmHBdQh587ksKtiWRf0gVnlJ93u+AbJ9QjNimyuDgwbt8gEM1t3cGJ9iuQWTtm8Pnvp+Wbq3JT6w5yhTu2H4xk6VLOuCAYMhhCQkvaZfGlVq4ba3UJUdXoppBI6SPtJ0ftMQwOSc7AGd/RNGeAto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787281; c=relaxed/simple;
	bh=J7rsqt8IgEUCY+HDjN5mSOOzTH1tInWdrcINAkbO7Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7gqOPb906YjN61vZmCAzyGWz8cfLfZqkXl4AgIJWOGicK1ohlXixhVTXwfMuCA63d32wC+Yiq9nusOsc7l6W5Ymr/AS0Z6WLVhqO1CpKOzgUmjYIvApGfliXaIXnfR/d+JLfwzEF8dbH8AZFYmMlzlrT7nC8kDdkwTo/TqSs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEvHE0xo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEvHE0xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A221F000FF;
	Wed, 30 Sep 2026 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787280;
	bh=aAJDFn7P62UHaOQyTg7qrm5zUldGf9xhluUfTl4kr2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zEvHE0xo14TJxa3JAp8oqRrELZjLjb3mVAptegkfhNgTnBY3j3KisGR48/ddcIE3/
	 GIz8GYud9kHLJuwAyn9NlUq9Lj6A16H0pJm/C5rVk+JrZzfdXQCrDaOZU82C/HnVQa
	 qFf3Anr+9r0YoMuGYj73+ucJNJm0p/BXr5tc8ECo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 175/457] nfc: llcp: fix sdreq TLV list leak on parse/alloc/send failure
Date: Wed, 30 Sep 2026 17:24:40 +0200
Message-ID: <20260930152349.830726678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0c58824cb150d..224bdfa2dd0dc 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1181,7 +1181,7 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 		if (rc != 0) {
 			rc = -EINVAL;
-			goto put_local;
+			goto free_list;
 		}
 
 		if (!sdp_attrs[NFC_SDP_ATTR_URI])
@@ -1200,7 +1200,7 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 		sdreq = nfc_llcp_build_sdreq_tlv(tid, uri, uri_len);
 		if (sdreq == NULL) {
 			rc = -ENOMEM;
-			goto put_local;
+			goto free_list;
 		}
 
 		tlvs_len += sdreq->tlv_len;
@@ -1215,6 +1215,9 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 	rc = nfc_llcp_send_snl_sdreq(local, &sdreq_list, tlvs_len);
 
+free_list:
+	nfc_llcp_free_sdp_tlv_list(&sdreq_list);
+
 put_local:
 	nfc_llcp_local_put(local);
 
-- 
2.53.0



