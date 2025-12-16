Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DACD385CAD;
	Tue, 16 Dec 2025 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888639; cv=none; b=UbF2pMbBzt1eHDC7z18C5Vh7AzqtpasYwPgX1kXR7iG4/qJKBys1mFORPnCmZxsSRPJ01je0Dc/xzTHHB8cab3551AOLrLT8rDWDNZ2YyFLNHa9oRruEfUN4LsRaly0yeqT0R97NNytzZObQ/fisrisEfM4coSAZDi/21LhlyGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888639; c=relaxed/simple;
	bh=undE32b2AvgnwABSdFae6laubAIdYSztWmiXAP0k8gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+yFR/jHIFbz+iAcinFIXdoaCBUqrjiVlnjLaVf6UnBnslhXhBHWkMhAb60HHs7MLbDB1hRWSBeYuo595Z6n6BSYwv8cPTQx6+Aej0dqOuoVf8uF1B5Diq+7HD0w0ZliHlHdgRrmxTjkMBWpMeM+D9QPduSfcnrYmFdmuOgf5Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/iN+XlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/iN+XlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023ADC4CEF1;
	Tue, 16 Dec 2025 12:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888639;
	bh=undE32b2AvgnwABSdFae6laubAIdYSztWmiXAP0k8gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/iN+XlG0UU0VolQv5A3bdFV/JmGUIJivkjnNHR4sITQ2MyonTVAx3ZxGmjhWLoet
	 iaw5wFabpV9aBUP9rxD3br2bDfDZkM6qi4OsjKevIg3vrskBz6DBy2JDTffU7N9rsp
	 YBaj72XK7nxJQmtgVv+dtzrhXcO1BRy+JBtMOMBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/614] dm-raid: fix possible NULL dereference with undefined raid type
Date: Tue, 16 Dec 2025 12:15:59 +0100
Message-ID: <20251216111422.839711903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c6f7129e43d34..4bacdc499984b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2287,6 +2287,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



