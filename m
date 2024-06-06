Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A11B3F3E;
	Thu,  6 Jun 2024 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683438; cv=none; b=BbXdf6XM3dDLt0eOpupYyo1glUXcTxNMiTiW+ygzIhSabL0gp83xp/2hXaklqDtRBLpyAqWHg4Fs/bzBYvdhNWIxNjyE8lk07OmLz0Ba+wgj3YlK6VXI4orHXIe9XLAqiB7KCLJYWZckZgHXT2OQvne736+Mn+J4Zyt2xJ7aU60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683438; c=relaxed/simple;
	bh=+IJmIlqA/riTXVR2Sm6TD23VPgMbcFVSSm9YptM8dKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT3YHQ/xIoSvxNOs0N7egWW5MqGq3RmwvIdVdkQyJEMwlsCZADTpDpwLc5cLRYdb5z27+7nMkwVEfifJ0qn/FFSY7MGE4IWMDz+ZsbzYnCSMEgdBABGCQGdsOUA8CCHSSP0ajndItV3NYsLVjgm8JzIs2yXxapP5EVuR5nlNFwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOUg6RF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOUg6RF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B1C2BD10;
	Thu,  6 Jun 2024 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683438;
	bh=+IJmIlqA/riTXVR2Sm6TD23VPgMbcFVSSm9YptM8dKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOUg6RF2492I9QdXVCuMTZuVFhW2oCZI6p9OOjxZPt2GggvL0yZW5DtdgkOQz6WUp
	 BBWnQJPbXyReovLDzDWzTy34xTJi10EsKibN0/f16IXSLCJqedMdM9oDE00qTeHPSv
	 4JYC6vX5OOURMOKe4wkGN9KEvrzl5AWfGUop1iiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 365/744] ext4: fix potential unnitialized variable
Date: Thu,  6 Jun 2024 16:00:37 +0200
Message-ID: <20240606131744.188387826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3f4830abd236d0428e50451e1ecb62e14c365e9b ]

Smatch complains "err" can be uninitialized in the caller.

    fs/ext4/indirect.c:349 ext4_alloc_branch()
    error: uninitialized symbol 'err'.

Set the error to zero on the success path.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/363a4673-0fb8-4adf-b4fb-90a499077276@moroto.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a8a3ea2fd690f..aadfeb0f5b7f3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6144,6 +6144,7 @@ ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
+	*errp = 0;
 	return block;
 }
 
-- 
2.43.0



