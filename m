Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2378330E859;
	Tue,  2 Sep 2025 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819804; cv=none; b=PbzYlSA9DTHKU4XYPevni+iuBztg0i2aQy24ToW48E+C92izWOOocPAKUKWxLzyl6u10x9c82jx480zOdLdGsDnTdftPYDa21yJKuz0t4RQEar5MccC/2pNtrNCZmH/K7iKkLS5TLzvOi1B/mwuX7sZpf0Bt2XbfzkYJgZKiUjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819804; c=relaxed/simple;
	bh=/vVoEXvp35kRkqmqveE9qkZj5GgxDTFwnEaCRMzF9pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D1M84zaI8p6TJX+5O+cSh8SzRlrL2o/0ituZduFBMBVtvSeN6ycntAb5ZYfq57HFyC660d9SV4IegCSTcPejo8jAffOsrCT22j55twA9U8c5MKSWr4Ed+EUX/jBjYs2dupGG0MmQjQt+4/NLXAqvcKj0Q/3ZtrGG/KOK08SXbWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uizzqnrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uizzqnrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C8DC4CEED;
	Tue,  2 Sep 2025 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819804;
	bh=/vVoEXvp35kRkqmqveE9qkZj5GgxDTFwnEaCRMzF9pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uizzqnrxNR6bAYH3uQfHg+uUDGU7K1+f8017BHCxW/lRqC1G2hftL6Y/6pRp2KzXh
	 5VfGOtsmwsDOXIg+pPzYQirB/etPgzkzAWlgX0vq4Wp3DpJfmBcQUVAEb8QT7NSjdJ
	 /CzyR3B+QZqfLpKMNaGGW7pYNi7NUA9EcxrGGjj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 133/142] drm/amdgpu/gfx12: set MQD as appriopriate for queue types
Date: Tue,  2 Sep 2025 15:20:35 +0200
Message-ID: <20250902131953.378142573@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 29f155c5e82fe35ff85b1f13612cb8c2dbe1dca3 upstream.

Set the MQD as appropriate for the kernel vs user queues.

Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7b9110f2897957efd9715b52fc01986509729db3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -3022,6 +3022,8 @@ static int gfx_v12_0_gfx_mqd_init(struct
 #endif
 	if (prop->tmz_queue)
 		tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, TMZ_MATCH, 1);
+	if (!prop->kernel_queue)
+		tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_NON_PRIV, 1);
 	mqd->cp_gfx_hqd_cntl = tmp;
 
 	/* set up cp_doorbell_control */
@@ -3171,8 +3173,10 @@ static int gfx_v12_0_compute_mqd_init(st
 			    (order_base_2(AMDGPU_GPU_PAGE_SIZE / 4) - 1));
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, UNORD_DISPATCH, 1);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH, 0);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
+	if (prop->kernel_queue) {
+		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
+		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
+	}
 	if (prop->tmz_queue)
 		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TMZ, 1);
 	mqd->cp_hqd_pq_control = tmp;


