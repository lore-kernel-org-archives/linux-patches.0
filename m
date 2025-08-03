Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C5F20F079;
	Sun,  3 Aug 2025 21:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255908; cv=none; b=rn3LecnYyYqi4Wd/U2A14WxrldHEToyzf3JZx6FoFrKuzxt2R+rtdRyS2x8/mMXXeepRfwqoW+2xNPdU947YQ0nQ5a/JrV4wX/hLn186xhuhkGFQfGA5h3Psc2oZRkmRbhHs5qyV+M1f6iufI4nM6PqW/tOzc0nu4Z5MTKhwCFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255908; c=relaxed/simple;
	bh=2RIMdWjaHaxvVRCXL8qb9huaxtroC3za/YDvc75NII8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TSj4KCkhWf2a74bULzAvUCTkMncgste1umMThJX6n4vHHhjGkfH4w54sdfXFjoYuhMiwUdlKKhLW5BkTJORkarcv54d9htsR19mGgr1o7FwV8LtVPXXV4UCJ/i1ettRbJt86Ph8CzBxKijP6VE9jLB24sEClpXVVfNk/O5cHakA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zeba2kdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zeba2kdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8994C4CEF0;
	Sun,  3 Aug 2025 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255907;
	bh=2RIMdWjaHaxvVRCXL8qb9huaxtroC3za/YDvc75NII8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zeba2kdYWdn6EU6sM5Ir2ZXUOodGCGDs/UUP+vcizTbJYiBcpYGhaXhyQd/iUJVHd
	 QMguQNFUvAZzy0SS5cJnXqjwwkTWTMyRYvxqa6/AivW/NBXsgwkmdyI+SPdPj9Cf1g
	 1ZHg49qoGDSfgq7NFilK4IC1HaBO+m+JZp0Ivv1aq5JYVNBym0HUUV4UV/3A5GVvOm
	 DKuFEZ/YuLfR5xqruMicCwYcgJL1gEmRUdAfh8XvHd2ESrsGOpfwA7f72J1a7QnCIW
	 ZhX10bbmZO2J9s0cQ00wetRq5EZ7I++vdR+Gt0zaUivOQ/wfX9cClHzPhTZG4G3SUu
	 bR0WPI8UJIMSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sarah Newman <srn@prgmr.com>,
	Lars Ellenberg <lars@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com
Subject: [PATCH AUTOSEL 6.16 21/35] drbd: add missing kref_get in handle_write_conflicts
Date: Sun,  3 Aug 2025 17:17:21 -0400
Message-Id: <20250803211736.3545028-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Sarah Newman <srn@prgmr.com>

[ Upstream commit 00c9c9628b49e368d140cfa61d7df9b8922ec2a8 ]

With `two-primaries` enabled, DRBD tries to detect "concurrent" writes
and handle write conflicts, so that even if you write to the same sector
simultaneously on both nodes, they end up with the identical data once
the writes are completed.

In handling "superseeded" writes, we forgot a kref_get,
resulting in a premature drbd_destroy_device and use after free,
and further to kernel crashes with symptoms.

Relevance: No one should use DRBD as a random data generator, and apparently
all users of "two-primaries" handle concurrent writes correctly on layer up.
That is cluster file systems use some distributed lock manager,
and live migration in virtualization environments stops writes on one node
before starting writes on the other node.

Which means that other than for "test cases",
this code path is never taken in real life.

FYI, in DRBD 9, things are handled differently nowadays.  We still detect
"write conflicts", but no longer try to be smart about them.
We decided to disconnect hard instead: upper layers must not submit concurrent
writes. If they do, that's their fault.

Signed-off-by: Sarah Newman <srn@prgmr.com>
Signed-off-by: Lars Ellenberg <lars@linbit.com>
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20250627095728.800688-1-christoph.boehmwalder@linbit.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding code context,
here is my assessment:

**YES** - This commit should be backported to stable kernel trees.

Here's my extensive explanation:

1. **Critical Bug Fix**: This commit fixes a missing `kref_get` that
   causes a use-after-free vulnerability. The code at
   drivers/block/drbd/drbd_receiver.c:2503-2507 shows the fix adds the
   missing reference count increment before queuing work that will later
   decrement the reference count in `drbd_send_acks_wf()`.

2. **Clear Use-After-Free Pattern**: Looking at the code pattern:
   - Before the fix: The code queues work (`queue_work`) that will call
     `drbd_send_acks_wf()`, which contains `kref_put(&device->kref,
     drbd_destroy_device)` at line 6119
   - Without the matching `kref_get`, this leads to premature
     destruction of the device structure
   - The commit message explicitly states this results in "premature
     drbd_destroy_device and use after free"

3. **Follows Established Pattern**: The fix follows the exact same
   pattern used elsewhere in the DRBD code. At
   drivers/block/drbd/drbd_worker.c:150-152, we see:
  ```c
  kref_get(&device->kref); /* put is in drbd_send_acks_wf() */
  if (!queue_work(connection->ack_sender, &peer_device->send_acks_work))
  kref_put(&device->kref, drbd_destroy_device);
  ```
  This shows the fix is correct and consistent with the codebase.

4. **Small and Contained Fix**: The change is minimal (adding 4 lines),
   well-understood, and doesn't introduce any architectural changes. It
   simply ensures proper reference counting.

5. **Real Security Issue**: Use-after-free bugs can lead to kernel
   crashes and potentially be exploited for privilege escalation. Even
   though the commit notes this code path is rarely taken in production
   ("two-primaries" mode with concurrent writes), when it is triggered,
   it causes kernel crashes.

6. **Meets Stable Criteria**: According to Documentation/process/stable-
   kernel-rules.rst:
   - It fixes "a real bug that bothers people" (kernel crashes)
   - It's "obviously correct and tested" (follows established pattern)
   - It's under 100 lines
   - It fixes "data corruption, a real security issue" (use-after-free)

7. **No Side Effects**: The fix only adds proper reference counting and
   doesn't change any logic or introduce new features. The only behavior
   change is preventing the use-after-free bug.

The fact that this affects a rarely-used code path ("two-primaries"
mode) doesn't diminish its importance for backporting, as users who do
use this feature would experience kernel crashes without this fix. The
fix is safe, minimal, and prevents a serious bug.

 drivers/block/drbd/drbd_receiver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e5a2e5f7887b..975024cf03c5 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2500,7 +2500,11 @@ static int handle_write_conflicts(struct drbd_device *device,
 			peer_req->w.cb = superseded ? e_send_superseded :
 						   e_send_retry_write;
 			list_add_tail(&peer_req->w.list, &device->done_ee);
-			queue_work(connection->ack_sender, &peer_req->peer_device->send_acks_work);
+			/* put is in drbd_send_acks_wf() */
+			kref_get(&device->kref);
+			if (!queue_work(connection->ack_sender,
+					&peer_req->peer_device->send_acks_work))
+				kref_put(&device->kref, drbd_destroy_device);
 
 			err = -ENOENT;
 			goto out;
-- 
2.39.5

