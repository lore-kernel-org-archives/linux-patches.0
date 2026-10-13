Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAB933B6F8;
	Tue, 13 Oct 2026 12:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896091; cv=none; b=gChugeaD51B1L0/iuyxpBwpo01cQip5ut2AvosaC0FAjc7OMLoWoh37O9G9S7QDA64TEeWRAZ4chMe0zw0Mw7B4tx6jdhqSDtIm3Je6EXORjO7chPHH3h40fLQoH44kEzAMUBDFqFQf9xN1pm4cURHWAqswtYLUWao44+N4wp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896091; c=relaxed/simple;
	bh=pw3aaQqlb3/I65C0LbhXevpIJJ3FfjOQ78yMD8SlDlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQGiaTwY4/HPN5fqFpIX0gIaN3c1CYbPa/jvEl37EN+vBupAMgnloghBhgGstP1b/yQIvAsIlz+oU2dXuiq6+uAHkMWFTbln4gfUYFSbJE6SUsOb1//LcX3YMrMho1tCJ+o0BO6XwRBq9wXvEfwpUREIsftbZywexl28RSJhbl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSEFqJ6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSEFqJ6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947A61F00893;
	Tue, 13 Oct 2026 12:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896090;
	bh=befvfmYSooDwrju76g/EcnNJ8MfWl3sLsQep7k3g4Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSEFqJ6EA9UqwKZ9JaWktf3uWVKqgV2J8s5JmIt1I5TUreyHzpQiy6VTh7n3lMew5
	 xI2eLi0Ug2QcUKfhio7MnPGYhPa/8Mpqxxo1+3gw1BAGt5y2fa8SDB7EEsfkUco9vN
	 zJnjg2O/7JAwvUyo3s7p9HTP0mxGmioqWIWjqxiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.12 493/497] drm/panthor: validate userspace queue count against initialized firmware slot count
Date: Tue, 13 Oct 2026 13:41:00 +0200
Message-ID: <20261013112919.578380444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3412,6 +3412,9 @@ int panthor_group_create(struct panthor_
 	    hweight64(group_args->tiler_core_mask) < group_args->max_tiler_cores)
 		return -EINVAL;
 
+	if (group_args->queues.count > sched->cs_slot_count)
+		return -EINVAL;
+
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group)
 		return -ENOMEM;


