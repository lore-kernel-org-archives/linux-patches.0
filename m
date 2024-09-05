Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DCE198E81;
	Thu,  5 Sep 2024 09:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529616; cv=none; b=Yn8txm9Ttqd9P5M6h+wW6lT5kgVISwGhmR9MIkZFV+OK6QdiuZax2769rEb0pMU8D0dLju1IgRTcDQRaRSt6bv7uvHLiFRP64RxfH1PGPc3Qc7J+ZypZGIYeiH+8KTC5Qhl6Elxa8rXy3/N7wNLkx1wnZTFWEb+7Wwjl4CX+gfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529616; c=relaxed/simple;
	bh=qbcDWiKUysSLf98S3DSv+YEpSYCH0SRJbUL9Rp07M/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWpK+HmbPhdlXr0xm2JsWx0Lg1ULmAj+bo05SP3vJDwMQAJLGt/5CP5dtQ1Eq5ugNdFNFyKPoXpCe+53A/Ivxp25IKI0GohWa5R972Qdd7NE+wY2rw3i6Kn9YLEtJRJk7u5uW3AYsVc0rL3aPuQroYbFf2EGib7xHXCg/3iFzz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyFz7RR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyFz7RR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8084CC4CEC3;
	Thu,  5 Sep 2024 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529616;
	bh=qbcDWiKUysSLf98S3DSv+YEpSYCH0SRJbUL9Rp07M/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyFz7RR9gP1ZPRsQ7aI0l0yZ0txDhET7TitEy1rkqrc+fQ/bszuHuUeiwzl8Jwebm
	 iWgjRrGO47nNMk2GkiHnhjYJLYKkguJMaxdnHJzMO2qhvoQ+S0vzaVEOFK7USa6ANt
	 sSEnm32s74Ay3kUoIyzwdZGhdOSpEbCwBA5d0reg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 088/184] drm/amdgpu: fix uninitialized variable warning for amdgpu_xgmi
Date: Thu,  5 Sep 2024 11:40:01 +0200
Message-ID: <20240905093735.677195732@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 8f184f8e7a07fddc33ee4e6a38b717c770c3aedd ]

Clear warning that using uninitialized variable current_node.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index dd2ec48cf5c2..4a14f9c1bfe8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -434,6 +434,9 @@ static ssize_t amdgpu_xgmi_show_connected_port_num(struct device *dev,
 		}
 	}
 
+	if (i == top->num_nodes)
+		return -EINVAL;
+
 	for (i = 0; i < top->num_nodes; i++) {
 		for (j = 0; j < top->nodes[i].num_links; j++)
 			/* node id in sysfs starts from 1 rather than 0 so +1 here */
-- 
2.43.0



