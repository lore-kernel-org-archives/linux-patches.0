Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED51DE3D6;
	Wed, 19 Feb 2025 08:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954430; cv=none; b=ZQOvQ/I3FteJiqrL89OWlyNXF6IBi/2u5RalrWl/dLwBN65g+CEu914FscreEpCkZLnJF7BvJRhcbAkMwxRQORop33siCUEWLLbPcEilAvgOMiZCGU8aQsgAReWGOsixHEAhZ1DC9QeDCu8KKymgvRELXrPqLLXjkyD9rY/GWwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954430; c=relaxed/simple;
	bh=ZkzMkEpmuFcv9ilTqWj+xUQzOmI21sj9pjGkZPiYtEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHRZlz4qyli2bJQx0pIGVkUyORuMbHL4kB1suNjSB5wajIvK3YH32AnoitU//VfAo0wNkRbXPjNNCf/pzDAmRBdMxeK2LefQWc6Fz2+ll0dxdwwdHzK4tFUUqRNfjUsU0lNDeAqACmM3+rMbcbVrrP0FryOpoU7GfmTlUFLR89k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDMzpuO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDMzpuO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18872C4CEE7;
	Wed, 19 Feb 2025 08:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954430;
	bh=ZkzMkEpmuFcv9ilTqWj+xUQzOmI21sj9pjGkZPiYtEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDMzpuO+qQXZ38mv4qRrUIU4UPmlo+zXSBGw/5MH5MdF1lExop92GsM81Iph0eV6S
	 F7Am2Dyhk/jEAzp26SwPl31CAF9wWuIZ6O9hU+sYihe63VW0bwgstRbXc/hAPsjRkp
	 Yva2GaIZbsDEUxCaxyTCVtf2PgNrErILy5Ey2nHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 201/274] drm/xe/oa: Set stream->pollin in xe_oa_buffer_check_unlocked
Date: Wed, 19 Feb 2025 09:27:35 +0100
Message-ID: <20250219082617.446376615@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 990d35edc5d333ca6cd3acfdfc13683dc5bb105f ]

We rely on stream->pollin to decide whether or not to block during
poll/read calls. However, currently there are blocking read code paths
which don't even set stream->pollin. The best place to consistently set
stream->pollin for all code paths is therefore to set it in
xe_oa_buffer_check_unlocked.

Fixes: e936f885f1e9 ("drm/xe/oa/uapi: Expose OA stream fd")
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115222029.3002103-1-ashutosh.dixit@intel.com
(cherry picked from commit d3fedff828bb7e4a422c42caeafd5d974e24ee43)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index d56b0a0ede0da..913f6ba606370 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -239,7 +239,6 @@ static bool xe_oa_buffer_check_unlocked(struct xe_oa_stream *stream)
 	u32 tail, hw_tail, partial_report_size, available;
 	int report_size = stream->oa_buffer.format->size;
 	unsigned long flags;
-	bool pollin;
 
 	spin_lock_irqsave(&stream->oa_buffer.ptr_lock, flags);
 
@@ -284,11 +283,11 @@ static bool xe_oa_buffer_check_unlocked(struct xe_oa_stream *stream)
 	stream->oa_buffer.tail = tail;
 
 	available = xe_oa_circ_diff(stream, stream->oa_buffer.tail, stream->oa_buffer.head);
-	pollin = available >= stream->wait_num_reports * report_size;
+	stream->pollin = available >= stream->wait_num_reports * report_size;
 
 	spin_unlock_irqrestore(&stream->oa_buffer.ptr_lock, flags);
 
-	return pollin;
+	return stream->pollin;
 }
 
 static enum hrtimer_restart xe_oa_poll_check_timer_cb(struct hrtimer *hrtimer)
@@ -296,10 +295,8 @@ static enum hrtimer_restart xe_oa_poll_check_timer_cb(struct hrtimer *hrtimer)
 	struct xe_oa_stream *stream =
 		container_of(hrtimer, typeof(*stream), poll_check_timer);
 
-	if (xe_oa_buffer_check_unlocked(stream)) {
-		stream->pollin = true;
+	if (xe_oa_buffer_check_unlocked(stream))
 		wake_up(&stream->poll_wq);
-	}
 
 	hrtimer_forward_now(hrtimer, ns_to_ktime(stream->poll_period_ns));
 
-- 
2.39.5



