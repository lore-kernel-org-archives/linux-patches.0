Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1833016E1;
	Thu, 28 May 2026 20:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000787; cv=none; b=amiW+MAJeCqvmxzVeRYpe3FNwKNSRA64v37M1xKsUbN+n184Sq84AbEaytXqVwEd1osUVoNvV+ubGar1Ep2ycn15nltGg5JMb3kyJWRY7KZNmmR4cr3XaEEFN7/t2h3MKKAxnN12m+XkRnoZmYOad0rsBdJD56r2GJet/yUPYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000787; c=relaxed/simple;
	bh=cVKJN7NBbS2mhEBcF0Coxk1kW2fXW0MQ9znkWrX0CXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKpQaPQhcnmdVcBAfAT76Gwc7TwRmltSmYB/J9i2otzZuasyuC1PuyJWnWZ/SQYXBEfIsozTsVUBwvN1vwzSpvQxu31sY/mPeJC4JmBeuiEkOag/7pIDlIb5veJRR1Maz39JUkFlcM3VzGDzWG/BRGwW1z5K9EirVhBXjyRPMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inW+Hsxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inW+Hsxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA6B1F000E9;
	Thu, 28 May 2026 20:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000786;
	bh=dP7iXx2r6/UxLMl1PsCu0o0g6oduMONQknB/d2iH/nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inW+HsxoK9igfioqvDnGt1qB6XP2EBppdEsqJGKPoZ+3cfQEhQRFCwHKfhOQGJiz6
	 FlYzaEAB5uB9rVU6QTW3TBUmg+5tYpqRzftsbn2NAEeA6njEab02A9TQbjMYZX82gi
	 tCiuleO5x0EQc6NeBsmaJ9X2BQrxFpquw6EjaXRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 131/272] batman-adv: tt: fix negative last_changeset_len
Date: Thu, 28 May 2026 21:48:25 +0200
Message-ID: <20260528194633.048289646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1058,7 +1058,7 @@ struct batadv_priv_tt {
 	 * @last_changeset_len: length of last tt changeset this host has
 	 *  generated
 	 */
-	s16 last_changeset_len;
+	u16 last_changeset_len;
 
 	/**
 	 * @last_changeset_lock: lock protecting last_changeset &


