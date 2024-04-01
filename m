Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC96F1E86C;
	Mon,  1 Apr 2024 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989568; cv=none; b=eP8xZ5jsPRIYjcizyKGIwJ2t/7d4n23TT+B1aVa34ZmDSMUC5BTqBYuzc6LBeUsVlPCtd1G/JBbWwCqBmWk/R0fvTQ3zZXc7yNFRshe1kmswLeda3A/12rRNivVhyASRCgnd+05WPD3ggCWbEUX4u2Q22ymOgR4JEjZdjv59aV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989568; c=relaxed/simple;
	bh=a2IWhpeFWE9CyRWHmfTVoxQUd5c0NFo+VNB0TBm7VUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTOCO3c/ti2JGv9sA+ahvgHy8RoK28N5tqNcWRR4e/aRZ2DtwauIrPtJMdIlsIN8idLVFmrz3VPaK1c1TzKN7qRnMBA09o+/KD6rUrIt6MngnjVLhcEo6YIcQ78H65EZ1o2aBJ4sA1k/a9BOIklD9/WGDUuB7fH39lY+l+Jad6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9X3TEhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9X3TEhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C291C43390;
	Mon,  1 Apr 2024 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989567;
	bh=a2IWhpeFWE9CyRWHmfTVoxQUd5c0NFo+VNB0TBm7VUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9X3TEhuJFfWs37Lve3+39zkPCOl8h0BvvsfgsEHg5Brg74GbyakswibpJW8XtMce
	 8HV9azAUtoPIFrfMCQd89257RSSum1P/yBBRlKx+Xz/kmkiMJPvEgItmz8sNsLpTTt
	 yj9Tru8pMqsozdJEgSWa1SWb7cjELPG/Xi4efIZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <2045gemini@gmail.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/396] md/raid5: fix atomicity violation in raid5_cache_count
Date: Mon,  1 Apr 2024 17:41:48 +0200
Message-ID: <20240401152549.684163679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Gui-Dong Han <2045gemini@gmail.com>

[ Upstream commit dfd2bf436709b2bccb78c2dda550dde93700efa7 ]

In raid5_cache_count():
    if (conf->max_nr_stripes < conf->min_nr_stripes)
        return 0;
    return conf->max_nr_stripes - conf->min_nr_stripes;
The current check is ineffective, as the values could change immediately
after being checked.

In raid5_set_cache_size():
    ...
    conf->min_nr_stripes = size;
    ...
    while (size > conf->max_nr_stripes)
        conf->min_nr_stripes = conf->max_nr_stripes;
    ...

Due to intermediate value updates in raid5_set_cache_size(), concurrent
execution of raid5_cache_count() and raid5_set_cache_size() may lead to
inconsistent reads of conf->max_nr_stripes and conf->min_nr_stripes.
The current checks are ineffective as values could change immediately
after being checked, raising the risk of conf->min_nr_stripes exceeding
conf->max_nr_stripes and potentially causing an integer overflow.

This possible bug is found by an experimental static analysis tool
developed by our team. This tool analyzes the locking APIs to extract
function pairs that can be concurrently executed, and then analyzes the
instructions in the paired functions to identify possible concurrency bugs
including data races and atomicity violations. The above possible bug is
reported when our tool analyzes the source code of Linux 6.2.

To resolve this issue, it is suggested to introduce local variables
'min_stripes' and 'max_stripes' in raid5_cache_count() to ensure the
values remain stable throughout the check. Adding locks in
raid5_cache_count() fails to resolve atomicity violations, as
raid5_set_cache_size() may hold intermediate values of
conf->min_nr_stripes while unlocked. With this patch applied, our tool no
longer reports the bug, with the kernel configuration allyesconfig for
x86_64. Due to the lack of associated hardware, we cannot test the patch
in runtime testing, and just verify it according to the code logic.

Fixes: edbe83ab4c27 ("md/raid5: allow the stripe_cache to grow and shrink.")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <2045gemini@gmail.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240112071017.16313-1-2045gemini@gmail.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 68d86dbecb4ac..212bf85edad03 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2420,7 +2420,7 @@ static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 	atomic_inc(&conf->active_stripes);
 
 	raid5_release_stripe(sh);
-	conf->max_nr_stripes++;
+	WRITE_ONCE(conf->max_nr_stripes, conf->max_nr_stripes + 1);
 	return 1;
 }
 
@@ -2717,7 +2717,7 @@ static int drop_one_stripe(struct r5conf *conf)
 	shrink_buffers(sh);
 	free_stripe(conf->slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
-	conf->max_nr_stripes--;
+	WRITE_ONCE(conf->max_nr_stripes, conf->max_nr_stripes - 1);
 	return 1;
 }
 
@@ -6901,7 +6901,7 @@ raid5_set_cache_size(struct mddev *mddev, int size)
 	if (size <= 16 || size > 32768)
 		return -EINVAL;
 
-	conf->min_nr_stripes = size;
+	WRITE_ONCE(conf->min_nr_stripes, size);
 	mutex_lock(&conf->cache_size_mutex);
 	while (size < conf->max_nr_stripes &&
 	       drop_one_stripe(conf))
@@ -6913,7 +6913,7 @@ raid5_set_cache_size(struct mddev *mddev, int size)
 	mutex_lock(&conf->cache_size_mutex);
 	while (size > conf->max_nr_stripes)
 		if (!grow_one_stripe(conf, GFP_KERNEL)) {
-			conf->min_nr_stripes = conf->max_nr_stripes;
+			WRITE_ONCE(conf->min_nr_stripes, conf->max_nr_stripes);
 			result = -ENOMEM;
 			break;
 		}
@@ -7478,11 +7478,13 @@ static unsigned long raid5_cache_count(struct shrinker *shrink,
 				       struct shrink_control *sc)
 {
 	struct r5conf *conf = container_of(shrink, struct r5conf, shrinker);
+	int max_stripes = READ_ONCE(conf->max_nr_stripes);
+	int min_stripes = READ_ONCE(conf->min_nr_stripes);
 
-	if (conf->max_nr_stripes < conf->min_nr_stripes)
+	if (max_stripes < min_stripes)
 		/* unlikely, but not impossible */
 		return 0;
-	return conf->max_nr_stripes - conf->min_nr_stripes;
+	return max_stripes - min_stripes;
 }
 
 static struct r5conf *setup_conf(struct mddev *mddev)
-- 
2.43.0



