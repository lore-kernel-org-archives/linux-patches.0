Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85647194AD6;
	Thu,  5 Sep 2024 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530261; cv=none; b=ADQNMyDxaYWdhqGLnK6FUCVQR2Q+Vl/IzjNJlueTjscP1XjVLaCCOqvotQrv4DIQoDKfuQ8lDoqKMz4iAROQ9wvDpLI+GLZZS07kOlQRq0ljd/BD9dcSUbPQ0bEbY3O6pbDem9y1w2C0Z/KU9vcmtyfJ8bvaTLbMM7dVtoMGlX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530261; c=relaxed/simple;
	bh=c0fip1migE4ILTfqT5rbULJ3f9FpbrRqa243fTk2hO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2QqgZKE9eMsv4BwLrQK0e81lMRyY161DkI5wHsK+/f+4YIS9C2KjdtHNTzGXWz5Gs38Att7jVRQpbhG7Ny1iU5ZahC7n66p+NP2835Aio04tpN8o3DyDb0lDRzZaRNh9nrECHJZBs5PrbzX/13Ap71Aj5HUL0Jot3OpcXxd50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zZdRhKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zZdRhKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1F9C4CEC3;
	Thu,  5 Sep 2024 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530261;
	bh=c0fip1migE4ILTfqT5rbULJ3f9FpbrRqa243fTk2hO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zZdRhKhwmJ+gq6Wf4L7Nuu2uefw0o4DpMbGedN64vwCI8ORtYKFuXHHaLuQl5tjs
	 X0m0RGaIQ/dJq1zvHQL1ruZC2vrdt1jAQ1Qoit9cZGqQFPKscoajZNo+0cpRScLIbM
	 vLI2AKQHp9Fn+YrxBc3ENEg0ixEK5vxp6H2VJ0hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/132] drm/amdgu: fix Unintentional integer overflow for mall size
Date: Thu,  5 Sep 2024 11:41:31 +0200
Message-ID: <20240905093726.280123727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit c09d2eff81a997c169e0cacacd6b60c5e3aa33f2 ]

Potentially overflowing expression mall_size_per_umc * adev->gmc.num_umc with type unsigned int (32 bits, unsigned)
is evaluated using 32-bit arithmetic,and then used in a context that expects an expression of type u64 (64 bits, unsigned).

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index cf2faeae1d0d..b04d789bfd10 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1550,7 +1550,7 @@ static int amdgpu_discovery_get_mall_info(struct amdgpu_device *adev)
 		break;
 	case 2:
 		mall_size_per_umc = le32_to_cpu(mall_info->v2.mall_size_per_umc);
-		adev->gmc.mall_size = mall_size_per_umc * adev->gmc.num_umc;
+		adev->gmc.mall_size = (uint64_t)mall_size_per_umc * adev->gmc.num_umc;
 		break;
 	default:
 		dev_err(adev->dev,
-- 
2.43.0



