Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375F7275B05;
	Sat, 14 Feb 2026 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104381; cv=none; b=M4rMagpI1xeM9XNcTYUEZpOM+oCifa8GCJgDj31Nt1NWC565FisJxLPSGfrbyMino+uMBMApUhcKh8ApR4yYovemN4Z9bDdqarTAr9RuyU3IKuEwxfm7vYdneZ+GQXuZivIohE4xNivkw3YSB2ZmoOR0YiIU6f4iWu384KTnNLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104381; c=relaxed/simple;
	bh=Yc6Hz2NzR43xwM+v1LiT4qWfratqkw1Gff3kzL7+FQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7OVSbgxVIURR0A5NCv3PPtc6sXoWEHwwenQyOEGM7l4/TKWie24fqTjEoQIbws3UVpeAg1gZDkRw834QE4gTEVW1Mnx5EZ6RCO5h9Or5uzVcA23OKunGx00P7/vUE4n8m1m4CkFINtEwn5JaRttJj3LsXSgyRYAV98aNmvLz4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpUliKP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpUliKP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19801C19422;
	Sat, 14 Feb 2026 21:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104381;
	bh=Yc6Hz2NzR43xwM+v1LiT4qWfratqkw1Gff3kzL7+FQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpUliKP+2HGmjCdYfr/vfU7W11PSyJpvlGlNC1RETqb3BcxfW3vD6jP7Xf4mKYqrz
	 E96df7ZWV4B07hGO6IiQ15wDvCloceJ/tfYstZ+5RWpE7Fqt+z5CcePri1aclEVcn2
	 wvQOmqLT5RdjkWiVSAbWQKmKkxr/RIN0ACu3mY3P5sGHWtC0vmLgX0sIF0wDuMpfwp
	 3usjalZUBp8dmT+DJR+l+QUnTmRRkdfi59Ojd7Po8oazgmJGLOhi8sbp2GGlTBpS1W
	 ISajNWdnp6WBek6RqcyjRuRyYYcIPuHi+oy1mpie9Xf7ji08oLV+ddhhDe1f7e+H/e
	 yFE6sHghnG3Gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ding Hui <dinghui@sangfor.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.10] dm: remove fake timeout to avoid leak request
Date: Sat, 14 Feb 2026 16:23:19 -0500
Message-ID: <20260214212452.782265-54-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit f3a9c95a15d2f4466acad5c68faeff79ca5e9f47 ]

Since commit 15f73f5b3e59 ("blk-mq: move failure injection out of
blk_mq_complete_request"), drivers are responsible for calling
blk_should_fake_timeout() at appropriate code paths and opportunities.

However, the dm driver does not implement its own timeout handler and
relies on the timeout handling of its slave devices.

If an io-timeout-fail error is injected to a dm device, the request
will be leaked and never completed, causing tasks to hang indefinitely.

Reproduce:
1. prepare dm which has iscsi slave device
2. inject io-timeout-fail to dm
   echo 1 >/sys/class/block/dm-0/io-timeout-fail
   echo 100 >/sys/kernel/debug/fail_io_timeout/probability
   echo 10 >/sys/kernel/debug/fail_io_timeout/times
3. read/write dm
4. iscsiadm -m node -u

Result: hang task like below
[  862.243768] INFO: task kworker/u514:2:151 blocked for more than 122 seconds.
[  862.244133]       Tainted: G            E       6.19.0-rc1+ #51
[  862.244337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.244718] task:kworker/u514:2  state:D stack:0     pid:151   tgid:151   ppid:2      task_flags:0x4288060 flags:0x00080000
[  862.245024] Workqueue: iscsi_ctrl_3:1 __iscsi_unbind_session [scsi_transport_iscsi]
[  862.245264] Call Trace:
[  862.245587]  <TASK>
[  862.245814]  __schedule+0x810/0x15c0
[  862.246557]  schedule+0x69/0x180
[  862.246760]  blk_mq_freeze_queue_wait+0xde/0x120
[  862.247688]  elevator_change+0x16d/0x460
[  862.247893]  elevator_set_none+0x87/0xf0
[  862.248798]  blk_unregister_queue+0x12e/0x2a0
[  862.248995]  __del_gendisk+0x231/0x7e0
[  862.250143]  del_gendisk+0x12f/0x1d0
[  862.250339]  sd_remove+0x85/0x130 [sd_mod]
[  862.250650]  device_release_driver_internal+0x36d/0x530
[  862.250849]  bus_remove_device+0x1dd/0x3f0
[  862.251042]  device_del+0x38a/0x930
[  862.252095]  __scsi_remove_device+0x293/0x360
[  862.252291]  scsi_remove_target+0x486/0x760
[  862.252654]  __iscsi_unbind_session+0x18a/0x3e0 [scsi_transport_iscsi]
[  862.252886]  process_one_work+0x633/0xe50
[  862.253101]  worker_thread+0x6df/0xf10
[  862.253647]  kthread+0x36d/0x720
[  862.254533]  ret_from_fork+0x2a6/0x470
[  862.255852]  ret_from_fork_asm+0x1a/0x30
[  862.256037]  </TASK>

Remove the blk_should_fake_timeout() check from dm, as dm has no
native timeout handling and should not attempt to fake timeouts.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good — the current code in this tree still has the buggy
`blk_should_fake_timeout()` check, confirming the fix hasn't been
applied yet.

### 8. SUMMARY

| Criterion | Assessment |
|-----------|------------|
| Fixes a real bug | YES — request leak causing hung tasks |
| Obviously correct | YES — dm shouldn't fake timeouts without a timeout
handler |
| Small and contained | YES — 2 lines removed in 1 file |
| No new features | Correct — removes incorrect behavior |
| Tested | YES — reproduction steps and stack trace provided |
| Risk of regression | Very low — only affects fault injection testing
path |
| Expert review | YES — Christoph Hellwig reviewed, Mikulas Patocka
signed off |
| Applicable to stable | YES — prerequisite commit from 2020, present in
all stable trees |

### CONCLUSION

This is a textbook stable backport candidate: a small, surgical fix for
a real bug (request leak causing indefinite task hangs) in a widely-used
subsystem (device mapper), reviewed by top-tier kernel developers, with
minimal regression risk. The bug has existed since 2020 in all
maintained stable trees. The fix is trivially correct — dm shouldn't
participate in fake timeout injection when it has no timeout handler.

**YES**

 drivers/md/dm-rq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a6ca92049c10e..5e08546696145 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -278,8 +278,7 @@ static void dm_complete_request(struct request *rq, blk_status_t error)
 	struct dm_rq_target_io *tio = tio_from_request(rq);
 
 	tio->error = error;
-	if (likely(!blk_should_fake_timeout(rq->q)))
-		blk_mq_complete_request(rq);
+	blk_mq_complete_request(rq);
 }
 
 /*
-- 
2.51.0

