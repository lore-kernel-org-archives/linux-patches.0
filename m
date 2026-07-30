Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466F2435536;
	Thu, 30 Jul 2026 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424992; cv=none; b=X7tW/SbY3oDXm0N0PP/ZJGBRfhlRlPD74RICDQoHqtoSK2IC1BH0dWf7Al1VKjJv8YudJmU3gnpRHhNBfHENTgOEiiaKPShbUC7FY/FJnXzfWzUUHvfb+0JRDSDKZh1R4CwKH5rA4BpsKBCdMugN0UFifVXJEH73Zej/HZDjWko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424992; c=relaxed/simple;
	bh=KHoQpY1qVMOGZjNjPBQVVlKgUnL6lH806WTAD0qLihY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS04W/Ffi3zHMf6jkEzW6AwfBy6JPAHPuLtXVa2ZeSFjpCuXfwiqC7OCm31AxcZLsBQ6LRG01Y5YPZsvUC3a5lWjXE64l2sujgkPDrV8TcwOhHEx8VcbDeU3yZW3pnu4y8B0vTKEXEJnMsZGW1Gq90oCctUE54FtKiEC6YAVV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6uXNCMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6uXNCMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD01F000E9;
	Thu, 30 Jul 2026 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424991;
	bh=aWUQxX96oDkEKbWKBvEkza4CQi91sZECCuuGJh4Tj2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6uXNCMwQlmdVKsAwleY6MI+EIkT0B18SRwNgzZndvFjVo3nQ/zP7jK59cYNpI8ql
	 ltcUlnaz2YEcYPeejSPfJzvp7MRbbaK8o6UMBNsBKVTbGvwN/idxKtDGP3BhEMQMAf
	 920J/m2rOiWprptpqHW0FjsIKYq77XNJhG9nizLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 587/675] drm/amdgpu: invoke pm_genpd_remove() before freeing genpd
Date: Thu, 30 Jul 2026 16:15:17 +0200
Message-ID: <20260730141457.598457034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

commit 28c9b3c5dc35cc790d11e26ca3fc6e068be63998 upstream.

Call pm_genpd_remove() to unregister from global list prior to releasing
acp_genpd memory, and clear the pointer after free.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd8650d7a91ee8b768e202354672553faa5cc1f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -556,7 +556,9 @@ out:
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
+	pm_genpd_remove(&adev->acp.acp_genpd->gpd);
 	kfree(adev->acp.acp_genpd);
+	adev->acp.acp_genpd = NULL;
 	kfree(adev->acp.acp_cell);
 
 	return ret;


