Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE44D248BD0;
	Wed, 15 Jan 2025 10:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938616; cv=none; b=OAhOnI3kmcOmBy55rlpd4tIg5BFteLPbSaKWtf9rb9p6qhpuoiGe+fso3kWmQbXPyBJ0fySKMFFhho51jP6fJtZkGqLClCT6OOIroTtdSYu4U8TkbulXidpPSr4u0yFYZilyungmnQJReon9MuLA0XIJgjLApfKjbQHPh4iyzBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938616; c=relaxed/simple;
	bh=c7mfaYlJtr4oXjPiWf5T8O/EQF8jRATOMfgqMKhbP4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9gDHdFHwQPR7QYuD4937qukAZc90A1JR7sorSnsuIbY/M/QFdHJJTkcyDFrYzwPrzWrV3YstNOUb9m6ml2HzHwj0swOaG/7ST5X16GeI/I1LuZKS5/J/TCwLvcUo1WJg1eIpcjMnukxEw4O4oh4RFuRCQbqGjiBfImBrEzAQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXQLytvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXQLytvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ACBC4CEDF;
	Wed, 15 Jan 2025 10:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938615;
	bh=c7mfaYlJtr4oXjPiWf5T8O/EQF8jRATOMfgqMKhbP4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXQLytvRe3Gj+axAnrXzNfaT5kUKNVS30veWQHBsqZ2C162j3A8chKwO4neeATKUz
	 uvJHsDCCQRQ+Xqb8nfn7uJRpR5uxVbVfCFwVaU5bf9t3AUffO/2jAg6A4Q8HG0Uid6
	 kMzeNc9f0CPlr/gUsDTUm2gpsXXUMkDimJaRgW6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/129] erofs: fix PSI memstall accounting
Date: Wed, 15 Jan 2025 11:36:29 +0100
Message-ID: <20250115103554.938088566@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 1a2180f6859c73c674809f9f82e36c94084682ba upstream.

Max Kellermann recently reported psi_group_cpu.tasks[NR_MEMSTALL] is
incorrect in the 6.11.9 kernel.

The root cause appears to be that, since the problematic commit, bio
can be NULL, causing psi_memstall_leave() to be skipped in
z_erofs_submit_queue().

Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+8tvSowiJADW2RuKyofL_CSkm_SuyZA7ME5vMLWmL6pqw@mail.gmail.com
Fixes: 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20241127085236.3538334-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 9fa07436a4da..496e4c7c52a4 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1730,11 +1730,10 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 			move_to_bypass_jobqueue(pcl, qtail, owned_head);
 	} while (owned_head != Z_EROFS_PCLUSTER_TAIL);
 
-	if (bio) {
+	if (bio)
 		submit_bio(bio);
-		if (memstall)
-			psi_memstall_leave(&pflags);
-	}
+	if (memstall)
+		psi_memstall_leave(&pflags);
 
 	/*
 	 * although background is preferred, no one is pending for submission.
-- 
2.39.5



