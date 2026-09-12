Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C3379C38;
	Sat, 12 Sep 2026 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207541; cv=none; b=b9UMsPptyZZu81VditZnCGETJV06Ssyrk/h+1dWR2nJsfWo5mkF9R8bQeLDXad9wv89laLyw8G7CY9RrILtfg1CrEqaZLaUIxlBqp0OLWbSmn2/5NdGDXmKjIKI+qP4DNf+es00D0894OANKtp8cySCUBX60Pnem9SJq7BRYkps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207541; c=relaxed/simple;
	bh=iaSfe9Jp4jlUUpVzGCGPKat7IcgDIA1Ck0cxb+bEiD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qr9yF5ykoHih4Fnt6MClHDvEoX1Gge9Q8lwQcFlNJ8JQkJPrj3Az0cqqmYS80zKl2HHfLQwxTCyFj7gSocYRyQqIco+rNjN5TNebsPMqJwL0FAw6GlXP70A02okuzYnfjYpKgXk4n3C/S0bDCzPbm7FmPCH/yZrxbk4HvlNrAQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDOrB6Dn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDOrB6Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAC71F000FF;
	Sat, 12 Sep 2026 10:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207540;
	bh=I5eRcCAFk/80Ik489bGk3XYrjsSeEwcsxAy8BWDQ7Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDOrB6DnKcHoTRqVNtVAnfyuhRaWwiSGmh+nw9OVLD2zuYLjnnlQXiGPwtBFq0THc
	 9GYTfd/61VhCetwydobBgf8GMdgThmleM0EO0fUNnfO582mWI8WnSlBrwpXlcZSlLX
	 UMKIVZ+CeR//xXT2dYgHqTpZO7m2oZ9zeD2cgrWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0433/1518] drm/msm: Fix task_struct reference leak in recover_worker
Date: Sat, 12 Sep 2026 08:43:22 +0200
Message-ID: <20260912065633.245909380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit 40b793714ad8f393ab3d469f9d00b20ebda46257 ]

get_pid_task() increments the task reference count, but the
corresponding put_task_struct() was missing in the else branch,
leaking a reference on every GPU hang recovery.

Fixes: 25654a1756a4 ("drm/msm: Update global fault counter when faulty process has already ended")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730662/
Message-ID: <20260605-assorted-fixes-june-v1-6-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index c78f5738bfdeb..569a1ba02e608 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -505,6 +505,8 @@ static void recover_worker(struct kthread_work *work)
 		 */
 		if (!vm->managed)
 			msm_gem_vm_unusable(submit->vm);
+
+		put_task_struct(task);
 	}
 
 	get_comm_cmdline(submit, &comm, &cmd);
-- 
2.53.0



