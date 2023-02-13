Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE708F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667E6C433D2;
	Mon, 13 Feb 2023 14:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300186;
	bh=BNf9/D9CxBScHCos+tyKThzUhMMxBC+1cqiqiEKjn00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6BJue2UkxIFqfZsWus+gSMU1fyds93oqvYiCTkTvVSvcnK9I18bvdOD60qQQ030t
	 TwQ9NHXXbxCiAbiwgcyXSO0W4A+caCS1s8W+RvGOrg5PZQ+e6DHAKJ7uDsaem9o+Fz
	 vx0jd+3r0bniluPBwT4i0lD5PZHc2VoNZJucKLVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 097/114] drm/amdgpu: Use the TGID for trace_amdgpu_vm_update_ptes
Date: Mon, 13 Feb 2023 15:48:52 +0100
Message-Id: <20230213144747.198313609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Friedrich Vock <friedrich.vock@gmx.de>

commit e53448e0a1efa5133c7db78f1df1f4caf177676b upstream.

The pid field corresponds to the result of gettid() in userspace.
However, userspace cannot reliably attribute PTE events to processes
with just the thread id. This patch allows userspace to easily
attribute PTE update events to specific processes by comparing this
field with the result of getpid().

For attributing events to specific threads, the thread id is also
contained in the common fields of each trace event.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Friedrich Vock <friedrich.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -974,7 +974,7 @@ int amdgpu_vm_ptes_update(struct amdgpu_
 			trace_amdgpu_vm_update_ptes(params, frag_start, upd_end,
 						    min(nptes, 32u), dst, incr,
 						    upd_flags,
-						    vm->task_info.pid,
+						    vm->task_info.tgid,
 						    vm->immediate.fence_context);
 			amdgpu_vm_pte_update_flags(params, to_amdgpu_bo_vm(pt),
 						   cursor.level, pe_start, dst,


