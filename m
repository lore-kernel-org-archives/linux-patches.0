Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0235AC3E;
	Sat, 12 Sep 2026 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204660; cv=none; b=i4UAv+xw8LhjlJulWF74mTCO8o5FzE24jizLppzJSTXcSVV51aPxIf67Sdh0TmBenwIRk+tWcvwp7wwGzRU/JlRyhIv2pAfHZ+DOI+XtzJQYHrOUyCCMFi938/vOW5WpvFetNEExQDAi8Ng9UjzWhcU9WJu7ITGoakUV/6HFI7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204660; c=relaxed/simple;
	bh=l0q4XJxbQqWKZPtr+rTkynjb3GjWniek+WjADkwZUIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWR3r5yniNJ9i9hCS+McNvw77kpafea66CW8joNfmTXk70s8K9q8NfWCIXD4HzosAAUkca+TRaZwiJYPLv4pn2IlI29r/godLO23N8hTjK/0kQgpqZOD/RYUnbTHmgrzlb0mhcPIk1b8YJkVblBjbE3zgaqdVYdOTQwaSf2DYAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfAltK+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfAltK+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05351F000FF;
	Sat, 12 Sep 2026 09:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204658;
	bh=y6l7EV5de00ojtPp5Ch5GmqD3gsWtJZof5BRvLUU26c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfAltK+djTSA5ViX7admIXt/dggsNNIgmp6ObP7sEEQ1VVFT1HK/yk9K+0DBC63KV
	 8MDaGLmUm3ETGc/vBR2udZPve0zR5uMZd7d5EHoc2ZUxyr9eSOxhVGATRLXpvZEJou
	 qUDbKP1cP3CnscZb4N1Fg1FUzOsRkBHbZvGMBTl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1659/1815] drm/xe: dont WARN on kernel job timeout when device already wedged
Date: Sat, 12 Sep 2026 08:56:49 +0200
Message-ID: <20260912065727.937688714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit 13087ad7817e6e5f210064518bfc4d6d58a9c2f3 ]

igt@xe_wedged@wedged-at-any-timeout wedges the device in mode 2
(UPON_ANY_HANG_NO_RESET) and then rebinds the driver. During unbind,
a GSC proxy kernel submission can still time out; with the device wedged
and the GuC CT stopped it can never complete, so its kernel job times out.

  Tile0: GT1: Kernel-submitted job timed out
  WARNING: drivers/gpu/drm/xe/xe_guc_submit.c:...
	   at guc_exec_queue_timedout_job()
  Workqueue: gt-ordered-wq drm_sched_job_timedout

Killed queues skip guc_submit_hint_wedged(), leaving 'wedged' false even
though the device is already wedged. The timeout handler then treats the
kernel queue timeout as unexpected and taints the kernel.

Honour an already-wedged device even for killed queues so the expected
teardown timeout no longer trips the WARN.

Fixes: 5a2f117a80c2 ("drm/xe: Do not wedge device on killed exec queues")
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20260814074106.92670-2-nitin.r.gote@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit a1c1dbd0f047bb05de6aaf6abe9103031179bf19)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 1c92b96e4c324..eb426e8585887 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1537,8 +1537,14 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 	if (!skip_timeout_check && !check_timeout(q, job))
 		goto rearm;
 
+	/*
+	 * Killed queues must not newly wedge the device, but preserve an
+	 * already-wedged state to avoid warning on teardown timeouts.
+	 */
 	if (!exec_queue_killed(q))
 		wedged = guc_submit_hint_wedged(exec_queue_to_guc(q));
+	else
+		wedged = xe_device_wedged(xe);
 
 	set_exec_queue_banned(q);
 
-- 
2.53.0



