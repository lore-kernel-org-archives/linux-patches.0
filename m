Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BB13314B4;
	Tue, 16 Dec 2025 11:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884919; cv=none; b=rawZ1hFq5CQogqyWT+ymF9ApqfGoGHw+BmO5XCKmJdEocaLGDzacFMN6VkSgspvFXuABLAo6TUXek0+nAdF+d8Hyh8L7yP12g7tEcYOkXptQhoaMorMkiPd65xfbr/spYRgD7KXrkOlXPfuuz/DkQ/KZ6iaOFXExQsh8eo0zTv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884919; c=relaxed/simple;
	bh=MNi5h2zP5b2DIHtPlEPS8GFZU91RxEZY9E4BugzNGxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swUjtByYWdrqZj1IyXpjyJudo7B8yFbQBsAefQKfXz3m4zuou60aqZn09IjKO6iJrOqr1RVBqLr2tVRNSWJOhNH8qaeVx4ytluhGB9/9ntxKyu2pjkmARspKG1iWVwDEM6PpHJWekcbsPILsQpc6uAwBnFlIYIVVxxXFViqPjpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqRdcRL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqRdcRL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF51C4CEF1;
	Tue, 16 Dec 2025 11:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884918;
	bh=MNi5h2zP5b2DIHtPlEPS8GFZU91RxEZY9E4BugzNGxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqRdcRL3jIXoyFXP91J7Kh/JXucpxQOICxMfQdTmXkR5ZTr5jZxeZvdmd17SNp5kF
	 YDDK4/zGxYK7U4geEeikdm2Cv1L1opfDRaio2NbjRW+GEtewz9qn/dWNXhReybOOj6
	 YhrvIZLhIM5ViuM6/kjDrqfGjDw+PfH1sXfwXiso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/354] dm-raid: fix possible NULL dereference with undefined raid type
Date: Tue, 16 Dec 2025 12:15:05 +0100
Message-ID: <20251216111333.153513336@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c69696d2540ab..b7f1cd81ab056 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2291,6 +2291,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



