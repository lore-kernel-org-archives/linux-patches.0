Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677F22E7379;
	Thu, 28 May 2026 20:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999999; cv=none; b=BRuNIPOiJb60wpq9Wo4qaxu+0xNG38ltGLkbDNHK0JCqoQwyDMR9MqNsHofFqbgU/zNs3kdS3kibC7pBC5X6lSd8tH2eFMTLJDxmzB49WJDaLEkHRltGXiyjTZNIQOLx6Eeks+Lc0zMrXaDqg1WoP+fJfGOnQC/WjT/Jbss54YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999999; c=relaxed/simple;
	bh=LvF5SoAuhYwIdbZhgK7lpVOwreGhunaYwzX27QLx9e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMpvQFsNmMjrQUCkn8h3L+jwjw20NShTLuCBD1sk0IoTg2gZLL9y06FAOuaJuAffFxnpFVrFCzs968/pOHeJHk4bKZ0Hq7aprC4W11u2XyXSCtFh7RQJibtdFI5yqOYivoRLrY93B+BRDYJPVsWgWP4ZfVWTb/OjHaIfrhCheXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhfNRjWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhfNRjWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56821F000E9;
	Thu, 28 May 2026 20:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999998;
	bh=HoAtgKVENloJzDISrGdlkgfu1DlZkxxiKLTJm6oV6+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhfNRjWcw+OMiNz5it8na3c4mYaHkuKv5GUOvw6OHbBiywfsiix0eCc7UghR6jr+6
	 vz+jYb4471TrH2tX5QvKg+JuZO4qrGhpu9aJVXKbsgDcuhHKKnqeTRm/s5WheJQcg4
	 O2K9bRbz/xEt8om0z1XewgZujsvjuabSu73cXUnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/377] block: dont overwrite bip_vcnt in bio_integrity_copy_user()
Date: Thu, 28 May 2026 21:48:23 +0200
Message-ID: <20260528194646.040087317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 637ad3a56a3b889527d1dacea6fea2a8bd648140 ]

bio_integrity_add_page() already sets bip_vcnt to 1 for the bounce
segment. Overwriting it with nr_vecs breaks bip_vcnt <= bip_max_vcnt
on WRITE (bip_max_vcnt is 1), so the gap-merge checks in block/blk.h
read past the bip_vec[] flex array. On READ the read is in bounds
but lands on a saved user bvec instead of the bounce.

The line was added for split propagation, but bio_integrity_clone()
doesn't copy bip_vcnt and BIP_CLONE_FLAGS excludes BIP_COPY_USER.

Fixes: 3991657ae707 ("block: set bip_vcnt correctly")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511215151.346228-1-devnexen@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 12d887349c260..ab4a15437925e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -205,7 +205,6 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 	}
 
 	bip->bip_flags |= BIP_COPY_USER;
-	bip->bip_vcnt = nr_vecs;
 	return 0;
 free_bip:
 	bio_integrity_free(bio);
-- 
2.53.0



