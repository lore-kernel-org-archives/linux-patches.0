Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9598820FB8
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4DFC433D9;
	Fri, 21 Jul 2023 19:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966855;
	bh=i6VymhsLQytxzno3ew3//5OfujOAWmGW9DnLwFtelCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSCxeo4SrMVRVAO6x7Xq6JEUUjfPbHghORq4O8ZA76CCqfdxd5iAPCSS868y6MvLA
	 Kso8iCOZLsz/pTQ2GIYVP3p5LlLO6H4gkfYSGbp21j62mwdfO4+iZvYtV+k+S1AAna
	 QOlnYggakip0cu2odNtZLnbhYU6eB+/isdAwZMho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gaba <gaba@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 491/532] drm/amdgpu: avoid restore process run into dead loop.
Date: Fri, 21 Jul 2023 18:06:35 +0200
Message-ID: <20230721160641.178114871@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: gaba <gaba@amd.com>

commit 8a774fe912ff09e39c2d3a3589c729330113f388 upstream.

In restore process worker, pinned BO cause update PTE fail, then
the function re-schedule the restore_work. This will generate dead loop.

Signed-off-by: gaba <gaba@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2350,6 +2350,9 @@ int amdgpu_amdkfd_gpuvm_restore_process_
 			if (!attachment->is_mapped)
 				continue;
 
+			if (attachment->bo_va->base.bo->tbo.pin_count)
+				continue;
+
 			kfd_mem_dmaunmap_attachment(mem, attachment);
 			ret = update_gpuvm_pte(mem, attachment, &sync_obj, NULL);
 			if (ret) {


