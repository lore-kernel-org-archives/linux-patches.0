Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9982E7379;
	Sat, 30 May 2026 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162333; cv=none; b=R+cuanVA2N9ncw2IHwLwg+dycuhynEElRqSr0Axr8HZLCGXrE2tkvAvE+KEh3yNk7SDSqcIROjC7k/dgKNq8wic2nTTLh6mm/+VKzINDTXVu11zSr0qn6CKsNybvbGLChy6S7iNjl+GVOAzt+E+GCVvRGdgS7nqi3e1I6fMKmUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162333; c=relaxed/simple;
	bh=bkp/YjXO0g7C0/uEpd/Bi+uSzTUzG6p4PzyHa9Ez2ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hC7nH/VKzK/e+oaA2ON0+rSLZU3+2lj8YhMgtpviw71u9zlZPxsSlTT3rr/42i1/q/cCmPOxHTXdiiAFzDkp6TaSPGzPX7TQWrfM6Vb1+bHmNMBoRZo7hKMBiG9Cf/dbHPL20ncxQMNlnu4U/OV3a6c1qQD9Wogc2xgyey2a8DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvpaeYs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvpaeYs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCAE1F00893;
	Sat, 30 May 2026 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162331;
	bh=DZWF0uJm08rCmV54Q+3jpiFevzW8kthmN3yRwscUAR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvpaeYs6+VctKcKhtZpeyo3n26CWCewtGhT1VSFVmKUZSA8l+O4NwD//BwbLt3OSk
	 XTmVqoh3Z3ctK1Jj2cLU/lWNOT8qygG6aUl5w0lNhrY09gZCZ0MnelV5Xma6YmRWcd
	 E5E7mEeqpA0JNR2uf/s0DNnxtJEETxr2tAbWKS7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 889/969] batman-adv: tt: fix negative tt_buff_len
Date: Sat, 30 May 2026 18:06:53 +0200
Message-ID: <20260530160325.249846209@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


