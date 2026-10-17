Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739301DFDA1;
	Sat, 17 Oct 2026 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257642; cv=none; b=XWJ6dyT/m7nNVUiJU0ADLi0sNm5+Y7lSCv4+gw9XvFCOUY5+3jYq0+JEi8RVnezii69C2tq6oOmSMpO9Pzn+RlW+ymhr/YdMUhouv4uXZ8L0copd4I2EakPPpW4rvBdmOk01x53+pXzUMtRxqmmYXlRYrKOKxvXmdAj0KOvMx/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257642; c=relaxed/simple;
	bh=tqZwOpDrhl/vCeJKpjbLqEi3FJZmb7naDxtIZodErK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmFl9ZBuWcMisB9Rit/+M4Q778UCFCJvjT4SzXldn1myO694pl4eoTc1odlP3Y02kZwhIZqxHCMJPbQb1QdY/Ng2TxWYJ0tdnhmcV4davLjuEWKs8EY0AueTtuuyWAnSD3ogdiviv6dPdTcMSpCtd+1eCyz2Hle7b15IoIaOns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFIUa3W/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFIUa3W/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA3D1F000C4;
	Sat, 17 Oct 2026 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257641;
	bh=9eEBSVTNmXW8HhYrAt9an2+CfR6bI1+PuSPGYsDTgVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFIUa3W/BMUErhIhnqrSHUrYh9+doFMxeS8bkM2EbSb4oeGvb/5xTAzcPI2geVDLH
	 QLye3oMl1hRhOSa4L9M649KU9ZZdrRtp3kgW0XkjJIlAc54WnexZbZC7PL9e88DKE6
	 nsxTO5F5ex+oazC+6mb0liXLV3tU7i1DW+bEmT58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0625/1674] drm/amdgpu: fix double free err_addr pointer warnings
Date: Sat, 17 Oct 2026 17:48:17 +0200
Message-ID: <20261017160447.130952937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

[ Upstream commit 506c245f3f1cd989cb89811a7f06e04ff8813a0d ]

In amdgpu_umc_bad_page_polling_timeout, the amdgpu_umc_handle_bad_pages
will be run many times so that double free err_addr in some special case.
So set the err_addr to NULL to avoid the warnings.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
index db0d94ca4ffc5..cf6ebb10acc90 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
@@ -162,6 +162,7 @@ static int amdgpu_umc_do_page_retirement(struct amdgpu_device *adev,
 	}
 
 	kfree(err_data->err_addr);
+	err_data->err_addr = NULL;
 	return AMDGPU_RAS_SUCCESS;
 }
 
-- 
2.53.0



