Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A48331A61;
	Fri,  7 Aug 2026 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115981; cv=none; b=lt6Xf/8jTwUBqg1xrswHJHR5IZUzYUv9fq8+WuuOatOXgav/mdpE3UPOA2t2LZW4Jk5w+rQwYMiWxv8iEadCY6qazxJzz0J16OvgWKLD4mL1OoM8AN4gZolGmb3ds6XUmYnSMenMJIDYcFpZ38bFPcF/Vf9tcBvl6WCX2g5oBMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115981; c=relaxed/simple;
	bh=o03Glw/dsnqQXv3tnYC+Z64+HsWHjsL2mN68bZduyhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOuuOAFPCGawxnPzNlWI1ogF/79E/AUFNZrl+ovSUHqG3jHXAsafbmGCdnieSdwTw4e7WYQRDyg8nb3vSFD0UHubyFLWgVLXgSUyECtY+4Ss4vO0jZPy4DZeZWDq+xwGAtSvuzv5rvJ7jvkGZ96ljc/C/6ug1UgXVksGMi0TvS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KA+tR5XH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KA+tR5XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022C61F00A3A;
	Fri,  7 Aug 2026 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115980;
	bh=ZcdFqaws/MmgVVUsi0xpkfjJrAYiYUkZpWdoY+L796g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KA+tR5XHG+q+VL13ajAHFb8C44Vz9Qv2+3vJqkgFS9dQ5LuUihBuCmZjdEUD9lFnD
	 v1MpZmpwG2j16o6UYQJ9o3Ki0plsJijw79IGZKoLtVLBNlGoxrJ2TEVEXoqAbGvIUx
	 UaIPKqaI5pJTn5SKkL5fjj/z5Tsxq125lP4fPK8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/261] keys: fix out-of-bounds read in keyring_get_key_chunk()
Date: Fri,  7 Aug 2026 16:36:22 +0200
Message-ID: <20260807143415.914569095@linuxfoundation.org>
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

[ Upstream commit 63918731f9ae25b5deb022f118e941e6dddfcef4 ]

For description-level chunks keyring_get_key_chunk() advances the read
pointer by level * sizeof(long) past the inline prefix but only
bounds-checks the prefix, so a long enough key description is read past
its kmemdup(desc, desc_len + 1) allocation.  Compute the full byte
offset and bounds-check the description against it before reading.

The walk only reaches a description-level chunk when two keys collide
through the hash, x, type and domain_tag chunks, so this is reached from
an unprivileged add_key(2) with a crafted pair of same-type keys whose
index hashes collide; KASAN reports a slab-out-of-bounds read.

Fixes: f771fde82051 ("keys: Simplify key description management")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260719161505.2423935-2-michael.bommarito@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e105349794f23..b9ca9dc9b0c3f 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -271,6 +271,7 @@ static unsigned long keyring_get_key_chunk(const void *data, int level)
 	unsigned long chunk = 0;
 	const u8 *d;
 	int desc_len = index_key->desc_len, n = sizeof(chunk);
+	unsigned int offset;
 
 	level /= ASSOC_ARRAY_KEY_CHUNK_SIZE;
 	switch (level) {
@@ -284,12 +285,12 @@ static unsigned long keyring_get_key_chunk(const void *data, int level)
 		return (unsigned long)index_key->domain_tag;
 	default:
 		level -= 4;
-		if (desc_len <= sizeof(index_key->desc))
+		offset = sizeof(index_key->desc) + level * sizeof(long);
+		if (desc_len <= offset)
 			return 0;
 
-		d = index_key->description + sizeof(index_key->desc);
-		d += level * sizeof(long);
-		desc_len -= sizeof(index_key->desc);
+		d = index_key->description + offset;
+		desc_len -= offset;
 		if (desc_len > n)
 			desc_len = n;
 		do {
-- 
2.53.0



