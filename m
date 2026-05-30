Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD02233D9E;
	Sat, 30 May 2026 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165118; cv=none; b=cw5m7yMj8q72SqY+ojPGZBTc33q0Eia9I+5Xa6AvKaMeNCjwzcclzKAMw7432co/OJsl4mwGoMR1emNtf5j4FiNlMNW2N6/ZvkIClaRMSr2ibbmnBzQTwCRWvgt+6MxQA32ifrfr1LZJ54Pn9kdZMDakB6nlJHOZU29MBx+RwuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165118; c=relaxed/simple;
	bh=o5U7ZoeDz7rHQtVj2KqJvKB1VBXRhH8SVpLQ0GpIrNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDL2ORKl+9zSHaNs+QEJPvoV0t+xhBPN0gRg8a8p3NtZs+VYNMuwzgsj720PcvITzKNwVYnfi/b3UWuoQPax3RYGX+Dxx3WPlTM0wQZi6U6+7m06hj5NgZzFPXdTGmFZjGCRFnQLAikXvCOXeNqEW9ifiESw6roQo++NZkwJ19k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o66gsq7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o66gsq7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAA1F00893;
	Sat, 30 May 2026 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165117;
	bh=EwPdRyKffS2cFlfZ/z8GTROAT6rWazqZPpJILmnVVEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o66gsq7sEgddfB3TR4JAgJGxkcu49UX3NGQKbzN0mfOorca+W7ZXKS3/U9v97R5EU
	 TjEfaE65yx0/ZpS+VKyW7BpLMpmvKsc60/QT6ID50VgN3vq6eBpsROPyL3WnFDaRXO
	 Cw+G6o2Ew1Ze0U2mKU4HyOXETzWy7HwSDA4wWBIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 715/776] batman-adv: tt: fix negative tt_buff_len
Date: Sat, 30 May 2026 18:07:09 +0200
Message-ID: <20260530160258.301970603@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit b64963a2ceeb7529310b6cf253a1e540784422f4 upstream.

batadv_orig_node::tt_buff_len was declared as s16, but the field is never
intended to hold a negative value. When a value greater than 32767 is
assigned, it wraps to a negative signed integer.

In batadv_send_other_tt_response(), tt_buff_len is temporarily widened to
s32. The incorrectly negative s16 value propagates into the s32, causing
batadv_tt_prepare_tvlv_global_data() to allocate a full sized buffer but
populates only a small portion of it with the collected changeset. All
remaining bits are kept uninitialized.

Using an u16 avoids this type confusion and ensures that no (negative) sign
extension is performed in batadv_send_other_tt_response().

Cc: stable@kernel.org
Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -445,7 +445,7 @@ struct batadv_orig_node {
 	 * @tt_buff_len: length of the last tt changeset this node received
 	 *  from the orig node
 	 */
-	s16 tt_buff_len;
+	u16 tt_buff_len;
 
 	/** @tt_buff_lock: lock that protects tt_buff and tt_buff_len */
 	spinlock_t tt_buff_lock;


