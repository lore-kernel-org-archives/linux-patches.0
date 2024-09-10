Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574C2192581;
	Tue, 10 Sep 2024 10:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964765; cv=none; b=VWSvLLvD61yqYB4gATOmnMbdPISflapkwWenuDAmWvO5NWsmoIGfF+2EaO6l3rHaKPC5T1yLi6KOGbxgCHoFVQZj0CgjJvIPGM5FU/1q11GxhS5nEGG4S+bEV027gloBjzcp1QjsqqlXrFmVkh5x8gwEvshNHuh+B5ikxYDPFls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964765; c=relaxed/simple;
	bh=Hko0bJkCl41i0v0zu4aS53uHH2I+csXu51Z5omVoHiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLCX23IGm68Xqq57a7VZ4IwYVbgdf/Q0lHBbjBQSSNCzPuRRt+R+gT8Cjj16Qtlg0lfZrtS/YC6BvrvpJYn0wEMAiEw0LEH5+NtxkU2O8RNtK3bPty40sw/O/zDhowUTFyRWIhHtYf0GpoBiQd55jQuHvphoTxocaU2pWMCDFUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcriNV0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcriNV0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1924C4CEC3;
	Tue, 10 Sep 2024 10:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964765;
	bh=Hko0bJkCl41i0v0zu4aS53uHH2I+csXu51Z5omVoHiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcriNV0MpgweWra+fDqKqIZUbVErfzXksfC3QyTFv5Tgr8IglQVXUBibWu9YETg1x
	 E6gxMxqbzrew0dFAZWGkBcA4u9pP7Mjr5ezIM/Msf/3FDZ/Kt0iaeSbmokt5ypeGI4
	 d3AcPdW0WWUIMe+z2LAOLkIJuycJK+QPUjmUiRdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/186] drm/amdgpu: Fix out-of-bounds read of df_v1_7_channel_number
Date: Tue, 10 Sep 2024 11:31:58 +0200
Message-ID: <20240910092555.580230347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d6aca1c08068..9587e8672a01 100644
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



