Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B1721B9C9;
	Mon, 23 Jun 2025 21:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715565; cv=none; b=hdMORlMGgNoIU3TCCky/RnZ6bqxV1wjpzWReMPYK/56OIeNmRneeg7lpBvpcpseAKyLch4Xm5juHqemVslPN9tnCAudq5UE2KegeUFLWpcX6Cj9NBCQvoqpMWqsS2it3+CTl4xHOXSaC65pAvqZP0NDCruMrkqnP7XIdQN3VIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715565; c=relaxed/simple;
	bh=TgaUlxowQjGIDYV1C30oL3wiW2pgG1nZLKHZsm5ECmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGVq7Z7Nbctd+oliTGGSGiHOICHjN5N70sCdV7EhnVtOvyPDxT9NqmNJM7Rc3C1itydVFf1BTJ4pk9oPTU0DU1NYlyyL920erCRjW1EYIJHTvf3idqzGPbk+Yqzvf0b5oJt8XlUwbct9X5lJ4ScsYuDhTADzTJwAQq4Zq5SUc4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pY9E26Dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pY9E26Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2831C4CEEA;
	Mon, 23 Jun 2025 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715565;
	bh=TgaUlxowQjGIDYV1C30oL3wiW2pgG1nZLKHZsm5ECmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pY9E26DmfiEDJ1+lxr1S76o6mOLcQcIJF8wVTLWd0/3LUwzG9xQa+/ZbNEAPraYRZ
	 PVjE0KBwTVPg+JpouCfoWNMs/P4mUdU8rM/W/BcxJIqdfRsH3Q3mqomEgDm3BjBeRz
	 4XipWM3oDRdKcHBG5I1o9YbnK6Y3s6N41T1T9YpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>
Subject: [PATCH 6.15 487/592] drm/nouveau/nvkm: introduce new GSP reply policy NVKM_GSP_RPC_REPLY_POLL
Date: Mon, 23 Jun 2025 15:07:25 +0200
Message-ID: <20250623130712.018962834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Wang <zhiw@nvidia.com>

commit a738fa9105ac2897701ba4067c33e85faa27d1e2 upstream.

Some GSP RPC commands need a new reply policy: "caller don't care about
the message content but want to make sure a reply is received". To
support this case, a new reply policy is introduced.

NV_VGPU_MSG_FUNCTION_ALLOC_MEMORY is a large GSP RPC command. The actual
required policy is NVKM_GSP_RPC_REPLY_POLL. This can be observed from the
dump of the GSP message queue. After the large GSP RPC command is issued,
GSP will write only an empty RPC header in the queue as the reply.

Without this change, the policy "receiving the entire message" is used
for NV_VGPU_MSG_FUNCTION_ALLOC_MEMORY. This causes the timeout of receiving
the returned GSP message in the suspend/resume path.

Introduce the new reply policy NVKM_GSP_RPC_REPLY_POLL, which waits for
the returned GSP message but discards it for the caller. Use the new policy
NVKM_GSP_RPC_REPLY_POLL on the GSP RPC command
NV_VGPU_MSG_FUNCTION_ALLOC_MEMORY.

Fixes: 50f290053d79 ("drm/nouveau: support handling the return of large GSP message")
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Tested-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250227013554.8269-3-zhiw@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h  |    4 ++++
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |    3 +++
 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/r535.c |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
@@ -44,10 +44,14 @@ typedef void (*nvkm_gsp_event_func)(stru
  * NVKM_GSP_RPC_REPLY_RECV - If specified, wait and receive the entire GSP
  * RPC message after the GSP RPC command is issued.
  *
+ * NVKM_GSP_RPC_REPLY_POLL - If specified, wait for the specific reply and
+ * discard the reply before returning to the caller.
+ *
  */
 enum nvkm_gsp_rpc_reply_policy {
 	NVKM_GSP_RPC_REPLY_NOWAIT = 0,
 	NVKM_GSP_RPC_REPLY_RECV,
+	NVKM_GSP_RPC_REPLY_POLL,
 };
 
 struct nvkm_gsp {
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -602,6 +602,9 @@ r535_gsp_rpc_handle_reply(struct nvkm_gs
 		else
 			repv = reply;
 		break;
+	case NVKM_GSP_RPC_REPLY_POLL:
+		repv = r535_gsp_msg_recv(gsp, fn, 0);
+		break;
 	}
 
 	return repv;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/r535.c
@@ -105,7 +105,7 @@ fbsr_memlist(struct nvkm_gsp_device *dev
 			rpc->pteDesc.pte_pde[i].pte = (phys >> 12) + i;
 	}
 
-	ret = nvkm_gsp_rpc_wr(gsp, rpc, NVKM_GSP_RPC_REPLY_RECV);
+	ret = nvkm_gsp_rpc_wr(gsp, rpc, NVKM_GSP_RPC_REPLY_POLL);
 	if (ret)
 		return ret;
 


