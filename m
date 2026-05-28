Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E5C339866;
	Thu, 28 May 2026 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998755; cv=none; b=m1mnrkWzloJa01VQtqGlfPvUQieuefUCXBkBhhRvk9FW5071sCoyO8/pcjc3BkYo0GIWjkbFoOZKXLwAc3nqAbtrN9EtfsJx+1OmLhPwQOrFDMFsN3aQYgULhvxyZo3SR690lggma6R1geDloHcP4+EGEGHGNOLilaCD6PDHHMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998755; c=relaxed/simple;
	bh=lcI3xrupcZ3HBoCZdt+RNktnad4A+FY+ONrurCrSxag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXwaKwsMmf4NgKJuLYYQP3A3BM5ygrM6l+ZwvZXxi7Z9vpUEnEka0ZtrOWmhi8Bt904FAfLNIgFTbsKbg0N0JGxCk1Qeko3OHuj5MS1ibPlEEBnC+r9RllTLia2AbUOUys6wcExzl6xv+MxFLbPM137Fd6Iq5DrfCCfEByR+Ks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIwATVcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIwATVcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2D1F000E9;
	Thu, 28 May 2026 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998754;
	bh=MahcfbPtcAETO6R6ZFBlejMB3ILzcwxigDFe88XWnoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIwATVcc5HOeNk68KwXhQUjm6GlMBCXv4MdgZilqMQaz/X88hblUhtCyR6/w//I1c
	 UxbjCUaK2KQRxivZ+LczOXqT89k/5iotqRI7zaq4QgN/lAiuldMIWhCHNJxtTmQeQN
	 uJLEyANy9u1zBpTiFOguiImUgJc/4IvM3EWvHa9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 287/461] block: dont overwrite bip_vcnt in bio_integrity_copy_user()
Date: Thu, 28 May 2026 21:46:56 +0200
Message-ID: <20260528194655.509567624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a319362217037..5a316d8bc5efa 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -244,7 +244,6 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 	}
 
 	bip->bip_flags |= BIP_COPY_USER;
-	bip->bip_vcnt = nr_vecs;
 	return 0;
 free_bip:
 	bio_integrity_free(bio);
-- 
2.53.0



