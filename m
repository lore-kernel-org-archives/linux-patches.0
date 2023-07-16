Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49158F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E59AC433C8;
	Sun, 16 Jul 2023 20:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539122;
	bh=U6CAtW2Odg4WQCREoGlMZ6wh7AvC/vtSsyKVcEHnjF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRIWQoXTuIQ8CsI1SvgI97PMmoJ+86sjsRXkLzlpzIfp5AGoUTG0Z2hyMXpiGejmL
	 80a1dUm2cMOc1ZCM7w5+yAN5GrHyRx9C0p2ivIACg0DJOLZ2rb7wOpJWf2kx9e4Kt1
	 R9UIf0JC5gopKbHHZbzCJIetVZEEijnFBj74w9Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 656/800] f2fs: check return value of freeze_super()
Date: Sun, 16 Jul 2023 21:48:29 +0200
Message-ID: <20230716195004.348621913@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 8bec7dd1b3f7d7769d433d67bde404de948a2d95 ]

freeze_super() can fail, it needs to check its return value and do
error handling in f2fs_resize_fs().

Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Fixes: b4b10061ef98 ("f2fs: refactor resize_fs to avoid meta updates in progress")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 67f1b58d424ed..719b1ba32a78b 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2175,7 +2175,9 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	if (err)
 		return err;
 
-	freeze_super(sbi->sb);
+	err = freeze_super(sbi->sb);
+	if (err)
+		return err;
 
 	if (f2fs_readonly(sbi->sb)) {
 		thaw_super(sbi->sb);
-- 
2.39.2



