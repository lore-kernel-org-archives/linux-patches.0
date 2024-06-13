Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1B014374F;
	Thu, 13 Jun 2024 12:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281148; cv=none; b=BoILEa30PVPe9XUWlR0JR2yQF7bzmQDddZENmmBqwGTVB1zEo+Azv8r2isU5cOFKlTa9bN51q7q8jR7OacFMGq8hb/fQgZCynr9Si6MCgw2rcwAb8ZMQgyLr9yQfGWsB8lVSaR5TJgY46MlwyIq2CaVrY8E6roBZFyLUaDDg9VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281148; c=relaxed/simple;
	bh=8kKlm0KOGSBvSmhZ6XsJ6LrI6DHdh+O4EBgw9Fgy1Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CudRlRzJeWaF83IkprUArLL6GOM/FZgwiOMgji4/FvBzOJRYwhr/VLvSqHVgpSRfHsrkszHLUSNgg53cnmV2zGKbc5gnDG6QmU1p9FSmpCvc1UGFVfkLafDwAKKj0EkBS09WciG5vFUJKURA09yiqXo9EoD1lnk4JqKsFDZOTAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgAn712j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgAn712j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B87C2BBFC;
	Thu, 13 Jun 2024 12:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281148;
	bh=8kKlm0KOGSBvSmhZ6XsJ6LrI6DHdh+O4EBgw9Fgy1Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgAn712jrin4qIChf5ZC47pdCDM5D0m6u/iFwrPocKCZ02dfsgWf1jRBvKE+el6Cd
	 xVPbLqMoZr9yuAEAjqzkyGITIfBcjZ/aL3EwEB5QFapggTKnVQiI5tGQoQeq1XoBaS
	 jk9CThh/csQh9551Pfw4Y4dC0zYLyFymS0q1JLnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/317] f2fs: add cp_error check in f2fs_write_compressed_pages
Date: Thu, 13 Jun 2024 13:32:54 +0200
Message-ID: <20240613113253.597573743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit ee68d27181f060fab29e60d1d31aab6a42703dd4 ]

This patch adds cp_error check in f2fs_write_compressed_pages() like we did
in f2fs_write_single_data_page()

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 278a6253a673 ("f2fs: fix to relocate check condition in f2fs_fallocate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index be6f2988ac7fc..9dc2e09f0a60d 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1161,6 +1161,12 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	loff_t psize;
 	int i, err;
 
+	/* we should bypass data pages to proceed the kworkder jobs */
+	if (unlikely(f2fs_cp_error(sbi))) {
+		mapping_set_error(cc->rpages[0]->mapping, -EIO);
+		goto out_free;
+	}
+
 	if (IS_NOQUOTA(inode)) {
 		/*
 		 * We need to wait for node_write to avoid block allocation during
-- 
2.43.0



