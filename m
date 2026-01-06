Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E46355031;
	Tue,  6 Jan 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721813; cv=none; b=N0+pt5pm3P+euWvbrCClMKL0bacHE79FRRB36kMc8b7Yz8ur5BoRkyzXrZHwg42d1Cm3qbUwm/T62kw7sSDhvtgvnfAd0NVJss5rwgkIcFFETBz3Z0F72mpR+igNrSWSlMRbR7n3eN2WWH1D65LUojmbOdI5db44DGMNqmciHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721813; c=relaxed/simple;
	bh=KhJzazsBe7+N6ELWaGr5rD+hDbwPSTmIErQNlfaUv8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6tcNKpagfGCUKDP59vBtMcdXXq0UOhkVT4U4Z2dRrtt4k+jcoZvfPdj+oG8ITl0WpwwJFmM38FrRJu0HvFIziwKrvx/bx4ID+D/VF2y//jlO0p6UPOS/3S7zEmj8Xpk7NSakge/zeTHsHRD6JX0hBQtLKi379vBuBtL9rtAx3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ1mqeho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ1mqeho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461D7C116C6;
	Tue,  6 Jan 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721813;
	bh=KhJzazsBe7+N6ELWaGr5rD+hDbwPSTmIErQNlfaUv8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQ1mqehoxArOkep8BSwrZPoyuPETEdYoGaXFy6+k8Y7M8o/Qv0WdzWhdRf1bcc61X
	 TW8JOAAKQkyMYtgbsxDz5eTkl/3HvvLkLnkZ0Z0su1HCiYSXCyOEfv8fYNc4xjT3qr
	 UuOHY0vqoKvZGchWSDhoECM5eVE//qYNSKHomLc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Xiao Ni <xni@redhat.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/312] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
Date: Tue,  6 Jan 2026 18:02:33 +0100
Message-ID: <20260106170550.698431776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 7ad6ef91d8745d04aff9cce7bdbc6320d8e05fe9 ]

The variable mddev->private is first assigned to conf and then checked:

  conf = mddev->private;
  if (!conf) ...

If conf is NULL, then mddev->private is also NULL. In this case,
null-pointer dereferences can occur when calling raid5_quiesce():

  raid5_quiesce(mddev, true);
  raid5_quiesce(mddev, false);

since mddev->private is assigned to conf again in raid5_quiesce(), and conf
is dereferenced in several places, for example:

  conf->quiesce = 0;
  wake_up(&conf->wait_for_quiescent);

To fix this issue, the function should unlock mddev and return before
invoking raid5_quiesce() when conf is NULL, following the existing pattern
in raid5_change_consistency_policy().

Fixes: fa1944bbe622 ("md/raid5: Wait sync io to finish before changing group cnt")
Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/linux-raid/20251225130326.67780-1-islituo@gmail.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8b5f8a12d417..41de29206402 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7187,12 +7187,14 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
+	conf = mddev->private;
+	if (!conf) {
+		mddev_unlock_and_resume(mddev);
+		return -ENODEV;
+	}
 	raid5_quiesce(mddev, true);
 
-	conf = mddev->private;
-	if (!conf)
-		err = -ENODEV;
-	else if (new != conf->worker_cnt_per_group) {
+	if (new != conf->worker_cnt_per_group) {
 		old_groups = conf->worker_groups;
 		if (old_groups)
 			flush_workqueue(raid5_wq);
-- 
2.51.0



