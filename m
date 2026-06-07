Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341232E3AF1;
	Sun,  7 Jun 2026 10:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829709; cv=none; b=HFhT5yFS93XV0d0GjFa9NGNkTzbwjZoeAyPvqajHYXSAxRruO4vShM9QLTgmXXU1p+gJ1jEgaY+tTau7FVyrsmvoe7Zc28MSrY97rodJTEhL3s7YynpaVrnYvvmpt5q22B9B5/bDIkKpt2k6oG+CL117SFaVExYKTTMpLmmjdYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829709; c=relaxed/simple;
	bh=lwxlwr+eOAEkICxcC4tZopYZQowsAHbbX25m59Gvrz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lStZ9ASMqydr7mCx7NmGeqFD4a5i+M6h/SMA+qB6q5LvqCooDzTrR4HzXCeva8bcLpXMOKkWDwctzquFMGwshhhRD/877gUQnDDVlZ+SrSBod0FQiFMRG6Jytr8rqyRPkmr2B5zOSKtcCNi/tz8r7TcmAGhvfYnxW3GrIC+0OlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHMxK7Fb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHMxK7Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7278E1F00893;
	Sun,  7 Jun 2026 10:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829708;
	bh=apFYmhHj7pUe8ZqtMfIxQ4dWhI7dpgjJ8VE2VoL/rNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHMxK7Fb8A3u4PJZbG1ehMoGlrgujdR0gYjG7yS3On0OeUfvCdVBll4oiJgALjHnV
	 EwbYmoQgim6QSYP58Hwg0xDbFvdVMO8qSxMMp4Ko3ReptGIcD+nB7bp6b1kfQlXAJs
	 BknOYEv2MlW36y5yz3c7LzHke4Q4X+nJCjZZTyOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 272/315] drm/amdgpu: check num_entries in GEM_OP GET_MAPPING_INFO
Date: Sun,  7 Jun 2026 12:00:59 +0200
Message-ID: <20260607095737.558182782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

commit a1ba4594232c87c3b8defd6f89a2e40f8b08395d upstream.

kvcalloc(args->num_entries, sizeof(*vm_entries), GFP_KERNEL) at
amdgpu_gem.c:1050 uses the user-supplied num_entries directly without
any upper bounds check. Since num_entries is a __u32 and
sizeof(drm_amdgpu_gem_vm_entry) is 32 bytes, a large num_entries
produces an allocation exceeding INT_MAX, triggering
WARNING in __kvmalloc_node_noprof(), causing a kernel WARNING,
TAINT_WARN, and panic on CONFIG_PANIC_ON_WARN=y systems.

Add a size bounds check before we invoke the kvzalloc() to
reject oversized num_entries early with -EINVAL.

Fixes: 4d82724f7f2b ("drm/amdgpu: Add mapping info option for GEM_OP ioctl")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1fe7bf5457f6efd7be60b17e23163ba54341d73d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -1074,6 +1074,11 @@ int amdgpu_gem_op_ioctl(struct drm_devic
 		 * If that number is larger than the size of the array, the ioctl must
 		 * be retried.
 		 */
+		if (args->num_entries > INT_MAX / sizeof(*vm_entries)) {
+			r = -EINVAL;
+			goto out_exec;
+		}
+
 		vm_entries = kvcalloc(args->num_entries, sizeof(*vm_entries), GFP_KERNEL);
 		if (!vm_entries) {
 			r = -ENOMEM;


