Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626206;
	b=jtYr0Pjs2RZ+25fxUWa8UfI6jFs0mTRzxMYrbZeY4AO6X56Huz3kpPRehNriYue8w3sj
	 1Js7JgLluxurmId8GrMlI4oJhdsN1C8BJWMOim6MJctZuOlxjd/lcBMpT36Xfp8m3BCLy
	 Yhq7RtJ8ikOaJXArIt3J3FV94GAFS50oarJ+fNRf4Hi0YfKvCxRtMsPWusQl183rXzvKZ
	 5Lc4d4Zzzpdb0WnLYwUEGyxVAgcYfNvoLo9sDEg5RHs6KyNz23huojWTQloLd84CbJbb+
	 yYuL+b9gQ2sHq+h0/WVEOiZiK3xcvpMwnmYZ+4kJhMIPWtG3RtNp+gkgf9SdIpdT9DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWBH4CNLryW5PuT6osJ8fb7YI7Rcg+4Qk0a/ayh/0uU=;
	b=PWHy7pwbtd7DpnedTf1Knj1a95pzUDjAcqhGQEIs3mDL3O3Gg+14bFk3zbCI5PYgsIr8
	 ZVTT/SyKbJzKy1ix+Fp18jrImM2Mg+riEXw6tysSdhQv+H94azqP5V/FeUkU0egFqNcOh
	 oR5z9mbx4eCgBqL+Wa+Krp/mXOG5AY83nNKDOAfBVq4fi3qGrwFkwmJF+a297/ywbQsxn
	 5x+Dhst+bDNvu/7+vZ32aPF39ma4dEU3FF3t8tUIBXjXEXsEFDiTDyJ1gyEAMUoPcNj6U
	 gVAtf3DZafZGZhdrU5ObBC6HpHQyUwVj5WiB5mM/J/NOK19L61i3+xfCEv6TrAZRdog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggMoMtYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AE6606A321;
	Wed, 25 Nov 2026 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggMoMtYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6471F000C4;
	Wed, 25 Nov 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626206;
	bh=cWBH4CNLryW5PuT6osJ8fb7YI7Rcg+4Qk0a/ayh/0uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggMoMtYL1+rfqVoFJmrh4McUyS35WLHscMyDWBxs9J/NqKQgMYqR7XOIPDNuficVC
	 bmRDwPM3gNt4bRE7bdqzWyWY7qtcwOQAh9u2lGqz+CQKTqHCqPN4qmGF0sQ149olcJ
	 o/VUo54fY8lxBgUKhhugswMx0ItkUa27kGyMul6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 768/816] drm/amdkfd: skip GPUs without a VM when checkpointing the BO mappings
Date: Wed, 25 Nov 2026 15:38:36 +0100
Message-ID: <20261125143906.949421996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1993,7 +1993,9 @@ static int criu_checkpoint_bos(struct kf
 				bo_bucket->offset = amdgpu_bo_mmap_offset(dumper_bo);
 
 			for (i = 0; i < p->n_pdds; i++) {
-				if (amdgpu_amdkfd_bo_mapped_to_dev(p->pdds[i]->drm_priv, kgd_mem))
+				/* nothing is mapped on a GPU without a VM */
+				if (p->pdds[i]->drm_priv &&
+				    amdgpu_amdkfd_bo_mapped_to_dev(p->pdds[i]->drm_priv, kgd_mem))
 					bo_priv->mapped_gpuids[dev_idx++] = p->pdds[i]->user_gpu_id;
 			}
 


