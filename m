Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBCA54FA5;
	Tue, 27 Feb 2024 13:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040912; cv=none; b=hcPxBDqm3qu25w8znzqhhkqywIKvixw54K56+sbaxXfhwEYpEhQ/uCsz6OAR5fskwqkc1i+2J3Apva3x12mX50VUaxyTj/Zuu9gO+YpfMYSrtWSZDm2h5kA+0VJxa2e90PcRembRGbzv78yNrbjTgV2pUgVCbyxF4TY5C5mm2tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040912; c=relaxed/simple;
	bh=65mTDzkKSonuiFyuDlmA1OL+4YIJ502d5H8EhVXCrnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGPlX/GPN/DCtxwpdj//dzBDiOoHCpIDo8Z+NNp/3od6Sfb89o6wUqkthZbEqz/p7X7B2Hjge/ddKzbJITMcaiHbH53cpOpOKDHqJ47EspGUyGlLRqCH+OQYDYbIcgpkzKbS5xl3lOxStfWnnmJO+PMWPg+N+S/OfpEaGY2vE70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QSWbnrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QSWbnrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA5FC433F1;
	Tue, 27 Feb 2024 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040912;
	bh=65mTDzkKSonuiFyuDlmA1OL+4YIJ502d5H8EhVXCrnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QSWbnrViD8nfbL058mT7qD4CGusXiHcv5kuqxpz+yME12PqW7if1UQVPR+vcYpzv
	 XQfmNjhDwlc+4i1r58kuem6tvK8YooWDsPZxd499ClVYewqcDALNxl2N9vPMdUbc8j
	 PGAiNgvIcPKmHBhISyD5s21puLkGS3WXrnHjI2Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 126/334] drm/amdgpu: Fix shared buff copy to user
Date: Tue, 27 Feb 2024 14:19:44 +0100
Message-ID: <20240227131634.531473556@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley.Yang <Stanley.Yang@amd.com>

[ Upstream commit 2dcf82a8e8dc930655787797ef8a3692b527c7a9 ]

ta if invoke node buffer
|-------- ta type ----------|
|--------  ta id  ----------|
|-------- cmd  id ----------|
|------ shared buf len -----|
|------ shared buffer ------|

ta if invoke node buffer is as above, copy shared buffer data to correct location

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index 468a67b302d4c..ca5c86e5f7cd6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -362,7 +362,7 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 		}
 	}
 
-	if (copy_to_user((char *)buf, context->mem_context.shared_buf, shared_buf_len))
+	if (copy_to_user((char *)&buf[copy_pos], context->mem_context.shared_buf, shared_buf_len))
 		ret = -EFAULT;
 
 err_free_shared_buf:
-- 
2.43.0



