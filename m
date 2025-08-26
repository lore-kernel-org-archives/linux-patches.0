Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3582F29D26A;
	Tue, 26 Aug 2025 11:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207686; cv=none; b=R4Qe5+HIW8Y87J7Ui8iD4TQ2fXgiZLN5TTIfjHw5xP6TTcJ9RF95lR86miwqr6EVzHQqM9ID/xlCkRkBGZ7umqiUJzULVI8P2rxU45/PMlBsbm7g6E8Rc0K/nR/MSDzjqnep+KTEFLe5RT0UO+ENA7iH/hKI7wajJngqYu3ACEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207686; c=relaxed/simple;
	bh=n8yF8D5MwGhFZzNfx6UicoHQ0Vjvnzso2isWwExSjDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NacvOsHp17y45/x0D9c0dQx8ef9aRU9cLhpw9lLZvh+KBEnwHCt7K8mikoHlMPSoQfeJYDowAAhVmylrxf+gNcaYm2p3ExNYGFKzqAXsUPnPtojnEdllIJP4dLhlil18IkwzhU8SQR39GPAcFMOFrCl1OBg9wPsZNwoI4gCqR2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeSmMDA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeSmMDA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764FDC4CEF1;
	Tue, 26 Aug 2025 11:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207685;
	bh=n8yF8D5MwGhFZzNfx6UicoHQ0Vjvnzso2isWwExSjDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeSmMDA5SUxeAzkdukJbYrppyWF2aMdGKjGE5TrBd7Tr0WhfSlp+LFiew6o6a3xCN
	 UfnE7LVLCT9wJMiv+lvL/fyswE72fLTU31Mwg+vPfxx6kBRm7x9cH1C2qFNsi49wKI
	 hGxoT8DRM5b2JnkKr8k+uYFSVjSxjhRo9E7HRWbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu01 Tong <Tong.Liu01@amd.com>,
	"Lin.Cao" <lincao12@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 277/457] drm/amdgpu: fix task hang from failed job submission during process kill
Date: Tue, 26 Aug 2025 13:09:21 +0200
Message-ID: <20250826110944.227054493@linuxfoundation.org>
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

From: Liu01 Tong <Tong.Liu01@amd.com>

commit aa5fc4362fac9351557eb27c745579159a2e4520 upstream.

During process kill, drm_sched_entity_flush() will kill the vm
entities. The following job submissions of this process will fail, and
the resources of these jobs have not been released, nor have the fences
been signalled, causing tasks to hang and timeout.

Fix by check entity status in amdgpu_vm_ready() and avoid submit jobs to
stopped entity.

v2: add amdgpu_vm_ready() check before amdgpu_vm_clear_freed() in
function amdgpu_cs_vm_handling().

Fixes: 1f02f2044bda ("drm/amdgpu: Avoid extra evict-restore process.")
Signed-off-by: Liu01 Tong <Tong.Liu01@amd.com>
Signed-off-by: Lin.Cao <lincao12@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f101c13a8720c73e67f8f9d511fbbeda95bcedb1)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   15 +++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1138,6 +1138,9 @@ static int amdgpu_cs_vm_handling(struct
 		}
 	}
 
+	if (!amdgpu_vm_ready(vm))
+		return -EINVAL;
+
 	r = amdgpu_vm_clear_freed(adev, vm, NULL);
 	if (r)
 		return r;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -654,11 +654,10 @@ int amdgpu_vm_validate(struct amdgpu_dev
  * Check if all VM PDs/PTs are ready for updates
  *
  * Returns:
- * True if VM is not evicting.
+ * True if VM is not evicting and all VM entities are not stopped
  */
 bool amdgpu_vm_ready(struct amdgpu_vm *vm)
 {
-	bool empty;
 	bool ret;
 
 	amdgpu_vm_eviction_lock(vm);
@@ -666,10 +665,18 @@ bool amdgpu_vm_ready(struct amdgpu_vm *v
 	amdgpu_vm_eviction_unlock(vm);
 
 	spin_lock(&vm->status_lock);
-	empty = list_empty(&vm->evicted);
+	ret &= list_empty(&vm->evicted);
 	spin_unlock(&vm->status_lock);
 
-	return ret && empty;
+	spin_lock(&vm->immediate.lock);
+	ret &= !vm->immediate.stopped;
+	spin_unlock(&vm->immediate.lock);
+
+	spin_lock(&vm->delayed.lock);
+	ret &= !vm->delayed.stopped;
+	spin_unlock(&vm->delayed.lock);
+
+	return ret;
 }
 
 /**


