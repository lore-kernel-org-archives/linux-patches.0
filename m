Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7241B6D0F;
	Wed, 19 Feb 2025 09:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957360; cv=none; b=oTpIAuY5/tzrHVTN3tJ3cI6JXcmqWcfweiyfLcclVAv6ElIWb5uMDubRdI5w+BmopC2OKxCEI3/G/Y1hkyBwJJ+1k4WMCgmGeAV9DI9hr14xCFcdgldZlzaSdC2CzO/1bPDSFItLs2Fk0vpPnrcHaD+3MV5J7jnUq7qBMwPhA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957360; c=relaxed/simple;
	bh=Fs4FukOpWJ4fszFUU5tMfTAuSIaoKPhdxh5PUQyaRTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIWoJHCBzsfcYxcgecUkhsdRGWUv7BYrmFJ0/J74ecSmGY4AvGIS5ksTk8k2QNePftBQvgUR9TPRITHtw4fKqDD7EmAYzN78bI35QndTrGkuci6fuFtGjQXf0Yor0KAsHsOKdwVyD89hRigSwAbjdRRtMMAcSfVngT7Dp9mrojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGX8jxWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGX8jxWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03297C4CED1;
	Wed, 19 Feb 2025 09:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957359;
	bh=Fs4FukOpWJ4fszFUU5tMfTAuSIaoKPhdxh5PUQyaRTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGX8jxWZ8W9yaQojKi5L1RbZdQnKUjb0t+u0bUy1CAer6AxhO84QGe7TqPTwU1a8O
	 KR7CTlyrB1g5rNvYzHQ89YBFIOVoA3P6zaqqPYkn1HqOTrkwAQNCmclkyKP0sgYsS+
	 M8h3kwF6r41tuq2blZXm0SyJMYEWGeAPZx7hogCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 499/578] drm/amdgpu: avoid buffer overflow attach in smu_sys_set_pp_table()
Date: Wed, 19 Feb 2025 09:28:23 +0100
Message-ID: <20250219082712.617506608@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <gerry@linux.alibaba.com>

commit 1abb2648698bf10783d2236a6b4a7ca5e8021699 upstream.

It malicious user provides a small pptable through sysfs and then
a bigger pptable, it may cause buffer overflow attack in function
smu_sys_set_pp_table().

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -516,7 +516,8 @@ static int smu_sys_set_pp_table(void *ha
 		return -EIO;
 	}
 
-	if (!smu_table->hardcode_pptable) {
+	if (!smu_table->hardcode_pptable || smu_table->power_play_table_size < size) {
+		kfree(smu_table->hardcode_pptable);
 		smu_table->hardcode_pptable = kzalloc(size, GFP_KERNEL);
 		if (!smu_table->hardcode_pptable)
 			return -ENOMEM;


