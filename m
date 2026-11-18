Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051247;
	b=P+rZ7APW7mHw5ySxyqzjdBrS50JmbSSMharGeWf1Jgh5h7a5A4WDdr+TvYdG9vQykIIO
	 RTCsEjWzVSS3WYoP/MwuxPSXeGjamNpdXG/DHqqZLt1/huGfufSJjnM5kggR30TUjeZK1
	 3eaG41nSUZ4z/RBMXh8onpJBbOf/lJJ+bAi8zrrx7K5lK8w4Thd23Xnsx3wOnRUTsOYKk
	 KhY10QwBmh8NYnhE9GTspT0/p25NV/37b4o4ffOZm+CTorHNBxdBBzTgwDg+LYpzZ8uR2
	 CBAlbFeGKtKk/rkxq1hYxylHAQCufHzZ2NX1zNwCOpCDsnhco/7zs3qjUxTbQ67L6pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Ro16PpE3E5YgHvPuyyp5b8ywLYvxP+yKkGiDKOy1wY=;
	b=OIHl6kC3irzdo8wCzGhrOYe0c9Sv7biNV3Ljc6NFOjbvtRpjydRb+KGMi6YB5maV7qI3
	 OhA69f7c8qHoAVDp9cw3tSKZK4QyjP6KGKu/q++a/Ko34ktbJJem6owZjzaAcvCxQ62Tf
	 oSXAi1b/4nbPJxu4U+4k2La8c0y/3aoK/2Dk6pykOorLFPiK0ySLaf8bB/Kpvqb+NMgpD
	 Rq0JIWCwIZrsd2dqX9JnxPW2/BtoJnZPWfMBNotsBYgJaJ6BFJrwpRSgM7z/69eM2BZXw
	 /7b3ZxGdIy9lS/asiz8+16HiEKE13IX7CVAxcHtt7K2qnnSO25sfkAz033n9RxPRrgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M6hP6Nn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15A5606A32A;
	Thu, 19 Nov 2026 01:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M6hP6Nn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA8D1F000C5;
	Thu, 19 Nov 2026 01:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051247;
	bh=7Ro16PpE3E5YgHvPuyyp5b8ywLYvxP+yKkGiDKOy1wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1M6hP6NnC8lv2mj9Bqoi0GaaXxgXNnsWUe/dA4ij1nJESX4lQ8EpxyiiF2b0qBMUb
	 jv5R6cN1BburjPKWH+JRQASlCeCTjeC3QsWmBiSe7iDjesavhkQgdqJwX3QOVXk9EP
	 +EiB2Oo9OQ1DF8zoGDZElf50pdT6aeG2tS2uUuaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0142/2214] udf: Fix bh leak for unallocated space entries
Date: Wed, 18 Nov 2026 15:30:18 +0100
Message-ID: <20261118150015.854972352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit d95094d4c0a62ea17b8a7c6399b42381b8a55bc0 ]

When processing unallocated space entries we didn't properly release the
inode bh. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 0be3f0c4f1f3c..455b9766bad24 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1342,6 +1342,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0



