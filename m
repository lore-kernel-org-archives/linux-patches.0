Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5E24677F;
	Thu, 28 May 2026 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998510; cv=none; b=CfHF3ENTJrCnLGvGJDU2z9OsAxHR4vE6AauU1p2Eq+FiBrI/2hVpeHQ9BIhe9V+MTa7YsYANwJzDzz91y9btaEWmSOBvJPzZjZV6NZGA2t2iDYoRk+Sb1DOlgO6YMoyeAzoMkD08h83M/hIANINIgdZXN26mwTWBqBdf3OeBXHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998510; c=relaxed/simple;
	bh=7wopySjFNW2M2RmEKAXnmtw1I7W+YQyfcP0SnOH5N7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSc6NpkMVRxM0j9G40B3mOdyJOiqVO4UX2/rAIEI5wsnjZEJ4QuemFsvZ7S7w7D9C32fndFRylIAeRh8/730N497PE7KaN+xVzdOZsECcha5I8VUPg95N+kp829/irSmr+LfoI2zNR8g4xCOsvIvW0BRXzrNobWdHd9a1zctcbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOCqAkn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOCqAkn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D421F000E9;
	Thu, 28 May 2026 20:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998509;
	bh=viGXgnn+sVCC0dh5Ay9WWhXnvI1NzVThy11lymgwivo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOCqAkn0QuEgkrhmfsvYfVZ3qp1StLodFFH8pSvTTpvPZdlkZt1Ae96IQjDB1mdkX
	 V0n/DQdveS1uGD5u08Ho9MFqBigZHr9OVJTT4un+5Cogm//IdlBMuHBrdQcNm6PPNG
	 eBKRHBNwhAFwRBG/t4QXdvqknQaNZlugrHSVkdiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 162/461] batman-adv: tt: fix negative last_changeset_len
Date: Thu, 28 May 2026 21:44:51 +0200
Message-ID: <20260528194651.741862274@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


