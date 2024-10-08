Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E911DE89D;
	Tue,  8 Oct 2024 12:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392278; cv=none; b=J7Qqo2lkpJ8+FRVhIyGkMzOTImG53shYa2FvYBzA6elq9zNig6myS3y745UsFhHoptV/FJg6MLnAbWuim0aOZQQ6Wj7ula6ju2eQl9P2FsJ66MkkKRpPx5VT9fxQaMmJiWhmD08m7P8F40IeBJS4FQ5LUadyZ45iL2FdAMJazvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392278; c=relaxed/simple;
	bh=WAYRTDbbU7Ds+8zNEOjYAiRmkTQLGhuIQjNHzFexAjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=quCnXDIr3vSHMoUYs6wqjH9v31lFk9A/ZLVxyUNHTAePQQbUSLB+MOjFpQG/5laLFKRo6sCfM5JhDgA20To9xlbp6TpeDVWUd8GX4ZgsZGzqqGdkbpzw5XNtfqMkBjsKNIUzF0t3TJChaRRHWryypUJEr63LEOuv3vaR4ef+LeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTral3j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTral3j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40327C4CEC7;
	Tue,  8 Oct 2024 12:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392278;
	bh=WAYRTDbbU7Ds+8zNEOjYAiRmkTQLGhuIQjNHzFexAjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTral3j4PTzr/o3NjTKUbLf4LQdLd3JcSBdgZReWNsZyIi7/1mJcEy2t9NrqmaDtw
	 xdgCY7sR+xWgsbTib06fmpxgJSOpR9LF1eGAZduqAFP6BtgNag7Nz9lO3h1DJRsNZO
	 gI3FEIuxW66o6irpDODpBilWjZTXAXH8uy19JpXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>
Subject: [PATCH 6.11 368/558] drm/v3d: Prevent out of bounds access in performance query extensions
Date: Tue,  8 Oct 2024 14:06:38 +0200
Message-ID: <20241008115716.776836178@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit f32b5128d2c440368b5bf3a7a356823e235caabb upstream.

Check that the number of perfmons userspace is passing in the copy and
reset extensions is not greater than the internal kernel storage where
the ids will be copied into.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: bae7cb5d6800 ("drm/v3d: Create a CPU job extension for the reset performance query job")
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Iago Toral Quiroga <itoral@igalia.com>
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711135340.84617-2-tursulin@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -671,6 +671,9 @@ v3d_get_cpu_reset_performance_params(str
 	if (reset.nperfmons > V3D_MAX_PERFMONS)
 		return -EINVAL;
 
+	if (reset.nperfmons > V3D_MAX_PERFMONS)
+		return -EINVAL;
+
 	job->job_type = V3D_CPU_JOB_TYPE_RESET_PERFORMANCE_QUERY;
 
 	job->performance_query.queries = kvmalloc_array(reset.count,
@@ -753,6 +756,9 @@ v3d_get_cpu_copy_performance_query_param
 		return -EINVAL;
 
 	if (copy.nperfmons > V3D_MAX_PERFMONS)
+		return -EINVAL;
+
+	if (copy.nperfmons > V3D_MAX_PERFMONS)
 		return -EINVAL;
 
 	job->job_type = V3D_CPU_JOB_TYPE_COPY_PERFORMANCE_QUERY;


