Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60F1FC110;
	Sat, 12 Sep 2026 07:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198915; cv=none; b=aNPj+DSeJzYkNixYGqUJdMsuogHjD5rn+cp9+pRIKk2LnLvgxu3tWwUZjdLyPH9X2dQDzyMXQNGDECYqajS1UHfDiMoZvDj85EE1+DOW5dKMLQU6j7q5yI5oeztgaGvTMT0FfJQEAmNnVgCN28+Crb8T34PgSsOvZslLWZgfvGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198915; c=relaxed/simple;
	bh=BMm42OVG7jOUPY56BQJXZAepzNUNfA3ZcTgmEvVKJuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTVykbANhL3mPdI9Wy0mxKBlI17RHtTSVN6bDh7SuHfkB6wM45UUKe5Zfp9wWR5s7ac9pTNf8pTUjG2MsxtBSGZ2zrE3ODkH5HPtIOEcnvaFn9fKot2nhqgsxhnjt36LAeP/l6r4Ep2XCzFAjcubOZ105BqDb8KtInbjbBZN1Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ga//7Do6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ga//7Do6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0711F000FF;
	Sat, 12 Sep 2026 07:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198914;
	bh=+ppnuUR2+0Ezok17sIVKDlKB4nOC5AKB2HV1n0rU5uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ga//7Do64/9wEJOxJBHe9RxWQBZLrR8LnjS4/IdEyjLH69OqwvG8JDnXHPKs7r4Ye
	 cnmM1qCFzcObio2pvS83A7TZUNfI9GwkC5Gx1KvordgE2eeFfBlIEJf4GPQrT3wDWj
	 ++SYH0jNAtQkQTvy+7y4xGX++5u8T9fhsvSpYf7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0478/1815] drm/msm: Fix task_struct reference leak in recover_worker
Date: Sat, 12 Sep 2026 08:37:08 +0200
Message-ID: <20260912065700.110288018@linuxfoundation.org>
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
index 48ac51f4119be..03c0578560658 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -505,6 +505,8 @@ static void recover_worker(struct kthread_work *work)
 		 */
 		if (!vm->managed)
 			msm_gem_vm_unusable(submit->vm);
+
+		put_task_struct(task);
 	}
 
 	noreclaim_flag = memalloc_noreclaim_save();
-- 
2.53.0



