Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1D9197541;
	Thu,  6 Jun 2024 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682981; cv=none; b=S7hFMnZgdaoF8lqBPtSHM1Nl2NxkQembk/lRfouIQ7UPEBhVb8IoYikl1vVsUIuP6DQcOps6p/9ksxvRWSZL9oOIF6+WgwjENG3l5KgtH6et5zGfgVt7pOlUYLrxE1RHH53IcK/YopB141cjJR5N7n5b7DxGiX0V+9e7QOTC/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682981; c=relaxed/simple;
	bh=KCt5FbhT3Xtjb/YNN4lkafLeCOxtbwdF5a+882nkY3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdA5fI2LuXzsOCXUN/XPLoeEaYeAPmdRDlaJNqHecqCT/MLbDsxqL4PFIYqP5ar8b/Yop3hJYXF/pNf1wCZpQvfn07OlXy31ekDNIKq+NSZxDu173/Vxv8pXmG4DNAqEWF3Poon101HHXwa0YzSmTsDvdWHeE9ti+8KntduDW0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnhc/Rc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnhc/Rc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04A6C2BD10;
	Thu,  6 Jun 2024 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682981;
	bh=KCt5FbhT3Xtjb/YNN4lkafLeCOxtbwdF5a+882nkY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnhc/Rc1zHZKGYkHPy1SjDv8vZv0EgkpUPqYN9XhnRf6ljlSa2lNY6PtP7k/IJ31n
	 LtKkPfda/v1E/eK4A0E5+hoRdf5f45m0ZnmWMIOLMBKZgUoluYat3EJFjexCc6SfPy
	 NMdLdcU6wDWvSQsapkngBKZHFICpnmHL1UjYGi6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 163/374] drm/msm/dpu: Always flush the slave INTF on the CTL
Date: Thu,  6 Jun 2024 16:02:22 +0200
Message-ID: <20240606131657.367566891@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 2b938c3ab0a69ec6ea587bbf6fc2aec3db4a8736 ]

As we can clearly see in a downstream kernel [1], flushing the slave INTF
is skipped /only if/ the PPSPLIT topology is active.

However, when DPU was originally submitted to mainline PPSPLIT was no
longer part of it (seems to have been ripped out before submission), but
this clause was incorrectly ported from the original SDE driver.  Given
that there is no support for PPSPLIT (currently), flushing the slave
INTF should /never/ be skipped (as the `if (ppsplit && !master) goto
skip;` clause downstream never becomes true).

[1]: https://git.codelinaro.org/clo/la/platform/vendor/opensource/display-drivers/-/blob/display-kernel.lnx.5.4.r1-rel/msm/sde/sde_encoder_phys_cmd.c?ref_type=heads#L1131-1139

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/589901/
Link: https://lore.kernel.org/r/20240417-drm-msm-initial-dualpipe-dsc-fixes-v1-3-78ae3ee9a697@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index fc1d5736d7fcc..489be1c0c7046 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -448,9 +448,6 @@ static void dpu_encoder_phys_cmd_enable_helper(
 
 	_dpu_encoder_phys_cmd_pingpong_config(phys_enc);
 
-	if (!dpu_encoder_phys_cmd_is_master(phys_enc))
-		return;
-
 	ctl = phys_enc->hw_ctl;
 	ctl->ops.update_pending_flush_intf(ctl, phys_enc->hw_intf->idx);
 }
-- 
2.43.0



