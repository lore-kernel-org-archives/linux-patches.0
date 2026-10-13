Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAF34EF13A;
	Tue, 13 Oct 2026 11:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892439; cv=none; b=cQhjY3Lr286WsC0W0F8Jn/o9MlNBEYVIrYgRFDZfJhPjvw4XclUgwh3PykWZH6K4htcvQ2i46dYq4LCKUVgdU0k1ZXPTFVmVXTK7P1dx3u/O3yIqvuIj2bOZKIFBqHmndB34sclXnTlgH56HACJZv+pjaXopsQGeqd79z+4OAlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892439; c=relaxed/simple;
	bh=nsO7XHvraxvs/lEfnNgkudhwxAgkexeKDaDit49okHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1jtyJEUabcGfPkMmt/52MKHcvBZY8lWNSjygTGIB3BX3BiBIPMMC+0VOM8cC6LSv8WCldegqdrEanXWBgqYVD2ZaLG3Vo+7dOgCes+1YX0lBu/uJWo7Sf20f0Y+fdp7mCzzLiCKJ7eUZddY+0q4IzULUXW5FSg6aKJ1Lc+Ihao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuNKKV/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuNKKV/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617251F000FF;
	Tue, 13 Oct 2026 11:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892437;
	bh=bgo3rEIUVczzrc+WUAw9g7GkNit6sUii9ncG0JE0t20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuNKKV/Ge+hc4vxmCfuCK6MRclGAWTPnRp1ypzK4qHUosv6kZi4eNuWqS1sD58+jp
	 k4gQbHu48hwFgxRYM1AFAsk2oPsV07b2KNy2Vhau3zzAZKUGy24YgoOICqSgMPveDp
	 6Vi4dlr/5rIPNaLYzoPrArAJuuUaZ/vi5MGVR5qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 7.2 129/281] drm/panthor: validate userspace queue count against initialized firmware slot count
Date: Tue, 13 Oct 2026 13:37:25 +0200
Message-ID: <20261013112858.281245715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3675,6 +3675,9 @@ int panthor_group_create(struct panthor_
 	    hweight64(group_args->tiler_core_mask) < group_args->max_tiler_cores)
 		return -EINVAL;
 
+	if (group_args->queues.count > sched->cs_slot_count)
+		return -EINVAL;
+
 	group = kzalloc_obj(*group);
 	if (!group)
 		return -ENOMEM;


