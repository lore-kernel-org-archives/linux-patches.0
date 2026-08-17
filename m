Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9EA441041;
	Mon, 17 Aug 2026 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979835; cv=none; b=pny61rdVnPVWOYiHnqtaEj5Kxzf4Kqv+LFmnIpv0N1P4Z2t8yg5JFR6HPuofqrTMgwSDhmo6X+HOoXXHYB04dzEBW6+4O/Wxa6RGAQCqRXMMLd0AE1KmL8QA90qrmdhgQcFw+tl8s4gvqK85UfOTZjGOCdDk3CtdJNpdg3nN5o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979835; c=relaxed/simple;
	bh=2AkKCsFKZAJYx4E4VaVScoNy4vwhlq2767vAVO8YwnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTQRlF2q8zR/jC4xMQ3Sq8flYb/E4gmq/2WRJ8hYBaXOEc9onfkSWnHIh5FrY6Rl2DSeq1/OamIqyUSoP1ohdsh0XHFVqCimVu5W3yD4Xk9UH846+Af/5Whtpp8IRrp163Pzx+hHy/VR7sg7clFBSLAJpWNJw+2A5zzX6u20Nfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zn9iWa4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zn9iWa4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE651F00A3A;
	Mon, 17 Aug 2026 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979833;
	bh=s2/sTp2tiRa+sKm645WyHk0bcsRDVd9wrqQFwiiPCkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zn9iWa4SxAD8fRnGMTuQswKCjBZtYmsr24QzPZi1LmwDbTyfOzlUFMWJTnQSxDKNH
	 068OeKgUiSxI+EAfNrcd9LNA+TOq88p7ARBpm/yUSVF8RWqQ1SL/RNAtwDM7UdfC0s
	 PrAOPhwxYIKQ39EOolp5ITVzQhNtCi62W0KQur58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 324/609] keys: make keyring key-chunk byte order agree with keyring_diff_objects()
Date: Mon, 17 Aug 2026 15:30:20 +0200
Message-ID: <20260817132555.076920751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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



