Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225E6198E61;
	Thu,  5 Sep 2024 09:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529603; cv=none; b=QSNO2PGV3+BWm7cC3b527LKFm3htgjp8ywVxoWsnBNU8S254CcV2R/u641amR1PAefD3yqIOKRUdmsCYIk7oYxRAYqmDYWlIPHj8xEM1fE4JBVTMWPT8D1ddjIV6YTC+u0+G/7BIWrYO8QWRgY389H7d87TCLmBRazDvLbxFgHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529603; c=relaxed/simple;
	bh=L9t0hj6IFkVe/klXMlxWFb4zH7e+cN66SQws/6/3IdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZdkLfnN0Ytx7y2ood+KJg4N62GUvyE1g5f/BqXfsDLL63UAr+RUu04RC7OXYgjRrRRHAd/cV6w/soavHx7+z51Lb1sB3lgcMHB8bAb8OymMg+Y2XC0cT0pmkAOOmeskQ/TdQRdg3Hqg8proCbMvRPBpHUS+BqFbqlZhrs5MUzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJl1Ia8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJl1Ia8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BFCC4CEC6;
	Thu,  5 Sep 2024 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529603;
	bh=L9t0hj6IFkVe/klXMlxWFb4zH7e+cN66SQws/6/3IdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJl1Ia8ZlSz2gQ0SOfP5hY/mgB0x3sVO/xORe0yn9PdlmFT518YmJb+nXf6biTtlD
	 jOPGQtroApg4LQNyHaW3Lg4zDqWtIfpLMsfD5dUjUsGnZXSaOkftdqtqEeJLR/GP+y
	 GMbVF3YbRQkXGe72WsmtR6IagkrzaPo8f3n8mxY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 085/184] drm/amdgpu: Fix the uninitialized variable warning
Date: Thu,  5 Sep 2024 11:39:58 +0200
Message-ID: <20240905093735.559701287@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 7e39d7ec35883a168343ea02f40e260e176c6c63 ]

Check the user input and phy_id value range to fix
"Using uninitialized value phy_id"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c
index 8ed0e073656f..41ebe690eeff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_securedisplay.c
@@ -135,6 +135,10 @@ static ssize_t amdgpu_securedisplay_debugfs_write(struct file *f, const char __u
 		mutex_unlock(&psp->securedisplay_context.mutex);
 		break;
 	case 2:
+		if (size < 3 || phy_id >= TA_SECUREDISPLAY_MAX_PHY) {
+			dev_err(adev->dev, "Invalid input: %s\n", str);
+			return -EINVAL;
+		}
 		mutex_lock(&psp->securedisplay_context.mutex);
 		psp_prep_securedisplay_cmd_buf(psp, &securedisplay_cmd,
 			TA_SECUREDISPLAY_COMMAND__SEND_ROI_CRC);
-- 
2.43.0



