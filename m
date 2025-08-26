Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04182284B5B;
	Tue, 26 Aug 2025 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207538; cv=none; b=ttQUf8Jgvj+7KSkLlFEDuWjDy6+GmLC4Y9x75VLz8QfVE26R18R7xfvqt7v0BhYRAatgR6IBdXDSNIqAwOeXx53LnfzeqcEA/xICP9oZo3L7WwIte700rVeSGdDDyVhhrotLrhrheV2uG50xEiGFX+O/Xxfl/JzVQn0oR4Tllms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207538; c=relaxed/simple;
	bh=4uKiYWlPC38QxqEWgqGgFdtj50/4R5sYIDMvgBnShwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKz/tKUD5E9H67TUdiVwV/mf455qCew0K1tLbLV9g4Lp5yvHJk3NXe3vJNpC0KBP5B69XRuuQO/cSEqlGW8gK150EOcqqJ5KpWZlImhVABurlyKmd4054cOAfwzW3YFliimu9A8KBDNw+Iau58/hfabQNCQs/pIVqX84N2GZPKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zrkzw515; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrkzw515"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7E3C4CEF1;
	Tue, 26 Aug 2025 11:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207537;
	bh=4uKiYWlPC38QxqEWgqGgFdtj50/4R5sYIDMvgBnShwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zrkzw515fUDbXxs+CNpofnqQMN4UEZtDCBY4/d+aaANjlto9j0dGrWRH2gv5iwp1j
	 GJx+gGnuw67mTYdXLzqeUb5DHZz4CColiXbRuoH0LoYgT4lQTc3jvTFiAydBKvLVLO
	 B1vGvi3wzbL7RPqBDqwKjvT+NeIaviKKqKUapgvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 179/457] drm/amdgpu: track whether a queue is a kernel queue in amdgpu_mqd_prop
Date: Tue, 26 Aug 2025 13:07:43 +0200
Message-ID: <20250826110941.799883817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

commit 284d4dfe850e665f0e7d4dfaf4d3d3da76d11fb0 upstream.

Used to to set the MQD appropriately for each queue type.
Kernel queues have additional privileges.

Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.16.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h      |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -886,6 +886,7 @@ struct amdgpu_mqd_prop {
 	uint64_t csa_addr;
 	uint64_t fence_address;
 	bool tmz_queue;
+	bool kernel_queue;
 };
 
 struct amdgpu_mqd {
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -687,6 +687,7 @@ static void amdgpu_ring_to_mqd_prop(stru
 	prop->eop_gpu_addr = ring->eop_gpu_addr;
 	prop->use_doorbell = ring->use_doorbell;
 	prop->doorbell_index = ring->doorbell_index;
+	prop->kernel_queue = true;
 
 	/* map_queues packet doesn't need activate the queue,
 	 * so only kiq need set this field.


