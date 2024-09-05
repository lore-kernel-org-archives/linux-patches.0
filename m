Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79219413B;
	Thu,  5 Sep 2024 10:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530538; cv=none; b=FgFKK5wbIF0wgF/5iUp3LG1AxQExVq/uLLawgyBbVZHS4zKJ+dEigqHCLES9UsSMQtDZckE4jJ/iML4u2z3vLu0gJDzuiDmdukjRXwD2WyK+Qatz6IVDlg8yohYMEcbWl+teDhIsmetN24ivYFP1i0tJcsa/eodRyudw3wfuJTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530538; c=relaxed/simple;
	bh=dNOs1CcROZHSaJe0jT/ElweRZ1XN2TPGMrOzjjlk4UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tim/VdplxszL1gNrOgvX+y83d738Afx8JYoao019qCdWvK/vKGVyaIMODNT52ZaIVgzMrzItriQUZGv5Qtrb6Iu3Q4OF6Zyk9oOXy64nCaCpfyXnJaYK1Cj0pHjV4UHJpac4R8BdCm29e6w2vClpvS5s0X8DWOVWJWZFrgF9fV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvEL8tZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvEL8tZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522F7C4CEC3;
	Thu,  5 Sep 2024 10:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530538;
	bh=dNOs1CcROZHSaJe0jT/ElweRZ1XN2TPGMrOzjjlk4UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvEL8tZPXDn5Abp6g3mYHCoYrPgfQR2JTyUpohiGAx4X/JcBLalyQ+ygfUwwjAbai
	 4P5cAfXV99ClgiW5PMK+8gNw/X7pqANbctTgSu4qE2p1ZtcIlpz/Eqk7PQ5h8eGpQt
	 jQRkHZJ3kuQcpRNWG0RNkwyUIZjM6NwtOxeRsmfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/101] drm/amdgpu: Fix out-of-bounds read of df_v1_7_channel_number
Date: Thu,  5 Sep 2024 11:41:26 +0200
Message-ID: <20240905093718.248882586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit d768394fa99467bcf2703bde74ddc96eeb0b71fa ]

Check the fb_channel_number range to avoid the array out-of-bounds
read error

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/df_v1_7.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/df_v1_7.c b/drivers/gpu/drm/amd/amdgpu/df_v1_7.c
index b991609f46c1..d4909ee97cd2 100644
--- a/drivers/gpu/drm/amd/amdgpu/df_v1_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/df_v1_7.c
@@ -70,6 +70,8 @@ static u32 df_v1_7_get_hbm_channel_number(struct amdgpu_device *adev)
 	int fb_channel_number;
 
 	fb_channel_number = adev->df.funcs->get_fb_channel_number(adev);
+	if (fb_channel_number >= ARRAY_SIZE(df_v1_7_channel_number))
+		fb_channel_number = 0;
 
 	return df_v1_7_channel_number[fb_channel_number];
 }
-- 
2.43.0



