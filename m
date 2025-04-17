Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE802580E0;
	Thu, 17 Apr 2025 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913010; cv=none; b=EG6NBM/E6cinMbqTJZpZTiZFOzdwmSijytqd3uWIaGnLD3igWS3IF1mGy1yetoe9aVTW5T/QNib+N8BxlwciQ73ldlOu7R1AQdeTO0o4mWjrijMyhofevZHWub6w1TSBsbnqpwYfIxbm3YAEhacV4mmR40ftiRb6n0S/y/EJF38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913010; c=relaxed/simple;
	bh=VClG+dK5Qz/CLgJPrzJO706wsXm4d4Xho72hnrJSuXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFKTLxTuvPFbqAS9dqcSmHBtChiqM56t8zhNuwC+lwRE8TCUZ9K5JoHrjVrYyEBJN6JI/HodQIkfkRVtBa9bnFYMDr3szK2lmL7jDT/04FKZIlqFRmkLLIT8dQNZ9kxXpoJAfPWi7Ub/2wG3e/d9QgrtlX5pdK0/9jqw8tJR574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOfylFg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOfylFg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAADCC4CEEA;
	Thu, 17 Apr 2025 18:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913010;
	bh=VClG+dK5Qz/CLgJPrzJO706wsXm4d4Xho72hnrJSuXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOfylFg8hAYUR1adnD+WO//aIGbEWKeVGE4AX+2PtiVL2o8qTpruogPjxtGi8lFtv
	 cZxAnB3ut3D6BynYb7aGzA7cPXEgHUK6dN2G1rkWCWW/Q00CvdZRqPWT/OfcpZlSoK
	 pSKSf2KKRmUzgMz/E/Z0UkMXnXnwS7qQ4KsWMGOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 168/449] drm/amdkfd: debugfs hang_hws skip GPU with MES
Date: Thu, 17 Apr 2025 19:47:36 +0200
Message-ID: <20250417175124.743571753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index a29374c864056..6cefd338f23de 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -1593,6 +1593,11 @@ int kfd_debugfs_hang_hws(struct kfd_node *dev)
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



