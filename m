Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADD11DE2AC;
	Tue, 17 Dec 2024 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456043; cv=none; b=iY91Fd70bu/stA48Hny8sJboFEs9JO4MO/SxAB+wz+L4+2F+vUXvwS3A289v661ctJEJNIrR3VFqDMmnamsOY5r591Xc84PNh5rFM9o0GGbHOrMY/RnyCACzRA/AQSau1vvFTjtU+2PMMya7drz9hCGqaEEMCDljXP4+5yDkc70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456043; c=relaxed/simple;
	bh=fVnVjHGiv9eGnBK0M7fdeTnD/UON0LwSygc9MSRaxNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMXNn5uP1lKAaMZzirN8CetmvoKnamfV7dNFN33G/i8RywU0LW+HG9tdaSKK9BvmAdZxQXNZhYn21DaUpwozMmi+sazq2EINlKXdn4wcCYk9Y8BUD5HeS3oCR21F/HZPCpLR/2GVL8+8t9+wYnPndtYuw5rC3sY5RFX7b2o1vAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scO3q1eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scO3q1eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6813FC4CED3;
	Tue, 17 Dec 2024 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456042;
	bh=fVnVjHGiv9eGnBK0M7fdeTnD/UON0LwSygc9MSRaxNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scO3q1eMTUxbYqctKOx3aV/zDIIQGnzaVBwETpL+1uIicxW9flda3CHgYIEmKHd34
	 MfOeqYKFUpDKkszkQnZ4voVnZQtyb4m24om42+MQpJepcyISnpoNYuM2PukTy6MBk5
	 Y2Xy3rqF7/hRAnSIDG1f3yLlBf3s7IURAjzRNx4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/109] batman-adv: Remove uninitialized data in full table TT response
Date: Tue, 17 Dec 2024 18:07:26 +0100
Message-ID: <20241217170535.130045944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 8038806db64da15721775d6b834990cacbfcf0b2 ]

The number of entries filled by batadv_tt_tvlv_generate() can be less
than initially expected in batadv_tt_prepare_tvlv_{global,local}_data()
(changes can be removed by batadv_tt_local_event() in ADD+DEL sequence
in the meantime as the lock held during the whole tvlv global/local data
generation).

Thus tvlv_len could be bigger than the actual TT entry size that need
to be sent so full table TT_RESPONSE could hold invalid TT entries such
as below.

 * 00:00:00:00:00:00   -1 [....] (  0) 88:12:4e:ad:7e:ba (179) (0x45845380)
 * 00:00:00:00:78:79 4092 [.W..] (  0) 88:12:4e:ad:7e:3c (145) (0x8ebadb8b)

Remove the extra allocated space to avoid sending uninitialized entries
for full table TT_RESPONSE in both batadv_send_other_tt_response() and
batadv_send_my_tt_response().

Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 37 ++++++++++++++++++------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index f0590f9bc2b1..bbab7491c83f 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -2754,14 +2754,16 @@ static bool batadv_tt_global_valid(const void *entry_ptr,
  *
  * Fills the tvlv buff with the tt entries from the specified hash. If valid_cb
  * is not provided then this becomes a no-op.
+ *
+ * Return: Remaining unused length in tvlv_buff.
  */
-static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
-				    struct batadv_hashtable *hash,
-				    void *tvlv_buff, u16 tt_len,
-				    bool (*valid_cb)(const void *,
-						     const void *,
-						     u8 *flags),
-				    void *cb_data)
+static u16 batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
+				   struct batadv_hashtable *hash,
+				   void *tvlv_buff, u16 tt_len,
+				   bool (*valid_cb)(const void *,
+						    const void *,
+						    u8 *flags),
+				   void *cb_data)
 {
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tvlv_tt_change *tt_change;
@@ -2775,7 +2777,7 @@ static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
 	tt_change = tvlv_buff;
 
 	if (!valid_cb)
-		return;
+		return tt_len;
 
 	rcu_read_lock();
 	for (i = 0; i < hash->size; i++) {
@@ -2801,6 +2803,8 @@ static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
 		}
 	}
 	rcu_read_unlock();
+
+	return batadv_tt_len(tt_tot - tt_num_entries);
 }
 
 /**
@@ -3076,10 +3080,11 @@ static bool batadv_send_other_tt_response(struct batadv_priv *bat_priv,
 			goto out;
 
 		/* fill the rest of the tvlv with the real TT entries */
-		batadv_tt_tvlv_generate(bat_priv, bat_priv->tt.global_hash,
-					tt_change, tt_len,
-					batadv_tt_global_valid,
-					req_dst_orig_node);
+		tvlv_len -= batadv_tt_tvlv_generate(bat_priv,
+						    bat_priv->tt.global_hash,
+						    tt_change, tt_len,
+						    batadv_tt_global_valid,
+						    req_dst_orig_node);
 	}
 
 	/* Don't send the response, if larger than fragmented packet. */
@@ -3203,9 +3208,11 @@ static bool batadv_send_my_tt_response(struct batadv_priv *bat_priv,
 			goto out;
 
 		/* fill the rest of the tvlv with the real TT entries */
-		batadv_tt_tvlv_generate(bat_priv, bat_priv->tt.local_hash,
-					tt_change, tt_len,
-					batadv_tt_local_valid, NULL);
+		tvlv_len -= batadv_tt_tvlv_generate(bat_priv,
+						    bat_priv->tt.local_hash,
+						    tt_change, tt_len,
+						    batadv_tt_local_valid,
+						    NULL);
 	}
 
 	tvlv_tt_data->flags = BATADV_TT_RESPONSE;
-- 
2.39.5



