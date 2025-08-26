Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2B14B950;
	Tue, 26 Aug 2025 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214958; cv=none; b=cwdYnh8zjlqQPM2tfOHNXIbXKAVZe/1tWNbPK7FKMWkkxgQBQH5ynLajUY2IDfzUfdklekJqESi1ZXWVcB69lUHNIIbuhpPGtobPkA7QacRc0NNepxMP3NPigGBUhUyPyzK5+546edEZi4vlg9yPEGLAiUWtb3uWZluAM+3lols=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214958; c=relaxed/simple;
	bh=Vbh90YnOPRnMimTgaxBh8n/sLSDBL4o3B43b3NhjlIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYIcJX9iv5YgYpOIxSBF0fQuqsT6T66Q7gFIgqZTh1TEbagZMnMoCQduetxYgWE9Jeg7qHLsU70G/iTbmZq5EUaFKDzCQ6YOTg+eTlQJ9lt/xnS9PNVtGn2jHaHn0RCI7siggV+CnlzbyEdYBaiLVSdIYxzXTONI0ew/YkK+bjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjPWFxui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjPWFxui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43651C4CEF1;
	Tue, 26 Aug 2025 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214956;
	bh=Vbh90YnOPRnMimTgaxBh8n/sLSDBL4o3B43b3NhjlIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjPWFxuijScdbPYiy8B8FYiO09bYvC1D7uU1G59cmDi0dwWjBYmcmbDPBSWV4ZgrW
	 svIG+r/EZczM+0intM/uKlcAuqpb8KF212ZcaFK8Q08UggxSQewVZCyTPflpwU8W1p
	 QBVSa3195lIiWrOUDnUd7aIW6sDNuG8TTI8BwN2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Gang Ba <Gang.Ba@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 334/482] drm/amdgpu: Avoid extra evict-restore process.
Date: Tue, 26 Aug 2025 13:09:47 +0200
Message-ID: <20250826110939.074443601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Ba <Gang.Ba@amd.com>

commit 1f02f2044bda1db1fd995bc35961ab075fa7b5a2 upstream.

If vm belongs to another process, this is fclose after fork,
wait may enable signaling KFD eviction fence and cause parent process queue evicted.

[677852.634569]  amdkfd_fence_enable_signaling+0x56/0x70 [amdgpu]
[677852.634814]  __dma_fence_enable_signaling+0x3e/0xe0
[677852.634820]  dma_fence_wait_timeout+0x3a/0x140
[677852.634825]  amddma_resv_wait_timeout+0x7f/0xf0 [amdkcl]
[677852.634831]  amdgpu_vm_wait_idle+0x2d/0x60 [amdgpu]
[677852.635026]  amdgpu_flush+0x34/0x50 [amdgpu]
[677852.635208]  filp_flush+0x38/0x90
[677852.635213]  filp_close+0x14/0x30
[677852.635216]  do_close_on_exec+0xdd/0x130
[677852.635221]  begin_new_exec+0x1da/0x490
[677852.635225]  load_elf_binary+0x307/0xea0
[677852.635231]  ? srso_alias_return_thunk+0x5/0xfbef5
[677852.635235]  ? ima_bprm_check+0xa2/0xd0
[677852.635240]  search_binary_handler+0xda/0x260
[677852.635245]  exec_binprm+0x58/0x1a0
[677852.635249]  bprm_execve.part.0+0x16f/0x210
[677852.635254]  bprm_execve+0x45/0x80
[677852.635257]  do_execveat_common.isra.0+0x190/0x200

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Gang Ba <Gang.Ba@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2024,13 +2024,11 @@ void amdgpu_vm_adjust_size(struct amdgpu
  */
 long amdgpu_vm_wait_idle(struct amdgpu_vm *vm, long timeout)
 {
-	timeout = dma_resv_wait_timeout(vm->root.bo->tbo.base.resv,
-					DMA_RESV_USAGE_BOOKKEEP,
-					true, timeout);
+	timeout = drm_sched_entity_flush(&vm->immediate, timeout);
 	if (timeout <= 0)
 		return timeout;
 
-	return dma_fence_wait_timeout(vm->last_unlocked, true, timeout);
+	return drm_sched_entity_flush(&vm->delayed, timeout);
 }
 
 /**


