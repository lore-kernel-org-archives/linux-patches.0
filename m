Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20F56AB9;
	Tue, 23 Jan 2024 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968423; cv=none; b=ZZb4WZrjtF37A78xUOC3lLy+hRAdbI6MY6kFjX1xnW1K1cBH705at+vkHioZKgIQgXbBagIGHWHCAGWe8oCmfuY1B1BzQcFugQpbQQGg/RkrHcAbirwme1MF/ErQiEx7ZfQUCkxvdBGEfH5uejzLZqDAMnUQ1yym839qZZC+Owg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968423; c=relaxed/simple;
	bh=ywqw4rgJo3h/5xgVJ80ItlSLMf/7SoPRIeogiJiI6B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnWSRWB0XiNvdX5nLcd8dRo4jY02oOjHvg3ScWqTSAKFmkCliR574EepA8uaS+QKxgJoq5NFf5d0jsXpy7AIMd/l6Fr2ygnwCjXBCDv2PqI+u7koeu38Q1PM/K/Rfm1pvgczPusKB54TNRjv8E5HjTBJdeBv1PMAQjJ4/GiFE+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faKdbKEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faKdbKEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CCDC43390;
	Tue, 23 Jan 2024 00:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968423;
	bh=ywqw4rgJo3h/5xgVJ80ItlSLMf/7SoPRIeogiJiI6B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faKdbKEtCw0l4/n8KS9qWwSp94izA6CaBlkvJEI4hTnKIYvQLU800FPSBYUoF7K6r
	 +r91hBQh6BoEnypr/xv4jA+sGIc+xVLg9upRnM/wFifvlafgRNVWD/1ahxY8FLw797
	 yW56necrpRWWe3OELUcKWv9IajAljm1tuDPbLdHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/148] drivers/amd/pm: fix a use-after-free in kv_parse_power_table
Date: Mon, 22 Jan 2024 15:57:40 -0800
Message-ID: <20240122235716.633198507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 28dd788382c43b330480f57cd34cde0840896743 ]

When ps allocated by kzalloc equals to NULL, kv_parse_power_table
frees adev->pm.dpm.ps that allocated before. However, after the control
flow goes through the following call chains:

kv_parse_power_table
  |-> kv_dpm_init
        |-> kv_dpm_sw_init
	      |-> kv_dpm_fini

The adev->pm.dpm.ps is used in the for loop of kv_dpm_fini after its
first free in kv_parse_power_table and causes a use-after-free bug.

Fixes: a2e73f56fa62 ("drm/amdgpu: Add support for CIK parts")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
index 91504eccc60c..91a1628cd48f 100644
--- a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
@@ -2734,10 +2734,8 @@ static int kv_parse_power_table(struct amdgpu_device *adev)
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		ps = kzalloc(sizeof(struct kv_ps), GFP_KERNEL);
-		if (ps == NULL) {
-			kfree(adev->pm.dpm.ps);
+		if (ps == NULL)
 			return -ENOMEM;
-		}
 		adev->pm.dpm.ps[i].ps_priv = ps;
 		k = 0;
 		idx = (u8 *)&power_state->v2.clockInfoIndex[0];
-- 
2.43.0



