Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6B403EB9;
	Tue, 21 Jul 2026 17:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654864; cv=none; b=h9WINuPxgJLUR1re/2YuMBbjGDgdITx/lQAeZB/jQvtBRtr0M9tP1ClXIbTxZo1aP7qjFFKaOSoMuzRdash+MvjfG0idir9n+LaL/M5XShxFF8tNVjiwkLOvQjdHROzj6S7gYhXeMipy/PXqwDIkzN7J5lgH2H8G2Lf6ANzl/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654864; c=relaxed/simple;
	bh=KFe06KaKoBORphuIsXaJoB6Jkbg2p7fLeqw5Jn3NRMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux0sUde+0ZUQf07JvkHjEnp85WXuumS1xQVyRM0unwR5gENGbdqlbAHbW52bPwu6Wl5bRQSW+ejq6yfU6DoogF9qxftNqfbCZpvWtadOkN5QRz34l8YqKpUp++Gh5kYeCVPxV+vZoObEUfKkz14tG3FPIy09C0v4J8tFGh5jwqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1bov1ri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1bov1ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363D71F000E9;
	Tue, 21 Jul 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654862;
	bh=k/RErYrdxDc6FnLsa5ZFAXyS8gM5aoZ1vQsec0JzDzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1bov1riCwsdZb1qhGotGwCyYB8cu1+LaQvoyCx89kFF9WCb+EwFvq4yi1nqcMXud
	 JV4gGEGsWWB63gdofTiaE0JQ2uRa3+v4jTM5/GLkTJC7Lr/mQ5CQVPigTCeSgDTWE2
	 GrTXlOZoRiSgaZQpeTFwitRJURY607dwK8dBD9mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.1 1866/2077] accel/amdxdna: reject command submission on devices without a submit op
Date: Tue, 21 Jul 2026 17:25:39 +0200
Message-ID: <20260721152636.744858128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 38953513d7313992676d4136cd425cdb70c6278e upstream.

amdxdna_cmd_submit() calls xdna->dev_info->ops->cmd_submit()
unconditionally, but only aie2_dev_ops defines that callback.
aie4_vf_ops (the AIE4 SR-IOV virtual function) does not, so a user
AMDXDNA_EXEC_CMD ioctl on an AIE4 device reaches a NULL function-pointer
call and oopses the kernel. AIE4 submits work through a mapped user queue
and doorbell, not this ioctl path.

Reject the submission early with -EOPNOTSUPP when the device provides no
cmd_submit op, so the shared EXEC ioctl is a clean no-op on such devices.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Cc: stable@vger.kernel.org
Found by 0sec automated security-research tooling (https://0sec.ai).
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260713173030.87541-3-doruk@0sec.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -496,6 +496,10 @@ int amdxdna_cmd_submit(struct amdxdna_cl
 	int ret, idx;
 
 	XDNA_DBG(xdna, "Command BO hdl %d, Arg BO count %d", cmd_bo_hdl, arg_bo_cnt);
+
+	if (!xdna->dev_info->ops->cmd_submit)
+		return -EOPNOTSUPP;
+
 	job = kzalloc_flex(*job, bos, arg_bo_cnt);
 	if (!job)
 		return -ENOMEM;


