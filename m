Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0C547127E;
	Tue, 21 Jul 2026 18:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656871; cv=none; b=cfwPomGZql4ZwNfciHUVSRVBzK2KS7eBqmQV24gTRSy+vHiJbAmdKxXFuop+wAkHDKQtovxMfhj5dtn5xw11Ti8PkPSKdbDv4B9FvnVFTLvVLNDHw03k2WLi15E0LcmK6jmgeehlILn0UnH9EY6mLVUO3/AtRqymiDvuwibOYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656871; c=relaxed/simple;
	bh=2LE/P0aS57sfmwtRBCJpeOuVomkpZQXQFR7aiK0yoRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLEocmMkfiPEUka7aAzevupSyeXPAFFsBvnROq7ThTpz34gjYdn8veL03S+qlpYdK6gCp24O3kIoIPiccuarUy3HEc0Gioe9rV2TbVY/cnVvriGmr4kNTsYTNpCVyk/oZkaqnJoeITbBxnmLZqyFXjP/s8QYNfCpcikFLflhvng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dN2VTL3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dN2VTL3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867401F000E9;
	Tue, 21 Jul 2026 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656870;
	bh=VT8KYmf7CX5M4xbO/I3BCU4h3jKPFXT+yW9ywcELdLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN2VTL3gfOCbievjRIeb69nGQ230mWZlXpLuE3Lu3CYa/i/bsmSRXiNHdSVLoOsMw
	 N6bD4UEIinI0OKpBGMkF3OgY/EC7OKTilreRqpJy+NIckuH39VTnWYxGV6nxMLVSrJ
	 6RearmIw/b3m/8HbQMUy50VoQfwq8wVLNKWE/0wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0549/1611] KEYS: Use acquire when reading state in keyring search
Date: Tue, 21 Jul 2026 17:11:05 +0200
Message-ID: <20260721152527.723307243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit c1201b37f666f6466ab1fd3a381c2b7a4b7e9fee ]

The negative-key race fix added release/acquire ordering for key use.

Publish payload before state; read state before payload.

keyring_search_iterator() still uses READ_ONCE() before match callbacks.
An asymmetric match callback calls asymmetric_key_ids(), which reads
key->payload.data[asym_key_ids].

Use key_read_state() there to complete that ordering.

Fixes: 363b02dab09b ("KEYS: Fix race between updating and finding a negative key")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260529033406.20673-1-hanguidong02@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index df2580072cfe16..e105349794f23e 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -576,7 +576,7 @@ static int keyring_search_iterator(const void *object, void *iterator_data)
 	struct keyring_search_context *ctx = iterator_data;
 	const struct key *key = keyring_ptr_to_key(object);
 	unsigned long kflags = READ_ONCE(key->flags);
-	short state = READ_ONCE(key->state);
+	short state = key_read_state(key);
 
 	kenter("{%d}", key->serial);
 
-- 
2.53.0



