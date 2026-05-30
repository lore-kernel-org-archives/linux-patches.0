Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFF8241C8C;
	Sat, 30 May 2026 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164982; cv=none; b=A5aELN/fnRYjxOjMDfRAunpP0Hi4s53pZtN78F4BNLF010kOl8l999EwZbuKNH9YfbKZiMzhp/XAa2jYcuvlOEyjB/47EthCglF1sh7BoIZfPj5w+qKJm948/mjA4pESZFJZwj8Vdn7fPmg4MKWo6OcSJ26krndDqZluPh3XQl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164982; c=relaxed/simple;
	bh=4asvzPisuQGJOHUQlNO1Ythnu5lJiHh8rFdtHGYtWtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwyYY4cDA+wcuYDrzDkPmbxJgohyv7B3lvDDworZ0LnJBo/Em9Im9iTBA7sANiCvZaN3kxyvPHBraQiqEL/indhHvu3NkH8V5Rb1AP17KxnmpmIomg/DP+7Y+H+wK+tknzNahmca0KaeH9ldC8RL25+W7PGS1DTuScFZkQEf2h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT3qUWAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT3qUWAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47751F00893;
	Sat, 30 May 2026 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164981;
	bh=EkJP6PErGV2vp5qec5Cvr1dH/7G1j4mJ6vVNVldEvE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT3qUWADcbKIudJX1cBSDPjzLbpFpZHP3ISEGdVDoe7sM6mSF5bK2mBadgGdfI5IR
	 swcFEz0R4rm0wG/Fvjk9ht8aIVfs5l8ArzO5dy6cxbtuAG4+GzlpBTbZyX5gBCu+7Y
	 8hEFpc9gYESjLQ6g4RJWVGnN4VWZfpqg5c2sGaRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 714/776] batman-adv: tt: fix negative last_changeset_len
Date: Sat, 30 May 2026 18:07:08 +0200
Message-ID: <20260530160258.279641017@linuxfoundation.org>
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

commit fc92cdfcb295cefa4344d71a527d61b638b7bfc4 upstream.

batadv_piv_tt::last_changeset_len len was declared as s16, but the field is
never intended to hold a negative value. When a value greater than 32767 is
assigned, it wraps to a negative signed integer.

In batadv_send_my_tt_response(), last_changeset_len is temporarily widened
to s32. The incorrectly negative s16 value propagates into the s32, causing
batadv_tt_prepare_tvlv_local_data() to allocate a full sized buffer but
populates only a small portion of it with the collected changeset. All
remaining bits are kept uninitialized.

Using an u16 avoids this type confusion and ensures that no (negative) sign
extension is performed in batadv_send_my_tt_response().

Cc: stable@kernel.org
Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -993,7 +993,7 @@ struct batadv_priv_tt {
 	 * @last_changeset_len: length of last tt changeset this host has
 	 *  generated
 	 */
-	s16 last_changeset_len;
+	u16 last_changeset_len;
 
 	/**
 	 * @last_changeset_lock: lock protecting last_changeset &


