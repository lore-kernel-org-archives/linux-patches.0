Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B7422652D;
	Thu, 28 May 2026 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999796; cv=none; b=L9mXR+OYv8+XPeNo+SE2oQOCBnJhMF/JGAkPa3Ei0MACX21tYVY0dfjWfmBQrnWteJF7SOowz/zImW6J5ZiGzxQQND2/7wJVLG9Lu9zWmlh6TffypF1YB0sSrFV56WSx5eA0rMw943UXc6sDggDVrkao/An1s439ieNao18g9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999796; c=relaxed/simple;
	bh=lu2Kis/sOOBAXviwnJAUgfyEyEY+Y9qDbcB8d6N1Sxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrGUp0U1fQW+uRF5GgMviyLSlFkWxCiPjfVkuRPz7V7ZiGvioly7gqe3FFbMvu4CmDn4ABT6f86KIQkghD49gdsdfLazJnLNXgpa44ztEvAO30r/ZA2fnP3aBPGXCO6g2mXnbGizamGYYh6U1fAIcz8yu3B4PS/ygN/kwr4i1gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtKZCft9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtKZCft9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8337A1F000E9;
	Thu, 28 May 2026 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999795;
	bh=7eZY7KMDUVC9x8lkPignuZWpu3LMtDIUZaCYiri5IDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtKZCft9mN/iKqkbFTjsJKLrx4njx7q/a81FhgElk8OLyZITUXSppysAsD5JG1k1K
	 pc5ZoY7mOb1O5uROCyD1Zzg+W2HrmTTjq7FReMA9oWsenyC05btZocfJhs1xuegmCM
	 hWnNt9+LurNHwmEF8QtsGtI5qYh7dchWYqOKk0Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 158/377] batman-adv: tt: fix negative last_changeset_len
Date: Thu, 28 May 2026 21:46:36 +0200
Message-ID: <20260528194642.974164037@linuxfoundation.org>
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
@@ -996,7 +996,7 @@ struct batadv_priv_tt {
 	 * @last_changeset_len: length of last tt changeset this host has
 	 *  generated
 	 */
-	s16 last_changeset_len;
+	u16 last_changeset_len;
 
 	/**
 	 * @last_changeset_lock: lock protecting last_changeset &


