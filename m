Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3885743E9DF;
	Thu, 30 Jul 2026 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422613; cv=none; b=jpKiLe0spSt3Z8x6M1qt+1vrImU9qXR+MNv8PVzkAWe1zyycndSgEafM170cDoPXDgcb1+g3IVQC3Ht4F/GRU/mCNqPSVOGQoL5cigSr0TdU7hM5kYDHFRPLy3cccCM/FORYWiDwQQtyH9tznIf6BboK332bdd003K+WAXvprsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422613; c=relaxed/simple;
	bh=dwdonFKanIZbxlMpWk+ysfzvGf19mHIyZkBVJbGucVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSYrsOU1HqNF6vjqYOTukqtfhAYYk87OLI6IU1pveUn6m2oXwGKGKSxCQolSJ5Z4HcKCdxNODB6i5JPzQ8G8nq91W4gLxUSUEPhaH6iMfiQPBR0htt+puE6lSUDHT4lPAakjrWX26n8Ri9tvgPPGQ7trWisnUb6TxRrKi8mHS2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JegGLzYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JegGLzYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9446F1F000E9;
	Thu, 30 Jul 2026 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422612;
	bh=1uZunHoPv2NaM/dJ0Y1euldpASvwd0kajcz5RIJ66Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JegGLzYSb0hbM5sdUKxLif5fltxv+SN68A7GT5/V1Qej/PjlR3q7gC9EhGH25jtPC
	 bsd9436ihPHVwZ9dkhjoCT6hvrJcJpsZvJ88jI+UYtmxXlcpJ5VH216R2WqWHkE6I6
	 ZAdDYlqtH/3T+6fiYBxJhsCZmgCntoWD9FIPpWIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 461/744] drm/amdgpu: Print vmid, pasid and more task info in devcoredump
Date: Thu, 30 Jul 2026 16:12:14 +0200
Message-ID: <20260730141454.095889182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit ea9d70db278957e1e81e4aea58b4b131ba262cfb upstream.

These are in the dmesg logs but are missing from devcoredumps.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fed7aa36d79802c3e02acd05aeae8b0a877e47c2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c |    7 ++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.h |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
@@ -240,10 +240,14 @@ amdgpu_devcoredump_format(char *buffer,
 	drm_printf(&p, "kernel: " UTS_RELEASE "\n");
 	drm_printf(&p, "module: " KBUILD_MODNAME "\n");
 	drm_printf(&p, "time: %ptSp\n", &coredump->reset_time);
+	drm_printf(&p, "pasid: %u\n", coredump->pasid);
+	drm_printf(&p, "vmid: %u\n", coredump->vmid);
 
 	if (coredump->reset_task_info.task.pid)
-		drm_printf(&p, "process_name: %s PID: %d\n",
+		drm_printf(&p, "process_name: %s TGID: %d thread: %s PID: %d\n",
 			   coredump->reset_task_info.process_name,
+			   coredump->reset_task_info.tgid,
+			   coredump->reset_task_info.task.comm,
 			   coredump->reset_task_info.task.pid);
 
 	/* SOC Information */
@@ -525,6 +529,7 @@ void amdgpu_coredump(struct amdgpu_devic
 			amdgpu_vm_put_task_info(ti);
 		}
 		coredump->pasid = job->pasid;
+		coredump->vmid = job->vmid;
 		coredump->num_ibs = job->num_ibs;
 		for (i = 0; i < job->num_ibs; ++i) {
 			coredump->ibs[i].gpu_addr = job->ibs[i].gpu_addr;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.h
@@ -63,6 +63,7 @@ struct amdgpu_coredump_info {
 	char				*formatted;
 
 	unsigned int			pasid;
+	unsigned int			vmid;
 	int				num_ibs;
 	struct amdgpu_coredump_ib_info	ibs[] __counted_by(num_ibs);
 };


