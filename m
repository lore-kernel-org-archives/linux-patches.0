Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30E0281503;
	Tue,  6 Jan 2026 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722549; cv=none; b=PrYdRqlM2MJdQAnSJX3J5aUA4i5uOVVWp7w9NQn51sGD34/fdQJXQDcKU36yVJYD6Vz+oVTaPZPyYCRMyBTbjMXA7jA3mgamIwbm3bRxBYVZq+AcIFkOSe5H66Cqi5ASNbMz9sQ7CsNiwEWErUzkh6bAjGh11IbShpbxVlZJ1DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722549; c=relaxed/simple;
	bh=FvyHbraLLSBECotcK7mgKJkO+K20SFND+D5fDG0F0bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jprediIQFO4ni5aO00Nyjr+4cjxsoKTTy8LPvpYRMqpTF5dFS8TLWXrNN6l/Q8x6u11wX0gM0JcLY6FADPnHAFlNP1w/mnVqy19O6qys3KP7NZGY2m8JQoRVlla6+LfUs8+7O2da93PbvG/uwG/AoUPl31Ya9e96Kjjdlk5CDEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrP6R6Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrP6R6Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F82C16AAE;
	Tue,  6 Jan 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722548;
	bh=FvyHbraLLSBECotcK7mgKJkO+K20SFND+D5fDG0F0bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrP6R6DnYHpCpkFiOWwNpbDEaoPuMG07e+Z++MV0/1O72bvKVMMb7w+7aH7+9YVTq
	 DrzO8Yh5FfbSi9jQ7ibj2VdRZf8WdK/5kk2CQLaeD08SixuGoxEA5I0CdJy0Smyfv1
	 tHF2BsDSevNnHt4ujBhfcs4T2YdEuu6yIYTpT4q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 296/312] drm/xe: Use usleep_range for accurate long-running workload timeslicing
Date: Tue,  6 Jan 2026 18:06:10 +0100
Message-ID: <20260106170558.563951476@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 80f9c601d9c4d26f00356c0a9c461650e7089273 upstream.

msleep is not very accurate in terms of how long it actually sleeps,
whereas usleep_range is precise. Replace the timeslice sleep for
long-running workloads with the more accurate usleep_range to avoid
jitter if the sleep period is less than 20ms.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20251212182847.1683222-3-matthew.brost@intel.com
(cherry picked from commit ca415c4d4c17ad676a2c8981e1fcc432221dce79)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -670,6 +670,24 @@ static u32 wq_space_until_wrap(struct xe
 	return (WQ_SIZE - q->guc->wqi_tail);
 }
 
+static inline void relaxed_ms_sleep(unsigned int delay_ms)
+{
+	unsigned long min_us, max_us;
+
+	if (!delay_ms)
+		return;
+
+	if (delay_ms > 20) {
+		msleep(delay_ms);
+		return;
+	}
+
+	min_us = mul_u32_u32(delay_ms, 1000);
+	max_us = min_us + 500;
+
+	usleep_range(min_us, max_us);
+}
+
 static int wq_wait_for_space(struct xe_exec_queue *q, u32 wqi_size)
 {
 	struct xe_guc *guc = exec_queue_to_guc(q);
@@ -1559,7 +1577,7 @@ static void __guc_exec_queue_process_msg
 				since_resume_ms;
 
 			if (wait_ms > 0 && q->guc->resume_time)
-				msleep(wait_ms);
+				relaxed_ms_sleep(wait_ms);
 
 			set_exec_queue_suspended(q);
 			disable_scheduling(q, false);


