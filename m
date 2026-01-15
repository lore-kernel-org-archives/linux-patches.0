Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5202D6E72;
	Thu, 15 Jan 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497756; cv=none; b=Z6fxkNWUXUYEbqq7R+YSz2fBBCiMxRMRrFjKNLKEg1tgBvuPq1HRds/8detwjMKjBGNgAB9Caieo7pHIwvU4Lz6pAfHWC7GG3h6ibqQHQ/jtXEKBxALcoMmESQPPPCX5PBOzlu6du/s8vP2Y9arzAdLXBnwJrQxjZlmaAxobxng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497756; c=relaxed/simple;
	bh=l9F2Tw25/FRBE1IegQeuwrKK414HKHE/05UU+omoYJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stEbKB9WqeevzcSGoDJRpf397spwJSbi7I4fnTBnT31pXLLwhb3ddf5R3mbB+Zq3RkO12O4Wt1Z2u1VLdpbLuXW3FVhLHrJbJrQ+1VkRNLqAIH4rFhRHPtr6HYdTaaMgO3y86AD0h/OGZXdBJic1FiKTezTvtRD8nPqL0HZF4oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUh+0GZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUh+0GZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBA3C16AAE;
	Thu, 15 Jan 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497756;
	bh=l9F2Tw25/FRBE1IegQeuwrKK414HKHE/05UU+omoYJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUh+0GZpxd7wDVg/8Ciy1rWJZUa3Hl3BhOZa+TT/HVqTpReFwOcv2caG4LUKl3PlS
	 w52x825irffSZC5FENaD1PDJo6TqLGfmpraFmqTPbPN8JElqhQS+3yc/hJDAOewW3V
	 Z1Qi4OdNcT+tNvNvBaW71k6Scly8ZE7ylKSXiTm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/554] dm-raid: fix possible NULL dereference with undefined raid type
Date: Thu, 15 Jan 2026 17:44:18 +0100
Message-ID: <20260115164253.209984408@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 2f6cfd6d7cb165a7af8877b838a9f6aab4159324 ]

rs->raid_type is assigned from get_raid_type_by_ll(), which may return
NULL. This NULL value could be dereferenced later in the condition
'if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)))'.

Add a fail-fast check to return early with an error if raid_type is NULL,
similar to other uses of this function.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f02fa6d3301f..d4a44dca33fd5 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2259,6 +2259,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



