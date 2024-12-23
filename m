Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95A1B3943;
	Mon, 23 Dec 2024 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969759; cv=none; b=RoFpEyPbdEsv/DoBhwsK1TNhGMOOymGFBSGqvSWTjYXAQhAKZxZEdxHI41QgijVjKaYOrNLrSCEhk9H1AcKgy4HPUhDIl5QecjTyyiyyfuaYg32bB9/hkf+pUgT6sCCiQLmmw2wj8ERpp7V5iGnC5/ffy3oj1MxKA2ZqoPC7Bk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969759; c=relaxed/simple;
	bh=UGptr6J9+6q28ELaox6G1kDJY11yAZcVJKWKIbNUi9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH+NfiHEQJugmWqyoiz8tyzcH3qXRpLRYRWHsd1FYuOUXcAMU7l5QF7sUTITL99tcWsDtrJKjrrs9gmMbFlxEojJ/ZG29a0bugy8oQK5pXC08glsO6LDN+9COIFmOGmytzHR1t6zE9LTKjtHLz6LuC9qdCXXwZta7f7GluUthH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL0oy31d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL0oy31d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBA6C4CEDC;
	Mon, 23 Dec 2024 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969759;
	bh=UGptr6J9+6q28ELaox6G1kDJY11yAZcVJKWKIbNUi9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL0oy31dqzAosrns5v19m+bx4ymhtERdunNcoQkcEOAyN1hoETY02473BAeFUEze4
	 nL1uOjwp+mNN+9la7drywMaYKfGgFa0TP8+PBTO4AywGtawP7WXUVqRlSjzgysRh5q
	 pqoHIDeytj6Mhf9UmdL7AQZES9qBxxU/SIRfQy68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/160] erofs: fix PSI memstall accounting
Date: Mon, 23 Dec 2024 16:57:06 +0100
Message-ID: <20241223155409.235948477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1a2180f6859c73c674809f9f82e36c94084682ba ]

Max Kellermann recently reported psi_group_cpu.tasks[NR_MEMSTALL] is
incorrect in the 6.11.9 kernel.

The root cause appears to be that, since the problematic commit, bio
can be NULL, causing psi_memstall_leave() to be skipped in
z_erofs_submit_queue().

Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+8tvSowiJADW2RuKyofL_CSkm_SuyZA7ME5vMLWmL6pqw@mail.gmail.com
Fixes: 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241127085236.3538334-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index a569ff9dfd04..1a00f061798a 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1679,9 +1679,9 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 			erofs_fscache_submit_bio(bio);
 		else
 			submit_bio(bio);
-		if (memstall)
-			psi_memstall_leave(&pflags);
 	}
+	if (memstall)
+		psi_memstall_leave(&pflags);
 
 	/*
 	 * although background is preferred, no one is pending for submission.
-- 
2.39.5



