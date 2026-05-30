Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27932E7379;
	Sat, 30 May 2026 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162329; cv=none; b=p9U8hMalO3y4qkMYpdHKBCVJgu/UdH9V0jv4z7A64iNzC/8l7JGaFSjFAe6SAD+UUF4IjekmcKDXsaTxFkTiW2x79d+Fjdd2BJmF/1lC3IfAhUr1URKQw6qIl9vvTNMCk7VAHJBBT9QLeDzJhXkTOkl4KGjHs01FsT47gFfY5k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162329; c=relaxed/simple;
	bh=mpDcMZHjy6Q5gnDUOIM8iyHxsfIbBcZKxxUOJH+Var4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkhrLv4nHfBW6xq7pkk+5O8P/SSwRkBpfOOGq2n7he3oySMc7jyddbJHTDU7dweKUh+y9pKERpa+PM6n7wK7v5KuJQJM0Gmx0lBBZRks0LOnRdmYcGdGxn4xSR/ZvE48ggodix5WDdsDC+XG4kSXeSZbPtwg2wQC/fDiLs81P3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVL2Jhdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVL2Jhdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05761F00893;
	Sat, 30 May 2026 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162328;
	bh=cPocOez+RvvE/5Jn6r2t6h1W9jLCXWJh89+q8zR1Vr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVL2JhdvL0pI2lIHPsB6q40osR6sGXTiUjpCdm6u3QWfUT/ffh19Th6rSLPUBC1W3
	 Ya5mU+vpUhx8UFkU6JIXyBQE+bxZDqvotEzNWDM2zklCdMOMkX9FY+VPAUnlurrptv
	 gXGh2m0fDAuWDkfyIa98R/mtpiU/59p6LmdfKtEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 888/969] batman-adv: tt: fix negative last_changeset_len
Date: Sat, 30 May 2026 18:06:52 +0200
Message-ID: <20260530160325.220093612@linuxfoundation.org>
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


