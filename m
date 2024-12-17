Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57E1F8923;
	Tue, 17 Dec 2024 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456550; cv=none; b=TUT7Wfr78XZC2oQEmWIYB03RpSrYGOM5AXM/v1RRgAHwvlQe0LQAQpSSqnsqx4oVEjp9Z69D4/mM75jz4Dy+L5cg7jbb5Rd3xfYEjvv3glKpzVpFLTedv8ISc2z3uOcLLPsgp12EB+s5SI+YZqU5HWL6AD016E4HS4DrACAYY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456550; c=relaxed/simple;
	bh=YNNTmUMn+cKLsvx7qeLrOhOw1PqnqY7PYkO+uEYEBpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpxbfOv9XrXoAu6HeskhxvjL5XpiK2Zxz43LNj1qKSrVkcf5MB5j+1DEjGZDb8Wp7//twbbQgekfhLKQsyybEFDyUOZ7wGTDgnenZ7Q4Eo+3OD0WglkJPKiN27oRGZCjp68WQNruWfocJ5ynB/a1/QajHpG6SBpUf+9iWVRgSxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWdaZfH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWdaZfH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A8AC4CED3;
	Tue, 17 Dec 2024 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456548;
	bh=YNNTmUMn+cKLsvx7qeLrOhOw1PqnqY7PYkO+uEYEBpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWdaZfH2vp8qAwRpf11uDo33/8aT3NJtumk+H1asuBBdr5ELntC+CooAZVtOpipIp
	 b2cGcS2y+6OhbGfUnBwjlJgV14ih6iXQBErYIHxdSfsn6QrVFov5QH+BHE9b7rUO0u
	 VdSu3bm0Dp9dmDFSE/t4NQfTMSSFEsxCSGaph3JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/172] net/mlx5: DR, prevent potential error pointer dereference
Date: Tue, 17 Dec 2024 18:07:30 +0100
Message-ID: <20241217170550.192259041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 11776cff0b563c8b8a4fa76cab620bfb633a8cb8 ]

The dr_domain_add_vport_cap() function generally returns NULL on error
but sometimes we want it to return ERR_PTR(-EBUSY) so the caller can
retry.  The problem here is that "ret" can be either -EBUSY or -ENOMEM
and if it's and -ENOMEM then the error pointer is propogated back and
eventually dereferenced in dr_ste_v0_build_src_gvmi_qpn_tag().

Fixes: 11a45def2e19 ("net/mlx5: DR, Add support for SF vports")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/07477254-e179-43e2-b1b3-3b9db4674195@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 3d74109f8230..49f22cad92bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -297,7 +297,9 @@ dr_domain_add_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
 	if (ret) {
 		mlx5dr_dbg(dmn, "Couldn't insert new vport into xarray (%d)\n", ret);
 		kvfree(vport_caps);
-		return ERR_PTR(ret);
+		if (ret == -EBUSY)
+			return ERR_PTR(-EBUSY);
+		return NULL;
 	}
 
 	return vport_caps;
-- 
2.39.5



