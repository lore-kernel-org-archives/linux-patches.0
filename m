Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C3739FD4;
	Fri, 24 Nov 2023 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O1dfBmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2CBC433C7;
	Fri, 24 Nov 2023 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849176;
	bh=XK6r3pfZa+V2I7Pg5tv84jqaMsXkYAwNtMAOXsuGKzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O1dfBmkg640SSi0OLnKBap8SebvzzeL9ZVUOo9bdberKtPNCqU7M4s2Txe2hoW9e
	 x/CG8bt0r9moYx90yuF7FAcnLi5+8chSxOBiIDEGmbfVkODbxgsjjfedB4oVH+LY1+
	 uRBSVr/xnnxZ09kda5PHjMKdASzyJNwc3EEd//54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/530] md: dont rely on mddev->pers to be set in mddev_suspend()
Date: Fri, 24 Nov 2023 17:43:39 +0000
Message-ID: <20231124172029.673614806@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit b721e7885eb242aa2459ee66bb42ceef1bcf0f0c ]

'active_io' used to be initialized while the array is running, and
'mddev->pers' is set while the array is running as well. Hence caller
must hold 'reconfig_mutex' and guarantee 'mddev->pers' is set before
calling mddev_suspend().

Now that 'active_io' is initialized when mddev is allocated, such
restriction doesn't exist anymore. In the meantime, follow up patches
will refactor mddev_suspend(), hence add checking for 'mddev->pers' to
prevent null-ptr-deref.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230825030956.1527023-4-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a104a025084dc..9247e55c7eafc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -449,7 +449,7 @@ void mddev_suspend(struct mddev *mddev)
 	set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	percpu_ref_kill(&mddev->active_io);
 
-	if (mddev->pers->prepare_suspend)
+	if (mddev->pers && mddev->pers->prepare_suspend)
 		mddev->pers->prepare_suspend(mddev);
 
 	wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io));
-- 
2.42.0



