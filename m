Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6975443E5E;
	Thu, 30 Jul 2026 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425178; cv=none; b=MJd4jJ4DGEnWBNAqz4WaHpkHEjs6QVt/8EczSfNwIP+2qpIeHLUqypho6zT2W+lqDQYECAZ8N4yDZ9PyNfgoCoTk1859/B+BAPAfEeL+y9+cyL+sd3oRlDahH2P3blv/H6rMzjQYhagvem0asyajsextxyZShCWJRSoi6KqdMeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425178; c=relaxed/simple;
	bh=tMU+YejCj8W37n1c1zqU7I6u68hl5WtAiqcv3zfduvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVcwI/wSBg4kRV/KDbE3R6CNmXrbAl/Srw5EmWpyIMKKkROs8kbPlh0lHymmfzzjkplpELvjo1mvoNUJ7M9H88Qzfs7UWTSS/BDQ9NbDn78l/FsFRnVvuOOO4rZxXZIVz1TZoO0MVSB+PxzihZUL7vnooRO4slIO0T8BNKYX6Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjGYHMj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjGYHMj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FB01F00AC4;
	Thu, 30 Jul 2026 15:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425177;
	bh=PP58VzWkOH+LEzly1qlMNWXcphy6biQPk56+ebBBa3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjGYHMj5sTwG8ij1sYg+siXlfkRu9XPvLYs2kp9rVGefTcXkSaG/lnu6G55eFe0CL
	 v2sBM6Cuqu5e/lHouJjSLX9KtbWU3saepbAaeESgpcwoQSjEHyg/XwX9HhsyHQR3Yt
	 +V+20nqAh44EmHdpacmmbKik+dt6SH0IMgd5oEcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 644/675] accel/amdxdna: reject command submission on devices without a submit op
Date: Thu, 30 Jul 2026 16:16:14 +0200
Message-ID: <20260730141458.822650814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit 38953513d7313992676d4136cd425cdb70c6278e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -406,6 +406,10 @@ int amdxdna_cmd_submit(struct amdxdna_cl
 	int ret, idx;
 
 	XDNA_DBG(xdna, "Command BO hdl %d, Arg BO count %d", cmd_bo_hdl, arg_bo_cnt);
+
+	if (!xdna->dev_info->ops->cmd_submit)
+		return -EOPNOTSUPP;
+
 	job = kzalloc(struct_size(job, bos, arg_bo_cnt), GFP_KERNEL);
 	if (!job)
 		return -ENOMEM;


