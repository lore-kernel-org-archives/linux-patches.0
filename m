Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4A71F76A2;
	Tue,  3 Dec 2024 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241081; cv=none; b=P/a5AafM0lux6MoH6V+s0+czIKqKVi7LNsS9rCpJ2Y8nud423QDh7We4jkkIRq3V/nE9e+K8LO92QSc8YMM9RNkTf4QRm+vjHQBPK90KtjGfuFqa6zks+NE7lmFzIjfc7aNsqkBXG34NhpQuSmdwxgYjgtMhbgJXPmghemE7QGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241081; c=relaxed/simple;
	bh=yCyvTZynhZ8S9ypKO1/f4lO93u+pQKb4n21mDiiS9HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIZAiNFaN1wpAeJ0giuyNV3wIcQdvtfHNpn/CNkITeYnRzmklj1sRbP5hsN6N4jAO110cM9eddONSBacliV7tIZpLj9ELdXJejX7jDN4FB7wGCan6dtAgaE0XuGxMV5Fj0OrpPUUzbnp5KaYoMxf5c99sIJ/4BmeHnMgrTKQURU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTfG9sRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTfG9sRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E1CC4CECF;
	Tue,  3 Dec 2024 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241081;
	bh=yCyvTZynhZ8S9ypKO1/f4lO93u+pQKb4n21mDiiS9HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTfG9sRuXwjjxOp724t8iHyVutYEQOJTNJB0LIIUfDJ8IMpsHEQQYOFB+WQ3LARl7
	 +M2E5S71zFAiNXF3ZYXbd1Xqv0iMWGfy1FOTAUc5rE/ftXE7GnNNBn6Y+hXuuIzdJZ
	 wus094HUgOs1wH+A20s7UrYYOwrecA9LP0tQb548=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/826] drm/amdgpu: fix ACA bank count boundary check error
Date: Tue,  3 Dec 2024 15:40:47 +0100
Message-ID: <20241203144756.245535764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 2bb7dced1c2f8c0e705cc74840f776406db492c3 ]

fix ACA bank count boundary check error.

Fixes: f5e4cc8461c4 ("drm/amdgpu: implement RAS ACA driver framework")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index 2ca1271731357..9d6345146495f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -158,7 +158,7 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
 		return -EINVAL;
 	}
 
-	if (start + count >= max_count)
+	if (start + count > max_count)
 		return -EINVAL;
 
 	count = min_t(int, count, max_count);
-- 
2.43.0



