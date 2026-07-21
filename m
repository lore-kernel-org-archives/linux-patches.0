Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBEA3DC4C2;
	Tue, 21 Jul 2026 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653614; cv=none; b=fFOy6Lx+02GFwVcvM0bkoydsdsGJdV1dN0RCtCyYMSKFs0dPtujy1lVvXt+AeaQlBe8/0HbTtll/1ItfkjT5PJQkWDxo0LnkNmq87e0d0XrqfY8czNfETYCaJWWYocu3JBOzXQaSiU6AuWVqDf8e+0tnR3t+A7CPc4D2iE3D3js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653614; c=relaxed/simple;
	bh=BFE1gAXaPo8JI/KId75ykKp2KaDRmF+tdJH8A61At38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWwm83EoT33Wz8ct/nmvVgD77oHPJxTtWTtAKy8Q8wpYrp6fqGw4BWd6r2AbkIBCh87KQU9bcOyGo8yVOhHAKdr4Y3S+KVeqvd2uS9UhqpqTTWtxVybcdUDjGDPcA31L+IqJivuDpuA3QEyCpXunxB0bkQMG1UgmoyyIMZIvOPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cDYB5tv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cDYB5tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B701F000E9;
	Tue, 21 Jul 2026 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653613;
	bh=uUEqXC/orzMfDDBSKoJJHHTAn3wGjUx1gzHPN3e2r0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cDYB5tvAL1BolgheLphRgWx2e9XwPCYsnNiE47T8gJHVQiJoz2VV6948APBWgRTb
	 Bq46AqLsOqhWv7dmY08TfPCTy6Eaty5gjB2ej66Ab1090RPmmamMhnShyB7neMM+Xs
	 Y+70QfKXk6+rpDpgKQ1veAIhW3gOORQOkWQ81uAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	NeilBrown <neil@brown.name>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1394/2077] cachefiles: Fix file burial to take lock when unsetting S_KERNEL_FILE
Date: Tue, 21 Jul 2026 17:17:47 +0200
Message-ID: <20260721152625.693043388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 511a018ed2afd8d415edd307ce7ad2048506f6a1 ]

Fix cachefiles_bury_object() to lock the inode of the file being buried
whilst it unsets the S_KERNEL_FILE flag.

Fixes: 07a90e97400c ("cachefiles: Implement culling daemon commands")
Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-5-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: NeilBrown <neil@brown.name>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 2c46f0decb02e4..90200410dcfd40 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -374,7 +374,7 @@ int cachefiles_bury_object(struct cachefiles_cache *cache,
 					    "Rename failed with error %d", ret);
 	}
 
-	__cachefiles_unmark_inode_in_use(object, d_inode(rep));
+	cachefiles_do_unmark_inode_in_use(object, d_inode(rep));
 	end_renaming(&rd);
 	_leave(" = 0");
 	return 0;
-- 
2.53.0



