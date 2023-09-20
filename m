Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5B2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF928C433C7;
	Wed, 20 Sep 2023 11:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211147;
	bh=U4It2bLHujKvznforhHFkOS2M/W65tFYntQ7XGkBVVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgJrgVxSuv1qfs6gZeriTqaW9ormGgX50HYALeLL9u/BzOwbbuisOrJSSibpc/68u
	 TS0usGa4c+9lTs0uk/6de+ex1iWYMeiRNa5Fppm8E9WYHGUxrQYM7+nh5ia/rkGmlI
	 /TtzwdX6wT7L9LbjFOvYmCDqYS75Anqef9A9+BXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nigel Croxon <ncroxon@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/139] md/raid1: fix error: ISO C90 forbids mixed declarations
Date: Wed, 20 Sep 2023 13:30:42 +0200
Message-ID: <20230920112839.586310725@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nigel Croxon <ncroxon@redhat.com>

[ Upstream commit df203da47f4428bc286fc99318936416253a321c ]

There is a compile error when this commit is added:
md: raid1: fix potential OOB in raid1_remove_disk()

drivers/md/raid1.c: In function 'raid1_remove_disk':
drivers/md/raid1.c:1844:9: error: ISO C90 forbids mixed declarations
and code [-Werror=declaration-after-statement]
1844 |         struct raid1_info *p = conf->mirrors + number;
     |         ^~~~~~

That's because the new code was inserted before the struct.
The change is move the struct command above this commit.

Fixes: 8b0472b50bcf ("md: raid1: fix potential OOB in raid1_remove_disk()")
Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/46d929d0-2aab-4cf2-b2bf-338963e8ba5a@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 72303c6201747..30f906a67def4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1826,12 +1826,11 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct r1conf *conf = mddev->private;
 	int err = 0;
 	int number = rdev->raid_disk;
+	struct raid1_info *p = conf->mirrors + number;
 
 	if (unlikely(number >= conf->raid_disks))
 		goto abort;
 
-	struct raid1_info *p = conf->mirrors + number;
-
 	if (rdev != p->rdev)
 		p = conf->mirrors + conf->raid_disks + number;
 
-- 
2.40.1



