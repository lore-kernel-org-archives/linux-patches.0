Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6D1A681E;
	Fri,  7 Aug 2026 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115984; cv=none; b=NT/zVaSEPLyrbrGLbTvJGyu5LQnWl2JGsIQTIEZ07UtqE7WZ2EQ5KOiM1gmf6bNN0wMvog+EJAhJTZghly2iIaPoVlInpLK+FoXYt3Oi0d9+brP0Sc3lwBJmr/TbhmKvCBOY4mu9mRR2OgV8eIxPgxy8OsWON9qYz8NSTruyLaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115984; c=relaxed/simple;
	bh=mSuY5ArGukHnVDpOQZpSO0M7uuA6cqDgbDQ+hyldEcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f28iPfE7PKmb1cQuhgiyikFrDkgfjyACCJxwr5mbKgMPvUl7cEADGfzQHfppwYff+ZsWqyalZXT7kcr94CbojMFHxqah+Xm41gIO03vdJFdMMgUieIObM31FTK1l+/VbQdfTOzqoDkyMQjS+9XZ0rVjyek0tl7fxuY8FAjVgZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWpXfn0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWpXfn0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEC01F000E9;
	Fri,  7 Aug 2026 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115983;
	bh=VOL5li3dUGIAgkVHplr5jKJvgjkyBspI0j0MNj0UONY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWpXfn0jL2lq1O08Xi7xGQR5rFN0lFm6uQrihCIlFXhd51Ts8golgVT2NOkRoUEil
	 tC/OUvKI858CrKDqxDH1tQiMqiVQnPV6asWBqym8ccBNrJQR0Vxt9O0veJKnDmf4G6
	 tcrQZ59s0AWZ9x3fhunTQEmPqWB7oLxLWy3AT3u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/261] keys: make keyring key-chunk byte order agree with keyring_diff_objects()
Date: Fri,  7 Aug 2026 16:36:23 +0200
Message-ID: <20260807143415.937164207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 58565eef0f8d861aae92abfb7658458d661cee17 ]

keyring_get_key_chunk() loads description bytes into the index chunk low
address first, while keyring_diff_objects() numbers the first differing
bit from the low end and folds the absolute byte index into the level
without removing the inline-prefix offset the level already carries.
The two disagree on byte order and bit position, so the array can be
told two keys first differ at a bit that does not differ in the chunk
the walker uses, letting crafted descriptions collide into one node.

Load the chunk in the order keyring_diff_objects() assumes and drop the
inline-prefix length when folding the byte index into the level.  This
only changes the in-memory ordering used to place keys within a keyring;
add, search and read of non-colliding keys are unaffected.

Fixes: f771fde82051 ("keys: Simplify key description management")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260719161505.2423935-3-michael.bommarito@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index b9ca9dc9b0c3f..fd95a0eb7a466 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -293,9 +293,10 @@ static unsigned long keyring_get_key_chunk(const void *data, int level)
 		desc_len -= offset;
 		if (desc_len > n)
 			desc_len = n;
+		d += desc_len;
 		do {
 			chunk <<= 8;
-			chunk |= *d++;
+			chunk |= *--d;
 		} while (--desc_len > 0);
 		return chunk;
 	}
@@ -376,7 +377,7 @@ static int keyring_diff_objects(const void *object, const void *data)
 	return -1;
 
 differ_plus_i:
-	level += i;
+	level += i - (int)sizeof(a->desc);
 differ:
 	i = level * 8 + __ffs(seg_a ^ seg_b);
 	return i;
-- 
2.53.0



