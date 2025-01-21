Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3271F7577;
	Tue, 21 Jan 2025 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482233; cv=none; b=iwqN4knRanFickFPjhzNRQf9xlDPW3wpimDTwD21320HyotsDvNkf/W2DHrJ8XbaJqQkB3zkv3JLmxgbyDoX9KGYhtIWT2G+WzhFn/JADX1M8UwHoU1/llRPDrZgWMB21iBCrmvY4waUV30QWyJ+7xERjvdPdiuCqNXW5qxwBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482233; c=relaxed/simple;
	bh=IlGE7L4RwwugqGiNdGuZKvFOd5z9YPQr1zD+4GSUcPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rsnSyidDim/W1M1hofhwRzWrHxxB+EHfbKxeBTxRmO61KUeOeFyxG+fEUYQcyvwJbkKxXND5EHAqFHe41307o0e7DmGUY44LKPVHkQPQYvsi+9aP1W1O1qvs/4EgJrmj0Ac5sB8VN0Y9Ge2jfdINEy7xlHAzTX7OXHivAmYaS6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQI+Hlwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQI+Hlwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2793DC4CEDF;
	Tue, 21 Jan 2025 17:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482233;
	bh=IlGE7L4RwwugqGiNdGuZKvFOd5z9YPQr1zD+4GSUcPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQI+Hlwd+iqEH8J3iQHiYQTg+waT8zb1ve4cX8Qcn759jr2qadspEfDPQ1utUX5bs
	 ZU9+nOjdbeVjao+YLL5ZvlPFjzjBBn+tPXLuzHHQTAXkXhO31H4LrO69/Stc1o2FWl
	 V5gNzgNvfJBFdcnTu78mzvnVfcd78QJviAbCe4bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 60/72] drm/amdgpu: always sync the GFX pipe on ctx switch
Date: Tue, 21 Jan 2025 18:52:26 +0100
Message-ID: <20250121174525.745823594@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christian König <christian.koenig@amd.com>

commit af04b320c71c4b59971f021615876808a36e5038 upstream.

That is needed to enforce isolation between contexts.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit def59436fb0d3ca0f211d14873d0273d69ebb405)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -193,8 +193,8 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 	need_ctx_switch = ring->current_ctx != fence_ctx;
 	if (ring->funcs->emit_pipeline_sync && job &&
 	    ((tmp = amdgpu_sync_get_fence(&job->explicit_sync)) ||
-	     (amdgpu_sriov_vf(adev) && need_ctx_switch) ||
-	     amdgpu_vm_need_pipeline_sync(ring, job))) {
+	     need_ctx_switch || amdgpu_vm_need_pipeline_sync(ring, job))) {
+
 		need_pipe_sync = true;
 
 		if (tmp)


