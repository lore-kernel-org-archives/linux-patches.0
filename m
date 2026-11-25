Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623806;
	b=w2xQHuVZY1bUZh7PPLX0mZXLv3pwX1yP3acXnvwYWCL9AZz5T8huQnn+uc2ajwDyRlNa
	 G1EIoaMFgu7N7LzulEBoI8/sWS4dEEIU0ft2zeg7fPbh2a/+pbU9JNOTg6CQTzJqKYDmx
	 1ndB82TdbgzX5GIMhKAVom7CP0qMwJJUMrozYorfXbf2SFKdEle2KveFWPxP9H3DgPum3
	 2fy5GelPfWWsZiYrw6TBHc2mvWn/hgy14GZjMsmVsp198ZRG8Hde9CJkv9w0g0SzdWniH
	 a21cB1OUi8p+tHhk0C+TF9Cx1gMKiKmvsFpDtSiGOIRAEbmnOgJZbhdHzJmdRXkqYIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vnWvJEtenhmpGURhJTL4wwUZVl29dCET1TGL5V0kc/o=;
	b=PyRVO0p+YRZaer7sqhElHUQJSb3u8Guc3mBFKAWEzP+XSs4lnAWJ86LD17yxb8SwkJYO
	 P9OOxcOcaSyeFrrwGTXz//k7RNJFnE2jvwPSNrIEw8UeelFQduvKocLFctN2veAhK31js
	 eoHFa4G9MfdnWsYMSgNZykn56vSVDZUOdFLIREwlxvLD9r1UUB8JP/e7dKerrAUlw6aXn
	 SF2MMQRSm9scQ3CulqeianEqE3R+wa/3xgpCZnQ7RrvLuWuiyu66yS+jAXdRslD9iLL9H
	 +tRcGjsLwaklZbpRTJH/hkINkbO8ADA5E2MsWWFYVZs1dLkTEWtRWNzAla8dGAMHvGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2wEzJKz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B48E606A31E;
	Wed, 25 Nov 2026 16:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2wEzJKz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D141F000C0;
	Wed, 25 Nov 2026 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623805;
	bh=vnWvJEtenhmpGURhJTL4wwUZVl29dCET1TGL5V0kc/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2wEzJKz9lXcBRvhYPAqYLbQCULYCBJg2zzWfRqEkdzEBwADYdKCs49uRRnR3o/Fi
	 x3GpHKiB8MOVR8hFvYSAwAUX1osvgHI1/KN+q9ATxO0kBFSve/atMASX1rM1BKxwUL
	 RyQDC4jZ8gQ8bW+Xzvm4QXN8yk48wncPvxb6P7jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 931/990] drm/amdkfd: skip GPUs without a VM when checkpointing the BO mappings
Date: Wed, 25 Nov 2026 15:38:18 +0100
Message-ID: <20261125143843.803916078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 1a5ca15b558bf0e6621602c84e0a633d237dd052 upstream.

criu_checkpoint_bos() asks every device of the process whether a BO is
mapped there, passing its drm_priv, which is NULL for the devices the
process never acquired a VM on. On navi48 with its iGPU, checkpointing a
process which acquired the VM of the dGPU only:

  Oops: general protection fault, probably for non-canonical address 0xdffffc000000002f: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
  RIP: 0010:amdgpu_amdkfd_bo_mapped_to_dev+0x35/0x160 [amdgpu]
   kfd_ioctl_criu+0x30d1/0x4aa0 [amdgpu]
   kfd_ioctl+0x767/0xb10 [amdgpu]

Nothing can be mapped on such a device, skip it.

Fixes: f9e292cbba21 ("drm/amdkfd: kfd_bo_mapped_dev support partition")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 794381c358d344d8fcf8b9e6426aa2bac0a7d1f7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1996,7 +1996,9 @@ static int criu_checkpoint_bos(struct kf
 				bo_bucket->offset = amdgpu_bo_mmap_offset(dumper_bo);
 
 			for (i = 0; i < p->n_pdds; i++) {
-				if (amdgpu_amdkfd_bo_mapped_to_dev(p->pdds[i]->drm_priv, kgd_mem))
+				/* nothing is mapped on a GPU without a VM */
+				if (p->pdds[i]->drm_priv &&
+				    amdgpu_amdkfd_bo_mapped_to_dev(p->pdds[i]->drm_priv, kgd_mem))
 					bo_priv->mapped_gpuids[dev_idx++] = p->pdds[i]->user_gpu_id;
 			}
 


