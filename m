Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059E1341674
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301191; cv=none; b=TIMSCnQPxFWxJP63UkZvqEPld4CAb8T1PUoheK0AOXwUARHgb2Jbmuga7UTTuo3sFPZz1+v18lDaXNHlH1rYj/UpKx3MKf36NjQt6wBMpYg1hDFnwXla5ls8XdJftsTPHn+dXxJpOjhTAM0PU4KzKDn6RDH/ub9QhMebBndVaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301191; c=relaxed/simple;
	bh=B5NA7MK9dSDpVwXGWNK8EJa14M/xy8gqwy47uVV+8kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn+rFmbWvpwjM0n5SbC61iqu0l8CizrjYyAZ7iz+3tt+sfVVLvuqc8rOTJtNZ4NIGiWl980PVa3jTvrNOLJYzHdX1bmew0cqfCIFZFkgoZfvAkF1GFa7r+P4S8OWUCAJb4/JgVhGaxCl5HQqTfy2tyCUkFeaYrLWEVUpr0Prlkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+oGeiFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+oGeiFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B53C19424;
	Sat, 28 Feb 2026 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301190;
	bh=B5NA7MK9dSDpVwXGWNK8EJa14M/xy8gqwy47uVV+8kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+oGeiFiowlk/rYd8KOnzlQAmO8VpcyrF2vCfDKDDhHSFWsvY207dYWANIMuyiDYr
	 XY9ks1aTiVgogZpedLZJ1UqaJ6xrBSG5otU4wlLc2xbWG9gBOX1xYyd34W5zGazhx7
	 La4Q2TAMZA9gMUPGQzZQ3UREnL2+3Ub3SJah9nHipTosUnOAljdnV3Gj0qfktiYTrt
	 WFEexRWjn40qfiUgn89DhHX1GsTY1UJm8U2lA7AwLVaERj/dvpCB7t5BQw8YTnla5I
	 l7mFFYGcZmTwBcqmGhZMJg8p52iJ/i56zLnYrWZfxANJscDzql43a+/88gwC551DAb
	 PlTHMp8Qxt80w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/752] fs/ntfs3: drop preallocated clusters for sparse and compressed files
Date: Sat, 28 Feb 2026 12:41:12 -0500
Message-ID: <20260228174750.1542406-361-sashal@kernel.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 3a6aba7f3cf2b46816e08548c254d98de9c74eba ]

Do not keep preallocated clusters for sparsed and compressed files.
Preserving preallocation in these cases causes fsx failures when running
with sparse files and preallocation enabled.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index f0ff85b7d76dc..5a7675112e7b8 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -448,8 +448,10 @@ int attr_set_size(struct ntfs_inode *ni, enum ATTR_TYPE type,
 
 	is_ext = is_attr_ext(attr_b);
 	align = sbi->cluster_size;
-	if (is_ext)
+	if (is_ext) {
 		align <<= attr_b->nres.c_unit;
+		keep_prealloc = false;
+	}
 
 	old_valid = le64_to_cpu(attr_b->nres.valid_size);
 	old_size = le64_to_cpu(attr_b->nres.data_size);
-- 
2.51.0

