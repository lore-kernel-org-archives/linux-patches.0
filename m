Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360A81DFDBC;
	Wed, 19 Feb 2025 08:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954166; cv=none; b=bMPoGzRX/HT/pIuljkuYdBipWVzODWejsJI/vCZ/nuGocKfYp8v+B3/BPRsdSsaA03MC50Y/hiYQmpgYtt3MNsvPzbe3pyC4+1luMdEcH9wZZQLNhkscPbGKdDvUN23VjEzxAO4Tbp+Vi/Cmb3brDmq/qwZepoObAbvzTKRLck8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954166; c=relaxed/simple;
	bh=8tdhKqdce4zlCtvnTuJ4xbBczaOxKu6nZyvvbn1ClcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHPJc6/TNWYGrYk1ZJzXmDoeOKKW567L+2ym9CLdXEIsXk4eHXIiFCh7BmAs9aARmrx9uXsVI1zrm9clq0wpiJKXwPd/nPhlSUx4Q5yoiKyJt57KVRCkfmyBqV3ohbbmqgJSI1SuJEsE7+4Gm1A7Nh0NRGRrb44rAH7ceE+xa10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzAp/ZMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzAp/ZMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EFCC4CEE7;
	Wed, 19 Feb 2025 08:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954165;
	bh=8tdhKqdce4zlCtvnTuJ4xbBczaOxKu6nZyvvbn1ClcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzAp/ZMHr8XkKfZDHOT1k88xEzST+PKZHKDBvHL9gWKaXxibZCxksDgpPFXLVr4Pt
	 GUjzvPSuRc5cgP3mQdVpfcbu1n2cPMpJunyP3t7zTB3LdopJpxkR6mrSj6Kueji2Lm
	 sXo8AC1BOWvJTy4Q7spK5WWtzulxkns7SBTHUjH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 118/274] drm/amdgpu: avoid buffer overflow attach in smu_sys_set_pp_table()
Date: Wed, 19 Feb 2025 09:26:12 +0100
Message-ID: <20250219082614.240074460@linuxfoundation.org>
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
@@ -609,7 +609,8 @@ static int smu_sys_set_pp_table(void *ha
 		return -EIO;
 	}
 
-	if (!smu_table->hardcode_pptable) {
+	if (!smu_table->hardcode_pptable || smu_table->power_play_table_size < size) {
+		kfree(smu_table->hardcode_pptable);
 		smu_table->hardcode_pptable = kzalloc(size, GFP_KERNEL);
 		if (!smu_table->hardcode_pptable)
 			return -ENOMEM;


