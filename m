Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DC722D4C3;
	Mon, 10 Mar 2025 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628893; cv=none; b=AiLo5mcBDfRmeHybKR+uNZjdZlVZEJqnQaUn9R8tErm/7r83f9dT8SfbIjTnIjpdj/GoXPTSaxThI2bTZ3N5a0PvP4Y8IVQ9m6IvJJV3DMl9xcdgiLiftZDX8Hj136XApyY8/gd8hR2rat9s4yJ6Wcpro/mZLVS99IIEO7yNqB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628893; c=relaxed/simple;
	bh=ZiTATUYIkiuL/G8bmTvOxStyp+USIWbchZCl5WXCuqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/oV9L0F23fYC3a7z5l2WLsLqvAFqHuRFF5hDITlCDFIjTsukHPN7oViM+xYrxvnCp8DV+LQd9wOJ+v4yN5Wfcej+A9ru13QN0ckjWT9r9MoqDdr6SsnQlh01aVulosNvO8DTdX2Nt8iaUuKmooxkq9b/MbWrBc9RuGbPQf8Daw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckzD5llg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckzD5llg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AE3C4CEE5;
	Mon, 10 Mar 2025 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628893;
	bh=ZiTATUYIkiuL/G8bmTvOxStyp+USIWbchZCl5WXCuqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckzD5llgS2WbxPU8tYhzhkbZK2HuI/Oq7L0tZPJVP2AjNunRwtb0nxdo7BD+nSbL9
	 g8sfmMAtpTlmleIPORZGvULDg4O8ENgfdcmrvlQShLSMDFRs3HHLGwOPhzUBWbJl0C
	 F1ZgR6aR3Kq08dtWqqGSClXuLxP0SymcvzO5Rh+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/620] RDMA/mlx4: Avoid false error about access to uninitialized gids array
Date: Mon, 10 Mar 2025 17:59:11 +0100
Message-ID: <20250310170549.748851310@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 1f53d88cbb0dcc7df235bf6611ae632b254fccd8 ]

Smatch generates the following false error report:
drivers/infiniband/hw/mlx4/main.c:393 mlx4_ib_del_gid() error: uninitialized symbol 'gids'.

Traditionally, we are not changing kernel code and asking people to fix
the tools. However in this case, the fix can be done by simply rearranging
the code to be more clear.

Fixes: e26be1bfef81 ("IB/mlx4: Implement ib_device callbacks")
Link: https://patch.msgid.link/6a3a1577463da16962463fcf62883a87506e9b62.1733233426.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 53d83212cda81..67a1ef0260b24 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -392,10 +392,10 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 	}
 	spin_unlock_bh(&iboe->lock);
 
-	if (!ret && hw_update) {
+	if (gids)
 		ret = mlx4_ib_update_gids(gids, ibdev, attr->port_num);
-		kfree(gids);
-	}
+
+	kfree(gids);
 	return ret;
 }
 
-- 
2.39.5



