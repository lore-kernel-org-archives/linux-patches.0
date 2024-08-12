Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D626B183CD4;
	Mon, 12 Aug 2024 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480184; cv=none; b=IZXtijWC36TLSivRAwNf7oH0UicVcg95UWMWVuKws7+xvnbdLZswJCMmH2XJuRIdNm9d/Yu3evJNM+96n3ZR50N6d1sXtr7xkodE1ubGo6Oj988EgB0/JB2OHv4EgAu8U906As9w6mzavJNjtJEhhmQFW+ZuOc/kbCgnq82hOpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480184; c=relaxed/simple;
	bh=6iExEIsud7ATbJWT1yC0T5aB1TOUVz2JpSUi8TmoawE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ju5eREVEaTRYg1atqC3aCEc70FWnNHMiyiheMGvCw/IViDIVvt7bIto1MPn9oHF2APRpXnhTMaKATF+kODxonglFienlLhxnEf8Cf2ulw6tui2TEIEYciwmQIyPVn0lgCefKFKWyOsw30HC/6w94zmza6T2T1PgKYiKvzdU2NzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+RiBeHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+RiBeHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBA6C32782;
	Mon, 12 Aug 2024 16:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480184;
	bh=6iExEIsud7ATbJWT1yC0T5aB1TOUVz2JpSUi8TmoawE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+RiBeHrpL0XGo4nM8HAK1xqxE5gmGTzdhYmTAC8TIZyCBLlEMdeeWP3OLYHYOH1T
	 l7ISUffzSQF3R4PQfd4kouFcVUuSnbWT8qlK6RtR8IfzapeKQZYnp/Vdvz6rbTyV+j
	 z7eLh5m+2rtbei+HZFtpUu4I06kPSRppIOHEeGcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 089/263] drm/amdgpu: fix potential resource leak warning
Date: Mon, 12 Aug 2024 18:01:30 +0200
Message-ID: <20240812160149.952455676@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 22a5daaec0660dd19740c4c6608b78f38760d1e6 ]

Clear resource leak warning that when the prepare fails,
the allocated amdgpu job object will never be released.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 66e8a016126b8..9b748d7058b5c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -102,6 +102,11 @@ static int amdgpu_vm_sdma_prepare(struct amdgpu_vm_update_params *p,
 	if (!r)
 		r = amdgpu_sync_push_to_job(&sync, p->job);
 	amdgpu_sync_free(&sync);
+
+	if (r) {
+		p->num_dw_left = 0;
+		amdgpu_job_free(p->job);
+	}
 	return r;
 }
 
-- 
2.43.0



