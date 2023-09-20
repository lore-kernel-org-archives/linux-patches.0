Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018AE30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE09C433CD;
	Wed, 20 Sep 2023 12:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212964;
	bh=3TVbhVovzzTondHXNG/d4nsuXMxAmwpprgk1B5eViR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3JcchxlWrDs7uAY88rlCkuzFHaIajGtAG8//19q06G0p9u4GcF+FvVVRdjy780kH
	 sSqKoeoAHexWyQyd7ax/HYlHUjrpbPOxJH30MQjwB5v0YVZq4Uce5E0O5wRqKJmgaK
	 Xl0Fvh8WPnntoIAFrOtH60J40yGQTjpJhSBUjkto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Song Liu <songliubraving@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/367] md/bitmap: dont set max_write_behind if there is no write mostly device
Date: Wed, 20 Sep 2023 13:28:08 +0200
Message-ID: <20230920112901.477747818@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 8c13ab115b577bd09097b9d77916732e97e31b7b ]

We shouldn't set it since write behind IO should only happen to write
mostly device.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <songliubraving@fb.com>
Stable-dep-of: 44abfa6a95df ("md/md-bitmap: hold 'reconfig_mutex' in backlog_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bea8265ce9b8e..a549662ff4e51 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2480,11 +2480,30 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long backlog;
 	unsigned long old_mwb = mddev->bitmap_info.max_write_behind;
+	struct md_rdev *rdev;
+	bool has_write_mostly = false;
 	int rv = kstrtoul(buf, 10, &backlog);
 	if (rv)
 		return rv;
 	if (backlog > COUNTER_MAX)
 		return -EINVAL;
+
+	/*
+	 * Without write mostly device, it doesn't make sense to set
+	 * backlog for max_write_behind.
+	 */
+	rdev_for_each(rdev, mddev) {
+		if (test_bit(WriteMostly, &rdev->flags)) {
+			has_write_mostly = true;
+			break;
+		}
+	}
+	if (!has_write_mostly) {
+		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
+				    mdname(mddev));
+		return -EINVAL;
+	}
+
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->wb_info_pool) {
 		/* wb_info_pool is not needed if backlog is zero */
-- 
2.40.1



