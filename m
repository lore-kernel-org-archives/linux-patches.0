Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71D44699
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BF2C433C8;
	Sun,  9 Jul 2023 11:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901432;
	bh=v65KEQYa+gJPx/xD52gelBoCgyFHxyrzVgQowJwdRgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2J/kucsaSoLvHGX3jGaaOp9VAmFNYaX+Y8u2n8L0xi3o3KdBemBbImg74+CpdtHRh
	 YnBWoB53x1iBeiLa85F0rz6CWLMr9FMDO/pCOzClOHCmTJCKk9GJuyjSRkT4oa/vVX
	 xUD6eeg3NSCDBNOz/K6mFRgmxYJwyUdYDYGJe9Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 019/431] md/raid10: fix overflow of md/safe_mode_delay
Date: Sun,  9 Jul 2023 13:09:27 +0200
Message-ID: <20230709111451.555007716@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 6beb489b2eed25978523f379a605073f99240c50 ]

There is no input check when echo md/safe_mode_delay in safe_delay_store().
And msec might also overflow when HZ < 1000 in safe_delay_show(), Fix it by
checking overflow in safe_delay_store() and use unsigned long conversion in
safe_delay_show().

Fixes: 72e02075a33f ("md: factor out parsing of fixed-point numbers")
Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230522072535.1523740-2-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d479e1656ef33..61ad7dfe0e99a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3814,8 +3814,9 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
 static ssize_t
 safe_delay_show(struct mddev *mddev, char *page)
 {
-	int msec = (mddev->safemode_delay*1000)/HZ;
-	return sprintf(page, "%d.%03d\n", msec/1000, msec%1000);
+	unsigned int msec = ((unsigned long)mddev->safemode_delay*1000)/HZ;
+
+	return sprintf(page, "%u.%03u\n", msec/1000, msec%1000);
 }
 static ssize_t
 safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
@@ -3827,7 +3828,7 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 		return -EINVAL;
 	}
 
-	if (strict_strtoul_scaled(cbuf, &msec, 3) < 0)
+	if (strict_strtoul_scaled(cbuf, &msec, 3) < 0 || msec > UINT_MAX / HZ)
 		return -EINVAL;
 	if (msec == 0)
 		mddev->safemode_delay = 0;
-- 
2.39.2



