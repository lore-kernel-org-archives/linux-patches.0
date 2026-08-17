Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DE23B8409;
	Mon, 17 Aug 2026 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977224; cv=none; b=u5hGRYAs6bH0PmGnOCzDhBOuVUkigJcdr5RoqejbktZ2Y7k/lKXdwA3shFo++1ZRF2iF2iU2V6ls1ndXEICqQIK6+0GFEJNRa64ce/XwpetqQPrE5txnPuZyub+cMc7kRQb/Q2+irIHieNwH3sQIdaRrXJ39SwjIi/PLCLPBOTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977224; c=relaxed/simple;
	bh=a9Hs7qkk8+VRUYslO+QhPPG122VWWtg9Msup5z8OrGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRaZgtUMtwqf0y5A0gZj7K8TsDZ5etjn8XSccNJ/E4Z1UD6h7yibbk4lxrrTUq5KwsymFivQpeqCGwHPAIY4gHO5FS78H7u0FcHcJFTMOSn4gI7Sp4LbRWY8s/MJcT/Zdt6hlreo2uPt2uobHOBd4voE1pB5ioYvppD4dvOpfVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL4e3bZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL4e3bZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9761F000E9;
	Mon, 17 Aug 2026 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977223;
	bh=NI0kIgyH6HS26PsUaQ+VFt6xB2/dQxf+a5wvlGIYW7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tL4e3bZuU3D9Y/lUZIxnslykSp14ao5CEL9pSdcU3FOTSam0oJlrmHp2wwg1jmYOt
	 9CPhWBM0GavXY4tPR4DQKWTP/uhPKFz/5UL/+rc986vo9Vckt7+cPiZDmV4aZHYVyn
	 clI9YDeJBwvBmj2bhT4SKcf6tfoSby/IZC5KqAb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/456] keys: fix out-of-bounds read in keyring_get_key_chunk()
Date: Mon, 17 Aug 2026 15:30:45 +0200
Message-ID: <20260817132550.018328814@linuxfoundation.org>
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
index 08aaa9429ab36..85791380ca724 100644
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



