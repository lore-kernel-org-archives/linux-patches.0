Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C424227FD75;
	Wed, 23 Apr 2025 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420866; cv=none; b=iwZhbgzir7rbzrYeOBusX5gBH5ciiEg0DS2zLKAPJZgoJ7IZwvLshHd9adOmk36Wi67tGO3QgOgIoMa99gT5ffkmVI+J3HV1XaGXmiRnAokaYWAQrrP+2L6/TraIEEWMKWHp9ii2kqCWg6NFZoCoexXDNdr5E+Jc71zsPVxZa94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420866; c=relaxed/simple;
	bh=sz+SJ2htUNM3dBY6abvEi+DCnyhUKeQ2G3itq5k+FAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewF0ZUYLrb0sR5P6pYy1JLHO8jsYacS1aAMyTSXMd1REvprfFMo6mFplxxZ7yn9WiaX53UK8HZhbH9Xw8myxOo4wciBZllk5RG0Cd1WgN5H+yyVfsobRRUY+FZOxcoT1JnoRhElUSuv2sEqL5xKqhiLbTE6hor6wD9VFNS1nahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfpNKV3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfpNKV3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BDDC4CEE2;
	Wed, 23 Apr 2025 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420866;
	bh=sz+SJ2htUNM3dBY6abvEi+DCnyhUKeQ2G3itq5k+FAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfpNKV3oSvwEUHI20xdqZyXzvEXT+KTphiVnH2ADbrqtnEoGsvohpp9NH9KGcfcI3
	 iHJamJ1ZwKwoDd52yKhrL2kFPEjf+De/yG2aoPh3xjITG3rM9LVEkkKahx0EX723xO
	 KRVFYF39TXW5dx3vjsR1euFLF+KA99rmyhyFPKII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/393] drm/amdkfd: debugfs hang_hws skip GPU with MES
Date: Wed, 23 Apr 2025 16:40:00 +0200
Message-ID: <20250423142647.583838925@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit fe9d0061c413f8fb8c529b18b592b04170850ded ]

debugfs hang_hws is used by GPU reset test with HWS, for MES this crash
the kernel with NULL pointer access because dqm->packet_mgr is not setup
for MES path.

Skip GPU with MES for now, MES hang_hws debugfs interface will be
supported later.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 9d0b0bf70ad1e..2786d47961e07 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -1388,6 +1388,11 @@ int kfd_debugfs_hang_hws(struct kfd_node *dev)
 		return -EINVAL;
 	}
 
+	if (dev->kfd->shared_resources.enable_mes) {
+		dev_err(dev->adev->dev, "Inducing MES hang is not supported\n");
+		return -EINVAL;
+	}
+
 	return dqm_debugfs_hang_hws(dev->dqm);
 }
 
-- 
2.39.5



