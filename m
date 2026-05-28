Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20F02D9787;
	Thu, 28 May 2026 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999798; cv=none; b=QZhj0/xVRRDAnv9FA84T9NcBQguOkJi+x7IR5Oi18D5DNgjUKV2ZaLU8gNGgkrayE0V+RhJnMT5dHrGK3LQqDO5qZHuk99qsED8Mq9BWmL3njy1nm7mrotWoCgbamz9T2Xg5mfVc0sY31wS5AxJ/51SIQas1C9Gsah2uGrkv8NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999798; c=relaxed/simple;
	bh=W6oGyOVN4E/V6qpITfsNPQqnTFKC6X0DEAIZ2CsQC3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgGsjY8o03TuSEpa5u12dblwiVv0YeSsPWkM7Fv7JIkFzbd5XGRfk4AwntbPTzH1wm8QqD47M3C2ygAC37nUKwXsK0wj4KINZ3nanGY98fs33rTTp+LZ9rAoXevJN5E9+GDhABn+1G2TNWzfC3Hzwu6amV0vOszvgdC6frx151M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXtTZfiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXtTZfiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E571F000E9;
	Thu, 28 May 2026 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999797;
	bh=qhcn4KScvhDIDyZEFt/HVWwYDdnHHdJc1HgwEhWA1Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXtTZfiLkvrEUkhZMvT6mAlMcROqSU9oUAZzsXsSokZ9WB3XvIbVInDn/Xy72POrR
	 0Tx3isATU6EnRVOdLbOhuPsqosZuqkA78O8bZSo4YHlpVYdMARHGsheegxA7Vo98xW
	 9zf8pmizf9KkChkJhfR63+L4UK0zHUEPzNZ5mSLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 159/377] batman-adv: tt: fix negative tt_buff_len
Date: Thu, 28 May 2026 21:46:37 +0200
Message-ID: <20260528194643.005995600@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -455,7 +455,7 @@ struct batadv_orig_node {
 	 * @tt_buff_len: length of the last tt changeset this node received
 	 *  from the orig node
 	 */
-	s16 tt_buff_len;
+	u16 tt_buff_len;
 
 	/** @tt_buff_lock: lock that protects tt_buff and tt_buff_len */
 	spinlock_t tt_buff_lock;


