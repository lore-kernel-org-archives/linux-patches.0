Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9C547B43F;
	Sat, 28 Feb 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301295; cv=none; b=hDhp9H0WXbU1K99Ku3u172v6MhYhpSbntXthv1z0dpyU5nUSqgzdiq8bTwQyLJxCJT9vgyP7lsAIHtCbpmIShdpcg1iz4X9fbKVgn7x7QsDIuMVEJ67CuMWS1BbPTpvWfKxaHzXJKkWsfQsRlMx57oVYgAWWCSbk+IjnDi87/5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301295; c=relaxed/simple;
	bh=7/IR8FSMgLJn+jx5lefrG4UI8KaNTEfvyd7SrohzmpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ3ApuJQSqHgtGdC+EEzRktkNx5GsakgHuylBSE6zuGoYrOnN8bIt0xbK2DmCjEDbO+8gFR8qjadC7W2ZLJKY3Otv/mZwBCzCNI+yOokoQthPxelut2Oj6ZpyPBoqc+u7WnZLFZMApBCMj5g+59HbJxEH7NKxMnQZ1EBuhnN8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uS64Q3Va; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uS64Q3Va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0304AC2BC87;
	Sat, 28 Feb 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301295;
	bh=7/IR8FSMgLJn+jx5lefrG4UI8KaNTEfvyd7SrohzmpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uS64Q3VakjevcbpepBICleT69NJurAaBXwjXqIZBA/bYzOH5ebN73NyLGb9xR8Odq
	 HRHjBS/z8WhFWcC4zlRuPpVr3gGQBil1T8s3mdxPzHPA46mdr6r5jZffKMzQBtUaC5
	 zsfAzwISi6Os4Md4jTzbtF/7WnYUhpRBo8uUz2xjwjylB1OVO/8yoPDUlweQMuurPz
	 egJwuUsWTjvevcWGw7uXlICsS7zd2YMKLfTevMxehpWtl7rX46lyy983uxt1ZtDQK4
	 n2kdtrKV+AA4Wf2CYdfj5gVVr4qR9mPDeBoWXiIbrE3d9r3m2IWAyE4nZve3bk+I4a
	 xS7lhmYBzoISg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 480/752] dm-verity: correctly handle dm_bufio_client_create() failure
Date: Sat, 28 Feb 2026 12:43:11 -0500
Message-ID: <20260228174750.1542406-480-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 119f4f04186fa4f33ee6bd39af145cdaff1ff17f ]

If either of the calls to dm_bufio_client_create() in verity_fec_ctr()
fails, then dm_bufio_client_destroy() is later called with an ERR_PTR()
argument.  That causes a crash.  Fix this.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index e41bde1d3b15b..5365b3987374a 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -533,9 +533,9 @@ void verity_fec_dtr(struct dm_verity *v)
 	mempool_exit(&f->output_pool);
 	kmem_cache_destroy(f->cache);
 
-	if (f->data_bufio)
+	if (!IS_ERR_OR_NULL(f->data_bufio))
 		dm_bufio_client_destroy(f->data_bufio);
-	if (f->bufio)
+	if (!IS_ERR_OR_NULL(f->bufio))
 		dm_bufio_client_destroy(f->bufio);
 
 	if (f->dev)
-- 
2.51.0

