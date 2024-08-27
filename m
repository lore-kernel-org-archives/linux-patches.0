Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDBA1A072D;
	Tue, 27 Aug 2024 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771723; cv=none; b=hfg4fMKCUQScd3nDoUMdIjZ4caWncU72NI4s7PboN4MbR8jIjzjv6HmMbjhWHFCC7LTRHj/9LIRPcf/DdvEZ44UKvW3V3NutYQ7sN8XVWaAOGw+3zcoT9j3wn31bYL1KcDJN9OAg1UXJjL4Ckp3CXdjFsuJ1nRblpWgwMf+Q79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771723; c=relaxed/simple;
	bh=VYb/OJjWTDzB8RnfiLJCYmoI7ZIrCVeldG9f7IAIJ5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvhnP30OBkNa2oReGBD+947IvZcicmny6imWyFAQD4BZ6Mgljhjc4+t8jxs+VSBA1V7Rt7RboIwrqG3whRAmd4uemIWZK7UiQj4fx+zQ7dHjfXVw4pZuSWdF2dskBg2uawYT8TLa5tIk6/MdO75doSHSkAl3VhYT2fGw6YOc0OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrGd4/CU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrGd4/CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46756C4AF50;
	Tue, 27 Aug 2024 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771722;
	bh=VYb/OJjWTDzB8RnfiLJCYmoI7ZIrCVeldG9f7IAIJ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrGd4/CUFKnFDq3jpQnERHO7+J2OY09HJrudSdVseM5Oe8srnTtboLIFgc6jIaxwk
	 Cxj++zHFd12pftNlrv7eExyuOIWRd3ECydX+WhMMWmaj5YZa0PQqNBO7zZUOf0smVv
	 SCfDgtGZtH292oZJ3GpK+UwvRrJPvbUGfs+tJLV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.10 267/273] drm/xe: Do not dereference NULL job->fence in trace points
Date: Tue, 27 Aug 2024 16:39:51 +0200
Message-ID: <20240827143843.559975512@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 5d30de4311d2d4165e78dc021c5cacb7496b3491 upstream.

job->fence is not assigned until xe_sched_job_arm(), check for
job->fence in xe_sched_job_seqno() so any usage of this function (trace
points) do not result in NULL ptr dereference. Also check job->fence
before assigning error in job trace points.

Fixes: 0ac7a2c745e8 ("drm/xe: Don't initialize fences at xe_sched_job_create()")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240605055041.2082074-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_sched_job.h |    2 +-
 drivers/gpu/drm/xe/xe_trace.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_sched_job.h
+++ b/drivers/gpu/drm/xe/xe_sched_job.h
@@ -70,7 +70,7 @@ to_xe_sched_job(struct drm_sched_job *dr
 
 static inline u32 xe_sched_job_seqno(struct xe_sched_job *job)
 {
-	return job->fence->seqno;
+	return job->fence ? job->fence->seqno : 0;
 }
 
 static inline u32 xe_sched_job_lrc_seqno(struct xe_sched_job *job)
--- a/drivers/gpu/drm/xe/xe_trace.h
+++ b/drivers/gpu/drm/xe/xe_trace.h
@@ -270,7 +270,7 @@ DECLARE_EVENT_CLASS(xe_sched_job,
 			   __entry->guc_state =
 			   atomic_read(&job->q->guc->state);
 			   __entry->flags = job->q->flags;
-			   __entry->error = job->fence->error;
+			   __entry->error = job->fence ? job->fence->error : 0;
 			   __entry->fence = job->fence;
 			   __entry->batch_addr = (u64)job->ptrs[0].batch_addr;
 			   ),


