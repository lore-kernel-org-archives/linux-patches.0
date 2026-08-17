Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C98B2F0C48;
	Mon, 17 Aug 2026 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977230; cv=none; b=JpP/G0JBLKY/f6gQ22muwB2jx13tTWZgVrFm4wojGKfZXZdl2wQJXqP2OqPAF+ohHwY2xG2k9omTCQ51D5rbErK6kj2RvafNXsRudMhBfR8s0lI55mAvZWyrEUazzO4rQOv02v0bEH5ga2ss2NJdwk4yX7nqP+g8M41O0EMeh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977230; c=relaxed/simple;
	bh=eGlUk0dipQo1Mj9tAgeq4RDZcaePeEysIhr1+dAhT0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSts8CPNi2iwVRwr9lyeyPpPpX1QuP1YGSOt5tvI6FjPGNvQaIAG4uVSCEb4KHqR19ITTZ6WH6jDqSRqI/IyQUz3tcOZJaNClLCwOLc7gtIu/vKddTWZG/axowrm76UOBAjoPoMjXs7Opy8MD+iHaR4Sndi7TA9H0YjyOr6+cVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elIQrh+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elIQrh+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405201F000E9;
	Mon, 17 Aug 2026 14:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977228;
	bh=l/PKA+xqTnZk8KTCabYbaS+1GDKYA0njCf/xDwZ1J+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elIQrh+6jch6E5MpNKCzb1Sx36QO4JWJlmUCYEdkar7YPjmfKSYqYTIXWLjW67chu
	 CZM+JqYF5gU+wFuY7JHO20l/sz2/gZpSLxXwSzGYbLZRxY0W3HhegyeWUzkuZKJ6i7
	 I/5Ma87yJBu6l+SaqMElZWgvoUuD4A3tESVJkOW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/456] keys: make keyring key-chunk byte order agree with keyring_diff_objects()
Date: Mon, 17 Aug 2026 15:30:46 +0200
Message-ID: <20260817132550.053751501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 85791380ca724..fc26d339a962b 100644
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



