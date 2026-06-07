Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744792E3AF1;
	Sun,  7 Jun 2026 10:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829725; cv=none; b=LlleN16iVgOpVGuLZIu6nzHG5ufwhAd+uAF2YT257JQP4kX2TqsmKkljJit5zuU9aEoM+ByoIYdKEfXMSWbevpvf7McKWP7c17UCO1VY5ZWvN0EsqNMPSX/Oct36JiZy6k/jEwer7VrRLv5ryirHyhfLP5QkdCJL6oSvBAOYtx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829725; c=relaxed/simple;
	bh=jtppIwOdgPKmX1Vuvlqxu0Rew+KPhzjYB7+Oz/uJZqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoJqT9XVhXoC0rp9VNAEBIEjrmTRTtaB+YhhhPnf5PhLH9vGzAJyt9Rdt6RRWV42yFtk+2UvgzLE8GpzGf9ukGPRMt5SlEelcI2ds5x9pYsZocgLglAAFb9HzYR86NEC9/Ho2TRap8PLZntOLyCeBG3QTPZzJZWYS73dQjt6gFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E37IzCNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E37IzCNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B781C1F00893;
	Sun,  7 Jun 2026 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829724;
	bh=agP4AjSo7zQO7frjoard1DY5id7MyB8jKRbdLLapsQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E37IzCNIV13K+Iw3KkPD2L7k+wiptuLxBFxoJ4jtm0wb7nBaLhB5ij3Ei4Ouyeyqd
	 R92K6X6kNN1S8xrb/vkTYaIeBw/6hFkTSHSUTnDkROwd8q8u56eUWCu//H8bUTp7/0
	 iRBqZeTDDDzlM8Ow7uSb4S9ZaS8mushF4TG7umZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 308/332] drm/amdgpu: check num_entries in GEM_OP GET_MAPPING_INFO
Date: Sun,  7 Jun 2026 12:01:17 +0200
Message-ID: <20260607095739.396962920@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1095,6 +1095,11 @@ int amdgpu_gem_op_ioctl(struct drm_devic
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


