Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E41C3D45CB;
	Tue, 16 Jun 2026 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633357; cv=none; b=EnyC7wiK4JOO/dss7GvaEvpj/FKu4tKvAL4MHm/igfUsWO1rbsGSUKTAl3XxlTYvEIFWJvLrvJ7pcp2k1PInZ0oF/dMVR35c5zrghwzx/0941P9U3y9WoZnQQGas9pN9VHsm/g9GI/Ps7I7GAXeQecse2PHqTZAIgH4kQogNGOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633357; c=relaxed/simple;
	bh=u/Y+UWshIPioO3FDEQadYgHx1TP4jvyEz3UhmoTnloo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdhK5hnjB9edTtVbuQt/vota7lEuLsVNpYzeTU1fj0GIXXheobg4xaPU85tbwmNHYuO/LV7RCHXTXdIIpXx2Zvrln8kvAmBkb2IBSIkMZIjH5R5X6crJmHoUU2nrgP3Tqn26EO1ZFg1DExQssjHplFRrvqnKItZTLkgO2ueAr2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRSo9wOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRSo9wOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D261F000E9;
	Tue, 16 Jun 2026 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633356;
	bh=mIg5rv3utzZTgEF6IGEw6kRNyKwHkN1n2udM7ngKN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRSo9wOlPamL7bWcBbQsqkU7nuFUNMv4ObsUy3XSFy0/eMeJ1qQrj06yzU773k4Tv
	 52o1VTfptd5PerCr3Lger5VKtjXLcnXYL/HoSTKtlyDyeiQ3+XGI5ltCs2T5GdlnL3
	 Wm32/rX1kqKxGMIQKaSUvG5SeZpjsldafdjuOmhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linpu Yu <linpu5433@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Kees Cook <kees@kernel.org>,
	Stanislav Kinsbursky <skinsbursky@parallels.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 064/411] ipc: limit next_id allocation to the valid ID range
Date: Tue, 16 Jun 2026 20:25:02 +0530
Message-ID: <20260616145103.680161921@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linpu Yu <linpu5433@gmail.com>

commit fa0b9b2b7ae3539908d69c2b9ac0d144d9bc5139 upstream.

The checkpoint/restore sysctl path can request the next SysV IPC id
through ids->next_id.  ipc_idr_alloc() currently forwards that request to
idr_alloc() with an open-ended upper bound.

If the valid tail of the SysV IPC id space is full, the allocation can
spill beyond ipc_mni.  The returned SysV IPC id still uses the normal
index encoding, so later lookup and removal can target the wrong slot.
This leaves the real IDR entry behind and breaks the IDR state for the
object.

The bug is in ipc_idr_alloc() in the checkpoint/restore path.

1. ids->next_id is passed to:

       idr_alloc(&ids->ipcs_idr, new, ipcid_to_idx(next_id), 0, ...)

2. The zero upper bound makes the allocation effectively open-ended.
   Once the valid SysV IPC tail is occupied, idr_alloc() can spill past
   ipc_mni and allocate an entry beyond the valid IPC id range.

3. The new object id is still encoded with the narrower SysV IPC index
   width:

       new->id = (new->seq << ipcmni_seq_shift()) + idx

4. Later removal goes through ipc_rmid(), which uses:

       ipcid_to_idx(ipcp->id)

   That truncates the real IDR index. An object actually stored at a
   high index can then be removed as if it lived at a low in-range
   index.

5. For shared memory, shm_destroy() frees the current object anyway, but
   the real high IDR slot is left behind as a dangling pointer.

6. A subsequent walk of /proc/sysvipc/shm reaches the stale IDR entry
   and dereferences freed memory.

Prevent this by bounding the requested allocation to ipc_mni so the
checkpoint/restore path fails once the valid range is exhausted.

Link: https://lore.kernel.org/cover.1778336914.git.linpu5433@gmail.com
Link: https://lore.kernel.org/2eebe949bfa7d1f6e13b5be6a92c64c850ce9d45.1778336914.git.linpu5433@gmail.com
Fixes: 03f595668017 ("ipc: add sysctl to specify desired next object id")
Signed-off-by: Linpu Yu <linpu5433@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Cc: Kees Cook <kees@kernel.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/util.c
+++ b/ipc/util.c
@@ -253,7 +253,7 @@ static inline int ipc_idr_alloc(struct i
 	} else {
 		new->seq = ipcid_to_seqx(next_id);
 		idx = idr_alloc(&ids->ipcs_idr, new, ipcid_to_idx(next_id),
-				0, GFP_NOWAIT);
+				ipc_mni, GFP_NOWAIT);
 	}
 	if (idx >= 0)
 		new->id = (new->seq << ipcmni_seq_shift()) + idx;


