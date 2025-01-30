Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB7C1DDC22;
	Thu, 30 Jan 2025 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247063; cv=none; b=Paf8BcSoCUHbdSkIuwsSGll8fMYmAAagZIpzERRYdTKoidO1c11FtyuObB3QWNWBmTCH8LZK4Chy7l+mI4Jg9wtnL5muO+qZ7aJkbKb6DjhNE18YIzcr4/VwHB31Yr6KNEQ1bE/Du2KoHR2+8KXeipiw3HigNlIRYc5GG50Dm9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247063; c=relaxed/simple;
	bh=0n9FiblZ5ElYa7taYtutX6zNwWFyVoiHlCqTRe/r7d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz7hpLff+yexXqfBf+iii2ZsLkjtioyG29GGnNzeSWgKszGBK2hQbqww8a1ZJn/lwPwp4/tmi5BEKgV4DuXUCV29hgK1gaf6UqUl7LlWG5HNdYJHN+V82uxNnrHX2A52VQDgBVvwHwQSKNe/4Ki+7+S/gi+hSsVdDZJG6htdrZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/wbWht9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/wbWht9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18102C4CED2;
	Thu, 30 Jan 2025 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247063;
	bh=0n9FiblZ5ElYa7taYtutX6zNwWFyVoiHlCqTRe/r7d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/wbWht98Cs8PG9q9QtURGi7xEMhukEu0dwH19RIUoTUF/SBCauEGBVBrO01uT/fE
	 cell0siox5wR8anc/hlG1oPZFNbXKwJMkVw3ypIIzkw1rBPVInJDxLgo4qRM+PuErN
	 MqKKS4D0H1IiQktgfFAZE7+G7pcDxxKmlXkqPM3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <2045gemini@gmail.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 5.10 029/133] md/raid5: fix atomicity violation in raid5_cache_count
Date: Thu, 30 Jan 2025 15:00:18 +0100
Message-ID: <20250130140143.683914814@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <2045gemini@gmail.com>

commit dfd2bf436709b2bccb78c2dda550dde93700efa7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2349,7 +2349,7 @@ static int grow_one_stripe(struct r5conf
 	atomic_inc(&conf->active_stripes);
 
 	raid5_release_stripe(sh);
-	conf->max_nr_stripes++;
+	WRITE_ONCE(conf->max_nr_stripes, conf->max_nr_stripes + 1);
 	return 1;
 }
 
@@ -2646,7 +2646,7 @@ static int drop_one_stripe(struct r5conf
 	shrink_buffers(sh);
 	free_stripe(conf->slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
-	conf->max_nr_stripes--;
+	WRITE_ONCE(conf->max_nr_stripes, conf->max_nr_stripes - 1);
 	return 1;
 }
 
@@ -6575,7 +6575,7 @@ raid5_set_cache_size(struct mddev *mddev
 	if (size <= 16 || size > 32768)
 		return -EINVAL;
 
-	conf->min_nr_stripes = size;
+	WRITE_ONCE(conf->min_nr_stripes, size);
 	mutex_lock(&conf->cache_size_mutex);
 	while (size < conf->max_nr_stripes &&
 	       drop_one_stripe(conf))
@@ -6587,7 +6587,7 @@ raid5_set_cache_size(struct mddev *mddev
 	mutex_lock(&conf->cache_size_mutex);
 	while (size > conf->max_nr_stripes)
 		if (!grow_one_stripe(conf, GFP_KERNEL)) {
-			conf->min_nr_stripes = conf->max_nr_stripes;
+			WRITE_ONCE(conf->min_nr_stripes, conf->max_nr_stripes);
 			result = -ENOMEM;
 			break;
 		}
@@ -7151,11 +7151,13 @@ static unsigned long raid5_cache_count(s
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


