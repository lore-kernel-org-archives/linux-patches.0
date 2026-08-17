Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430043D50C;
	Mon, 17 Aug 2026 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975955; cv=none; b=ePbIwDFt5c9uBGliXvUQ7Ec30Ohl/Pe6uXhwqeHWPyNpqIxVzcz08yHvEOeWqpAtxPtG0hdy3tFa2ikc+KOaACdK44YQyrNzc1PvHCBEqU8P7IbZGq291ERyi+0XAdRrUDwUNaCpmUD95yv64Ao5UoorxeNk9YvIcueV3tU/5yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975955; c=relaxed/simple;
	bh=2HIX7E+B5cfaMZPtDecu9dWsuMPT4TDKbWSSffizaZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl8spOqOjal+qcrJSEMm3F6v6OTzHU5b8i7ykCOou+nCq5RW47P/oziQwnvYmUodSdG1pJFRhojpFXhYih9kn5xKB7mJgbCcN5QwwxaHiZ5HJff/mD5iYQI20vue/AJQR7Qza6vsseuKfkq4w3OEqEdToytr5pKPQ7yH7ra70Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVh9FgFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVh9FgFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489BB1F000E9;
	Mon, 17 Aug 2026 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975953;
	bh=hI+ERsY917QUy0pltP7uNwp3pAgBswhGUnJN1jx8LDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVh9FgFyjpvkrcaq+t6JtTtt6oVvIwvhS5TK5bResrS6ejwiP4Kc1L6upGBO3aQNz
	 VIsij065RyDBoS+PRQhUzEQpGMrPy/210zxEMwiLeuahPnhSowtaJsGoUN0KZtTO3i
	 0+mS5Si7F+IiUHgY/bDWLDEGm9/FuONTu61zpg4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/389] keys: fix out-of-bounds read in keyring_get_key_chunk()
Date: Mon, 17 Aug 2026 15:30:46 +0200
Message-ID: <20260817132547.296519086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3f609316a096e..165ac0d38bcfc 100644
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



