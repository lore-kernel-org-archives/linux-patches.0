Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51853793AC;
	Mon,  9 Feb 2026 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647192; cv=none; b=JiYUux23sPjWaujE9nRRl3qpYILlctAPh8FjN0UOgCl0SSuAJwhpnA84FEsn3KwnZiSUzhfeII1u9nH3pNwHWc2fFbLANOWvkBQ90aJ9EMP6RNlWcEgZvTSmm1oM8P29gkrlWYCv6QtYKOlNGuXjh2QDkgGjx05NzszBLeiq1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647192; c=relaxed/simple;
	bh=n5kdZVP2NGOOHWbVUWWDkAYB+nkJwCm505/7C+LUAcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/cYCwuws9zSP5e98LfshbiwZuVy+YRRhSJqp6AB8CpFrU1OpSYOphfzWcHtaUgv6RNtwEf/nSaGbgMb/izgDpUxdCbNWi8kNVw/QZtWeK5sk+b23CJ9i4Kh/fahrFW0pP49oDIYamJXaAGPMYBeNccTcClbjVhXpnoOjOCtf1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYFYDCDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYFYDCDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9DBC116C6;
	Mon,  9 Feb 2026 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647191;
	bh=n5kdZVP2NGOOHWbVUWWDkAYB+nkJwCm505/7C+LUAcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYFYDCDgJ9l5wXcjQ6mKUfibbzKJU8Mz+gHEI8eikn7lfwoZQAAV2OtePVlag651f
	 EwE8uTl1iaKPa5zeR7yKG/SWPfLxAzJq/oQT4lILHEkcrTp4ClYJDuLKLkPrPeCVRj
	 wiisffCRm3l1W0sa+d/YqPNbPU7FQG9BDkjbIRNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 027/175] nouveau/gsp: use rpc sequence numbers properly.
Date: Mon,  9 Feb 2026 15:21:40 +0100
Message-ID: <20260209142321.456136359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit 90caca3b7264cc3e92e347b2004fff4e386fc26e upstream.

There are two layers of sequence numbers, one at the msg level
and one at the rpc level.

570 firmware started asserting on the sequence numbers being
in the right order, and we would see nocat records with asserts
in them.

Add the rpc level sequence number support.

Fixes: 53dac0623853 ("drm/nouveau/gsp: add support for 570.144")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260203052431.2219998-2-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h     |    6 ++++++
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c |    4 ++--
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c |    6 ++++++
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c |    2 +-
 4 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
@@ -44,6 +44,9 @@ typedef void (*nvkm_gsp_event_func)(stru
  * NVKM_GSP_RPC_REPLY_NOWAIT - If specified, immediately return to the
  * caller after the GSP RPC command is issued.
  *
+ * NVKM_GSP_RPC_REPLY_NOSEQ - If specified, exactly like NOWAIT
+ * but don't emit RPC sequence number.
+ *
  * NVKM_GSP_RPC_REPLY_RECV - If specified, wait and receive the entire GSP
  * RPC message after the GSP RPC command is issued.
  *
@@ -53,6 +56,7 @@ typedef void (*nvkm_gsp_event_func)(stru
  */
 enum nvkm_gsp_rpc_reply_policy {
 	NVKM_GSP_RPC_REPLY_NOWAIT = 0,
+	NVKM_GSP_RPC_REPLY_NOSEQ,
 	NVKM_GSP_RPC_REPLY_RECV,
 	NVKM_GSP_RPC_REPLY_POLL,
 };
@@ -242,6 +246,8 @@ struct nvkm_gsp {
 	/* The size of the registry RPC */
 	size_t registry_rpc_size;
 
+	u32 rpc_seq;
+
 #ifdef CONFIG_DEBUG_FS
 	/*
 	 * Logging buffers in debugfs. The wrapper objects need to remain
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -704,7 +704,7 @@ r535_gsp_rpc_set_registry(struct nvkm_gs
 
 	build_registry(gsp, rpc);
 
-	return nvkm_gsp_rpc_wr(gsp, rpc, NVKM_GSP_RPC_REPLY_NOWAIT);
+	return nvkm_gsp_rpc_wr(gsp, rpc, NVKM_GSP_RPC_REPLY_NOSEQ);
 
 fail:
 	clean_registry(gsp);
@@ -921,7 +921,7 @@ r535_gsp_set_system_info(struct nvkm_gsp
 	info->pciConfigMirrorSize = device->pci->func->cfg.size;
 	r535_gsp_acpi_info(gsp, &info->acpiMethodData);
 
-	return nvkm_gsp_rpc_wr(gsp, info, NVKM_GSP_RPC_REPLY_NOWAIT);
+	return nvkm_gsp_rpc_wr(gsp, info, NVKM_GSP_RPC_REPLY_NOSEQ);
 }
 
 static int
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
@@ -557,6 +557,7 @@ r535_gsp_rpc_handle_reply(struct nvkm_gs
 
 	switch (policy) {
 	case NVKM_GSP_RPC_REPLY_NOWAIT:
+	case NVKM_GSP_RPC_REPLY_NOSEQ:
 		break;
 	case NVKM_GSP_RPC_REPLY_RECV:
 		reply = r535_gsp_msg_recv(gsp, fn, gsp_rpc_len);
@@ -588,6 +589,11 @@ r535_gsp_rpc_send(struct nvkm_gsp *gsp,
 			       rpc->data, rpc->length - sizeof(*rpc), true);
 	}
 
+	if (policy == NVKM_GSP_RPC_REPLY_NOSEQ)
+		rpc->sequence = 0;
+	else
+		rpc->sequence = gsp->rpc_seq++;
+
 	ret = r535_gsp_cmdq_push(gsp, rpc);
 	if (ret)
 		return ERR_PTR(ret);
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c
@@ -176,7 +176,7 @@ r570_gsp_set_system_info(struct nvkm_gsp
 	info->bIsPrimary = video_is_primary_device(device->dev);
 	info->bPreserveVideoMemoryAllocations = false;
 
-	return nvkm_gsp_rpc_wr(gsp, info, NVKM_GSP_RPC_REPLY_NOWAIT);
+	return nvkm_gsp_rpc_wr(gsp, info, NVKM_GSP_RPC_REPLY_NOSEQ);
 }
 
 static void


