Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C95141F34C;
	Mon, 17 Aug 2026 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977965; cv=none; b=f6KRWv+f+s1vB0Lq2ByEZ2EF3s160kpLUwm+hBLsMEcny8EL8GOwdLh6pEE8vQRHopvMpJQ+XJv2NOu9oJfRFoX7rD7LXg06OefM3aKubJgnIi1QXCO5e7qhE+rmxDKlb3yCMzxlXgk/YSfK3yoK8OQYRdo3Ayn0M6xnGZ8OLjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977965; c=relaxed/simple;
	bh=CApg4BGPhFuYNDQA9B6L+0/Onz+JFjeFrA8tNSvfZAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgeErbnT/vx7KGO+C+ZB+mVYLvG6Gddd6sZrO+LYKKHLa18fTJpWB3zAj4Bp6pJQv6ebeaouu6K7sZqwyQ4GZ4zHlHDzK2loW+opSwAgrhZqugEy88aJNEPVzD8AqzLRZSUcBcSxg+n/n8qM0Ux7RIDrWrkzBcdG/5ykEkjb6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQLJawa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQLJawa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39291F000E9;
	Mon, 17 Aug 2026 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977964;
	bh=C4b8DP3Y9KKnpqH6ldC0suRsoLdYoqTd6gqs2f+eu+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQLJawa4xHfaQ9QWe+cKPIPGbMndPu5cAN7bscVx4VPjg77q6sOLjlq2eKVPIPL34
	 nzvTX7PGhqDbNEK7LFfW8ME7J4elSnVR+7Wp7pAixOA81oET9FwumsNUm3x6qvmovB
	 /9mMxM8PozsxtMsDxtu3KJngJF0JCVMmHFw9xirI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/181] vdpa/mlx5: Fix buffer length in create_direct_keys()
Date: Mon, 17 Aug 2026 15:32:11 +0200
Message-ID: <20260817132536.836748416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit 727e1f569855df83579edbd73dcb4a0723543a12 ]

We have seen in our CI the following KASAN message:
BUG: KASAN: slab-out-of-bounds in cmd_exec+0x550/0xca0 [mlx5_core]
Read of size 272 at addr 0000000176795020 by task qemu-system-s39/82764
[...]
[<000011388ab3a7a0>] cmd_exec+0x550/0xca0 [mlx5_core]
[<000011388ab3b61c>] mlx5_cmd_exec_cb+0x25c/0x4f0 [mlx5_core]
[<000011388b21e82e>] mlx5_vdpa_exec_async_cmds+0x22e/0x5e0 [mlx5_vdpa]
[<000011388b21fd44>] create_direct_keys+0x954/0xef0 [mlx5_vdpa]
[...]
The buggy address is located 4128 bytes inside of
allocated 4384-byte region [0000000176794000, 0000000176795120)

So in essence we read 16 bytes beyond 4384-byte allocation.
create_direct_keys calculates the pointer and length for in and out
buffers.
The size calculation for in includes the entire structure
size (out + in + mtt[]) but the pointer passed to cmd_exec points only
to the 'in' field, skipping the 'out' field.

This causes mlx5_copy_to_msg() to read beyond the allocated buffer
by sizeof(out) bytes when copying command data.

Properly calculate the input size to match the pointer and allocation size.

Fixes: 0071b138d44a ("vdpa/mlx5: Create direct MKEYs in parallel")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260706141537.3510294-1-borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index c7a20278bc3ca..27abbe69b55cd 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -234,7 +234,8 @@ static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *
 		cmds[i].out = cmd_mem->out;
 		cmds[i].outlen = sizeof(cmd_mem->out);
 		cmds[i].in = cmd_mem->in;
-		cmds[i].inlen = struct_size(cmd_mem, mtt, mttcount);
+		cmds[i].inlen = struct_size(cmd_mem, mtt, mttcount) -
+				offsetof(struct mlx5_create_mkey_mem, in);
 
 		fill_create_direct_mr(mvdev, dmr, cmd_mem);
 
-- 
2.53.0



