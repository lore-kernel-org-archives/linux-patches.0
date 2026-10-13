Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E24FDA74;
	Tue, 13 Oct 2026 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894566; cv=none; b=PyWULNxmWRx0WGQQtS1h+rm0D7I9kBTE0ZYN5VYimTT5jbagHi4LR1fQCxivkq4vqOV4jg/sAQi4ySxB6LLsfcaD7JXIoNy5Ik4vvCwpBe0guAQJaK1B8OZg8KbOVjfxWf2wQbgSJpgTk6jxh54Vv3kopapQhmcAxtHOx3uZ1sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894566; c=relaxed/simple;
	bh=Sc+TDg7k39D8C/xMfkadL4ophNkaleABLduPg9An80g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2P0oFHlDNkxdcKd68nTKq2cb1E2oGLBYQPKh4wbU482d9+tZEWH4y+5AlwGTNAjsf/ZKrQQOWK3zYi3v/OjJEJZx3UqM8o+Vy6BIlSK/HQMC2/f5Y52lTMIegRzPKk3O0SLRJz66r3+TCk/M28NNtg2MejwXsLzaiXDtYCk548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heYmViin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heYmViin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A111F00898;
	Tue, 13 Oct 2026 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894564;
	bh=QC/ZlKvZAF+TwG6N3tZ8kjuUcCw4iPEX6k/PWu8sp7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heYmViin184sXV+42bvXpGDfxHsk2Tnc8L6hh8U5j32m1XkcDQ7Mwp5MpF/aEKmC4
	 2xfC10kxYUiDOWoGuzF4eEZQ9+6q+QFy3MvIN1XQnQnPsEG7gXLgXbT7Dqmgz1tWPd
	 QC3PZKko+Ubqz0pa1EWRLx+BsmmU9yzCKEB3t0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.18 603/621] drm/panthor: validate userspace queue count against initialized firmware slot count
Date: Tue, 13 Oct 2026 13:39:58 +0200
Message-ID: <20261013112935.109306029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit ec86c43dcfff68eab4db9bdafcd3e2b16e342e18 upstream.

In panthor_drv.c:panthor_ioctl_group_create(),
the queue count is validated against the hardcoded maximum:

	if (!args->queues.count || args->queues.count > MAX_CS_PER_CSG)
		return -EINVAL;

However, if the firmware reports fewer slots than MAX_CS_PER_CSG,
panthor_fw_init_ifaces() will only initialize that smaller number of
stream interfaces.

If unprivileged userspace requests more queues than the firmware reported
(but no more than MAX_CS_PER_CSG), cs_slot_prog_locked() fetches an
uninitialized stream interface and may crash when dereferencing
cs_iface->input->ringbuf_base.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260803141149.68182-1-osama.abdelkader@gmail.com?part=1
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260804160048.174148-1-osama.abdelkader@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3547,6 +3547,9 @@ int panthor_group_create(struct panthor_
 	    hweight64(group_args->tiler_core_mask) < group_args->max_tiler_cores)
 		return -EINVAL;
 
+	if (group_args->queues.count > sched->cs_slot_count)
+		return -EINVAL;
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group)
 		return -ENOMEM;


