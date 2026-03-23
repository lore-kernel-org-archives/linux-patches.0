Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393B63BD63C;
	Mon, 23 Mar 2026 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282666; cv=none; b=OnVbW5ImdxE68IeN4h6RMSZqyt7aMyiMwAqW1+nDEb79VPHwzRYxKfz4PzvHDbDOx/VBE8M39v8JsJH9FTjPdkQ70jkpsezoYkpjBmCSa/MaAtiLnV4lS/OXs+0CerGJ39Zxo26DRFRD/L5NjXUBVDb+Os8EjiSVunkfkPuuKMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282666; c=relaxed/simple;
	bh=Fh2+xz6rZ6CaPrxC6sYCXvurRRFMZSYpT5hL2OORbMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp0ourfG1GEnatLdQgmSm4TeRSEubkUMqzf4AECuTeFk0JAgBSK7weZJEaoPfw14YegHStTinAMhBZTWa+8t6mVLdEGk75cd0XIC4mpqBJgGFDWGh4LyDa2wdzcGXHDQBUwo9z4fh56kQETo6Om0xnU8Oipx+7W+7d49e9Dh6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIHOHkHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIHOHkHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C801C2BCB0;
	Mon, 23 Mar 2026 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282665;
	bh=Fh2+xz6rZ6CaPrxC6sYCXvurRRFMZSYpT5hL2OORbMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIHOHkHGbbSIO8uMYmwiTNYO1h0C1MRgHnvmYfrSlb7HX9+/O0hBMTDhSDKuaxYMp
	 DMdcwNscZydBidm0QuxC7RTUm+p0Zm+5EnhOFpnzBdWghLIAaWFAwgyU4X7FCmZ8TN
	 ivpZUBhb6V/7y2EgYzpzFp7tG3PE3bRBijvLn/T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 242/481] nouveau/dpcd: return EBUSY for aux xfer if the device is asleep
Date: Mon, 23 Mar 2026 14:43:44 +0100
Message-ID: <20260323134531.041681537@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 8f3c6f08ababad2e3bdd239728cf66a9949446b4 upstream.

If we have runtime suspended, and userspace wants to use /dev/drm_dp_*
then just tell it the device is busy instead of crashing in the GSP
code.

WARNING: CPU: 2 PID: 565741 at drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c:164 r535_gsp_msgq_wait+0x9a/0xb0 [nouveau]
CPU: 2 UID: 0 PID: 565741 Comm: fwupd Not tainted 6.18.10-200.fc43.x86_64 #1 PREEMPT(lazy)
Hardware name: LENOVO 20QTS0PQ00/20QTS0PQ00, BIOS N2OET65W (1.52 ) 08/05/2024
RIP: 0010:r535_gsp_msgq_wait+0x9a/0xb0 [nouveau]

This is a simple fix to get backported. We should probably engineer a
proper power domain solution to wake up devices and keep them awake
while fw updates are happening.

Cc: stable@vger.kernel.org
Fixes: 8894f4919bc4 ("drm/nouveau: register a drm_dp_aux channel for each dp connector")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260224031750.791621-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1210,6 +1210,9 @@ nouveau_connector_aux_xfer(struct drm_dp
 	u8 size = msg->size;
 	int ret;
 
+	if (pm_runtime_suspended(nv_connector->base.dev->dev))
+		return -EBUSY;
+
 	nv_encoder = find_encoder(&nv_connector->base, DCB_OUTPUT_DP);
 	if (!nv_encoder || !(aux = nv_encoder->aux))
 		return -ENODEV;


