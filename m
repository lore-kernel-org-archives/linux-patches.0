Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33AE563FC2;
	Wed,  9 Sep 2026 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962793; cv=none; b=QEZAopacMrmeadKe2gOdsgfncIuomlogNkQrxTRuy0I+9UdLCeuzOE1m5Jy6avAFrimbc1GfsvZyYcJA6Xo4zYEpA7Wo8W3zR2CpgcBRCTRu5LxadjisugntiIBV2JaRnGar+xQw6Hg0Fxhe7dv3O924SyIkK+SHopXQ7nxBmsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962793; c=relaxed/simple;
	bh=VmxQ3Ds0YNy17BOA9CngGkBPvtndvhQpl6EAGhkL5NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRYw1JXoWe/8KBx0bEZLvoUhgPoPDTx96AZN4Dwk+yIQphtSE/6cCU9x2LMLCTuzzS1mSLi3QmuMXN9tUhC85LlrB3Ef1iPwS1EKyrcgYKU+91FwQQJqYbHBhu7bdYIuWUpO5TJ4dK+egVzjrkSFRI843b3CtGviZrbNkHk50jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8Xmo+kg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8Xmo+kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273CD1F00A3A;
	Wed,  9 Sep 2026 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962791;
	bh=BfzGwsAuMjqUDM/8YkBi1S78YKu5PUp403wkWFmW+fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E8Xmo+kgvW+nmYwm3Jpk/m6Gpbu0XgtzSaPYwVbOXkrBWZ1SE7oq4PWi61ROKkWea
	 9JOxU+gFz49t4yBVQu3ubbwa00wXx9CCanU1TfDRJCEaOmFsjGYQvEAqfAkUW4MfYQ
	 IEtfhpCLduygFufCQ9wkByLoGMvgj+cMe8OW1k+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 413/556] media: chips-media: wave5: Defer job_finish() only when a DEC_PIC was queued
Date: Wed,  9 Sep 2026 15:41:33 +0200
Message-ID: <20260909134245.140855026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit b694ba0a5526a69f78a6924982b1553154ccfd73 upstream.

Decoder instances sharing a VPU also share one v4l2_m2m job slot, released
when the running context calls v4l2_m2m_job_finish(). While draining,
device_run() defers job_finish() once EOS is sent (sent_eos), expecting a
later finish_decode() (from a DEC_PIC completion IRQ) to release the slot.

But the m2m core checks job_ready() only when a job is queued, not when it
is dispatched. A job queued while draining can run after finish_decode()
has already moved the instance to STOP and sent EOS. device_run() then runs
in STOP, issues no DEC_PIC, yet still skips job_finish() - so no IRQ, no
finish_decode(), and the shared slot is leaked, stalling every instance.
With several v4l2h264dec instances in parallel, GStreamer hangs at EOS.

Track whether the run actually queued a DEC_PIC (cmd_issued) and defer
job_finish() only then. Otherwise finish the job immediately

Fixes: a176ac5e701f ("media: chips-media: wave5: Improve performance of decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../media/platform/chips-media/wave5/wave5-vpu-dec.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index 93f7b724d86c..f33c00cb801b 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1655,6 +1655,7 @@ static void wave5_vpu_dec_device_run(void *priv)
 	struct queue_status_info q_status;
 	u32 fail_res = 0;
 	int ret = 0;
+	bool cmd_issued = false;
 
 	dev_dbg(inst->dev->dev, "%s: Fill the ring buffer with new bitstream data", __func__);
 	pm_runtime_resume_and_get(inst->dev->dev);
@@ -1752,6 +1753,7 @@ static void wave5_vpu_dec_device_run(void *priv)
 			inst->retry = false;
 			if (!inst->eos)
 				inst->queuing_num--;
+			cmd_issued = true;
 		}
 		break;
 	default:
@@ -1769,8 +1771,16 @@ static void wave5_vpu_dec_device_run(void *priv)
 	 * in power and CPU time.
 	 * If EOS is passed, device_run will not call job_finish no more, it is called
 	 * only if HW is idle status in order to reduce overhead.
+	 *
+	 * Deferring job_finish() is only safe when this run actually queued a
+	 * DEC_PIC command (cmd_issued): that guarantees a completion IRQ, and
+	 * thus a later finish_decode(), will release the shared job slot. When
+	 * device_run() is entered with no command to issue (e.g. a job that was
+	 * queued while draining but reached the STOP state by the time it ran),
+	 * no IRQ follows, so finish the job here to avoid leaking the slot and
+	 * stalling every instance sharing the VPU.
 	 */
-	if (!inst->sent_eos)
+	if (!inst->sent_eos || !cmd_issued)
 		v4l2_m2m_job_finish(inst->v4l2_m2m_dev, m2m_ctx);
 }
 
-- 
2.55.0



