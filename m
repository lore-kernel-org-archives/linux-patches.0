Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318413AA2F;
	Tue, 27 Feb 2024 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042063; cv=none; b=s+NOy3V4QvWGANpphB1n7buvDtyEOuyZZnbYml96gHm/9IyAkUXix53eMACznw/9ttO/6Lgp2Y4W6ccx7ytTeIggEMohaawarbCoaqiOy3svkN2qzunVDEvWF0tGyh9y6TvpBlVGBDnO41a54LL9kAYb6Aiuf8ZeS4clxslsysU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042063; c=relaxed/simple;
	bh=H7BRoho90oWjl92rULfoflKmdEWksg7EsYUJt3Wu0Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiR4vPgf6NzmLJSbiCOontTvz2C1tIb1QkFR9eLiPaBIH+Is8r1ITZ/d3zI15RQyM6ojejY55Z/Izlyf4E+Vq2RN874NFEis9/2uLVKHhvYQoHAVA9wX9ioWlv/wEjeEdXXUS4MZovBzvLBJGowv/eXRD+wPYnNKSH/AkpY/gYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9yLV+T2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9yLV+T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D5AC433C7;
	Tue, 27 Feb 2024 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042063;
	bh=H7BRoho90oWjl92rULfoflKmdEWksg7EsYUJt3Wu0Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9yLV+T2kh8IViPIfK3+id8lHBYCUBr+RHo1pOPyWSiugYG64vGW2TpqlNVM8KVCK
	 HM9EtJDZ6ud06BR0+JROCxkG8fc1bV/m/qzuMa7EboOJ6N3KmRTe0hz8YlIUDo6ITu
	 mEFOHy+FGxKCBquWeCI5u3SShPuX3JUr6l02llRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Blazej Kucman <blazej.kucman@linux.intel.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 166/299] md: Fix missing release of active_io for flush
Date: Tue, 27 Feb 2024 14:24:37 +0100
Message-ID: <20240227131631.190587138@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

commit 855678ed8534518e2b428bcbcec695de9ba248e8 upstream.

submit_flushes
 atomic_set(&mddev->flush_pending, 1);
 rdev_for_each_rcu(rdev, mddev)
  atomic_inc(&mddev->flush_pending);
  bi->bi_end_io = md_end_flush
  submit_bio(bi);
                        /* flush io is done first */
                        md_end_flush
                         if (atomic_dec_and_test(&mddev->flush_pending))
                          percpu_ref_put(&mddev->active_io)
                          -> active_io is not released

 if (atomic_dec_and_test(&mddev->flush_pending))
  -> missing release of active_io

For consequence, mddev_suspend() will wait for 'active_io' to be zero
forever.

Fix this problem by releasing 'active_io' in submit_flushes() if
'flush_pending' is decreased to zero.

Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
Cc: stable@vger.kernel.org # v6.1+
Reported-by: Blazej Kucman <blazej.kucman@linux.intel.com>
Closes: https://lore.kernel.org/lkml/20240130172524.0000417b@linux.intel.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240201092559.910982-7-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -530,8 +530,12 @@ static void submit_flushes(struct work_s
 			rcu_read_lock();
 		}
 	rcu_read_unlock();
-	if (atomic_dec_and_test(&mddev->flush_pending))
+	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		/* The pair is percpu_ref_get() from md_flush_request() */
+		percpu_ref_put(&mddev->active_io);
+
 		queue_work(md_wq, &mddev->flush_work);
+	}
 }
 
 static void md_submit_flush_data(struct work_struct *ws)


