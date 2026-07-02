Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F78E33A9C4;
	Thu,  2 Jul 2026 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009451; cv=none; b=Gkolw9RfOmd6dFEur6hFhOCfVqfwOdb92DvhZkrxen4Cocbs/NUizPP503w4xHhJClKOyNjscoyqoc/+Q42Vkgx7yOY9J7vgPpNltd9mNF+EcN+x+JF9Th1chSQi524FKv1U105z2tB/KFcxc6SguJP60ae8BZV466GRclog54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009451; c=relaxed/simple;
	bh=ZQ7ldrF5XR3YajOMhvn40izupWTclJWB5xOlJyA4ZQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUoeNpzXDm0is0DQ4x6NQmqPZfb3vaid3p3xH0W14bTMXgSV5iGpj61XvE5OWqAlIHwaz66wGTUd23yDqQIogVtgE8V5kWfbKgzeuIBJWfNfEETvafc5bTd4uc3mkdJEmSvMV/JWZfdZe+Qoe8RCe7UJKz83WN5qVOLFMwIsPgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhtUu3wF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhtUu3wF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93891F00A3D;
	Thu,  2 Jul 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009447;
	bh=CRimi7y1AwVsIEKIf+MCdXgc4pXWXXrOY8YyZ3qdL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhtUu3wF0xGO9yBshY8ztn0iEGTeQU1HawTqDkiRKI71saj6uZlW06duh2jPMgsX1
	 U0BVHnzjnid2nV8oW6yDrClIerckoxrmB+VP2rJQriVwQanmaUmbQ4agwPV+OnI29u
	 TjFdWdf/JHdRVfneVPpt3SXb7vp760E4R9rLCjqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/96] batman-adv: tvlv: avoid race of cifsnotfound handler state
Date: Thu,  2 Jul 2026 18:19:48 +0200
Message-ID: <20260702155110.161365400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit edb557b2ba38fea2c5eb710cf366c797e187218c upstream.

TVLV handlers can have the flag BATADV_TVLV_HANDLER_OGM_CIFNOTFND set to
signal that the OGM handler should be called (with NULL for data) when the
specific TVLV container was not found in the OGM. This is used by:

* DAT
* GW
* Multicast (OGM + Tracker)

The state whether the handler was executed was stored in the struct
batadv_tvlv_handler. But the TVLV processing is started without any lock.
Multiple parallel contexts processing TVLVs would therefore overwrite each
others BATADV_TVLV_HANDLER_OGM_CALLED flag in the shared
batadv_tvlv_handler.

Drop the shared BATADV_TVLV_HANDLER_OGM_CALLED flag and instead determine,
per TVLV buffer, whether a matching container was present by scanning the
packet's buffer.

Cc: stable@kernel.org
Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tvlv.c  | 63 ++++++++++++++++++++++++++++++++++++++----
 net/batman-adv/types.h |  7 -----
 2 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 84f0fb175b3313..2c224951d0195c 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -394,7 +394,6 @@ static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
 		tvlv_handler->ogm_handler(bat_priv, orig_node,
 					  BATADV_NO_FLAGS,
 					  tvlv_value, tvlv_value_len);
-		tvlv_handler->flags |= BATADV_TVLV_HANDLER_OGM_CALLED;
 	} else {
 		if (!src)
 			return NET_RX_SUCCESS;
@@ -413,6 +412,48 @@ static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
 	return NET_RX_SUCCESS;
 }
 
+/**
+ * batadv_tvlv_containers_contain() - check if a tvlv buffer holds a container
+ * @tvlv_value: tvlv content
+ * @tvlv_value_len: tvlv content length
+ * @type: tvlv container type to look for
+ * @version: tvlv container version to look for
+ *
+ * Return: true if a container of the given type and version is present in the
+ * tvlv buffer, false otherwise.
+ */
+static bool batadv_tvlv_containers_contain(void *tvlv_value,
+					   u16 tvlv_value_len, u8 type,
+					   u8 version)
+{
+	struct batadv_tvlv_hdr *tvlv_hdr;
+	u16 tvlv_value_cont_len;
+
+	while (tvlv_value_len >= sizeof(*tvlv_hdr)) {
+		tvlv_hdr = tvlv_value;
+		tvlv_value_cont_len = ntohs(tvlv_hdr->len);
+		tvlv_value = tvlv_hdr + 1;
+		tvlv_value_len -= sizeof(*tvlv_hdr);
+
+		if (tvlv_value_cont_len > tvlv_value_len)
+			break;
+
+		/* the next tvlv header is accessed assuming (at least) 2-byte
+		 * alignment, so it must start at an even offset.
+		 */
+		if (tvlv_value_cont_len & 1)
+			break;
+
+		if (tvlv_hdr->type == type && tvlv_hdr->version == version)
+			return true;
+
+		tvlv_value = (u8 *)tvlv_value + tvlv_value_cont_len;
+		tvlv_value_len -= tvlv_value_cont_len;
+	}
+
+	return false;
+}
+
 /**
  * batadv_tvlv_containers_process() - parse the given tvlv buffer to call the
  *  appropriate handlers
@@ -433,7 +474,9 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
 				   u8 *src, u8 *dst,
 				   void *tvlv_value, u16 tvlv_value_len)
 {
+	u16 tvlv_value_start_len = tvlv_value_len;
 	struct batadv_tvlv_handler *tvlv_handler;
+	void *tvlv_value_start = tvlv_value;
 	struct batadv_tvlv_hdr *tvlv_hdr;
 	u16 tvlv_value_cont_len;
 	u8 cifnotfound = BATADV_TVLV_HANDLER_OGM_CIFNOTFND;
@@ -474,12 +517,20 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(tvlv_handler,
 				 &bat_priv->tvlv.handler_list, list) {
-		if ((tvlv_handler->flags & BATADV_TVLV_HANDLER_OGM_CIFNOTFND) &&
-		    !(tvlv_handler->flags & BATADV_TVLV_HANDLER_OGM_CALLED))
-			tvlv_handler->ogm_handler(bat_priv, orig_node,
-						  cifnotfound, NULL, 0);
+		if (!(tvlv_handler->flags & BATADV_TVLV_HANDLER_OGM_CIFNOTFND))
+			continue;
 
-		tvlv_handler->flags &= ~BATADV_TVLV_HANDLER_OGM_CALLED;
+		/* if the corresponding container was present then the handler
+		 * was already called from the loop above
+		 */
+		if (batadv_tvlv_containers_contain(tvlv_value_start,
+						   tvlv_value_start_len,
+						   tvlv_handler->type,
+						   tvlv_handler->version))
+			continue;
+
+		tvlv_handler->ogm_handler(bat_priv, orig_node,
+					  cifnotfound, NULL, 0);
 	}
 	rcu_read_unlock();
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 88831374e81747..79ffd25fd4eba2 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -2492,13 +2492,6 @@ enum batadv_tvlv_handler_flags {
 	 *  will call this handler even if its type was not found (with no data)
 	 */
 	BATADV_TVLV_HANDLER_OGM_CIFNOTFND = BIT(1),
-
-	/**
-	 * @BATADV_TVLV_HANDLER_OGM_CALLED: interval tvlv handling flag - the
-	 *  API marks a handler as being called, so it won't be called if the
-	 *  BATADV_TVLV_HANDLER_OGM_CIFNOTFND flag was set
-	 */
-	BATADV_TVLV_HANDLER_OGM_CALLED = BIT(2),
 };
 
 /**
-- 
2.53.0



