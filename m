Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80572198822;
	Thu,  5 Sep 2024 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529748; cv=none; b=gMCWkiFsVzo/CTCIF/m8OAhDOE8zudfK/EBcPwXfebsGSacoGhqPxYHwAX3PSVKCWoeLdq/O59QB6iNkRqT3sE6optHwQYJfHffpVHcKECFlh5BTcj0FTFVLHrRdVKisUGKPJ6oQwXdErlzjbDQAcIZRbBBnN5saZIHXYxjxiho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529748; c=relaxed/simple;
	bh=2VZiO8n9KB+Ck3tDxX5jhxoMwcl0m6Mgq97nzisoCfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGT+DoSIDLJvP7lb2j5KTDtJwjDAGvMdl8PBV8ByhmFGRYAf6zoGNZ2SvpkKzS83wfCF8V9VqL/Zqs1cSxKOIj+iQrQamm+CBC2JxGHR5XImLLSg0wVGQOoojW2OZapNynLbEDd+nw/lGKGZ/6emb6UfhPdSIZAuOAI2tJD2h2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh0CBNe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh0CBNe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949FBC4CEC3;
	Thu,  5 Sep 2024 09:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529748;
	bh=2VZiO8n9KB+Ck3tDxX5jhxoMwcl0m6Mgq97nzisoCfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oh0CBNe4HpoDeWvV1MZuIG63N+nM8RLvl6CukHWlR1UhSRNF+/0HWZRMK4/Rj8Mq2
	 vdyWAL+zKN/CWUgiQ6QmV6z3Ij7BKgUtSromuuC4777jH89/V/vnbxTGNBkRQPM85H
	 0kZtsFZP0iJjeU3VqdkbUvafED+rmrBrovBOCzf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 090/184] drm/amdgpu: Fix out-of-bounds read of df_v1_7_channel_number
Date: Thu,  5 Sep 2024 11:40:03 +0200
Message-ID: <20240905093735.756585954@linuxfoundation.org>
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
index 5dfab80ffff2..cd298556f7a6 100644
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



