Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B00938655E;
	Fri,  7 Aug 2026 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114935; cv=none; b=MwmehR4d25WfGDQUEMCmglxPvTvPbek1h5zhYQSQTN1ZhwR2gVbAdRiOlJDvsDHlG9GPAc7LXIuwCwbATmqt7e+AqnVLEmqXqNqHB3B5jmXD8Z98/jHfyvq37xRz7jw1BdHUMmLqBMhD5Xkhn51FvsvQC/7AndtQgb2ISP1n2ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114935; c=relaxed/simple;
	bh=haOvIAU56pPdkZTI7nWbzw0/u4wZi4jpCFoTVAhgIU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEWXPpqr+iHeCsn5UNV0Y8c0KCyTyVpK3cASST9/44YeCawtwlMku/C87vWl5D2wSTxsgBf6B5IOqkpXKo5MlSsq9fNGFpwp2U38JHL4vSOQX7TQWaLgo7fQoMEykdFMqSY2sy+aX4IP81tT7Eq2QlxIW0vh8ULJ0huzseCMdYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvohftTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvohftTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F0D1F000E9;
	Fri,  7 Aug 2026 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114934;
	bh=YRqJTYDf1TPVx75ugR/DNKXqI3QGRG7ggty5gxfawds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvohftTW6lGpQzxAuL6pGdPyJn6K8VUtmO+CREZO4BXp18OuOSTHSu5w6qMaipvgz
	 HjB3G3mMpH65X7UjwRwSgR7rcbSY3p9nfDWXR6deyJQ1aG3NoxeUayA3s//gI0S4bM
	 lR8x2fHeKUu8H5OUp2ehVduKvO3JzbsJwfGyeK98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/396] keys: fix out-of-bounds read in keyring_get_key_chunk()
Date: Fri,  7 Aug 2026 16:33:24 +0200
Message-ID: <20260807143425.218972623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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



