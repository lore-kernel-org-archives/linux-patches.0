Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF064315A;
	Mon, 23 Jun 2025 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714868; cv=none; b=eyLJbiLhv65/j985g/3dKSsentJTOyOQJkiNTPEk9Tqu34e55ySsylWgzvqJF0Vfp0l/6G9LvDql6npe6JJBalmYh09VEocak6uF7Z/omtynttfNlWfLrdfxOKd6DfNF/LXeO4Ff4pimHiYj64TDLRFe9JWAA0kBayn13HObObw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714868; c=relaxed/simple;
	bh=O74hH2FcnJZLfSYzHTBntOb3z9hrAEaptWY4b/yA1Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxO0t3UQ+q31g8ONPtnZQth/5vvmwluVSOfiTWFUKIShHFmNCayTlMtitw5rSmKZ+InSUco6SyHyk5KZR0df4mJMG7WdGJAhxX6AJcc1djaUXJrG24QfjRIPQaR3xATWMugpVdnvDIQkkh74ni68UVpLbXdvJUtHp7WpeUVkLF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgSd7nfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgSd7nfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEF2C4CEEA;
	Mon, 23 Jun 2025 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714867;
	bh=O74hH2FcnJZLfSYzHTBntOb3z9hrAEaptWY4b/yA1Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgSd7nfTYsBYamxCZHT/U1MUoWijwBi64aUwxrw9k5dfp3EQpMfEc547nvQ5d1PZH
	 RBnhzx9HyHfXL8vVQHls/yhiUY+P+GU7OGeSobgvJbOYo+1uD5t14KFMT9dMB+8Wkx
	 niUWHwbHtRq64v3I75qAuAWMqtUtWtseq4YrDwAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Hari Nagalla <hnagalla@ti.com>,
	Martyn Welch <martyn.welch@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.12 142/414] remoteproc: k3-m4: Dont assert reset in detach routine
Date: Mon, 23 Jun 2025 15:04:39 +0200
Message-ID: <20250623130645.606294447@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beleswar Padhi <b-padhi@ti.com>

commit 23532524594c211871054a15c425812a4ac35102 upstream.

The rproc_detach() function invokes __rproc_detach() before
rproc_unprepare_device(). The __rproc_detach() function sets the
rproc->state to "RPROC_DETACHED".

However, the TI K3 M4 driver erroneously looks for "RPROC_ATTACHED"
state in its .unprepare ops to identify IPC-only mode; which leads to
resetting the rproc in detach routine.

Therefore, correct the IPC-only mode detection logic to look for
"RPROC_DETACHED" in k3_m4_rproc_unprepare() function.

Fixes: ebcf9008a895 ("remoteproc: k3-m4: Add a remoteproc driver for M4F subsystem")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Reviewed-by: Hari Nagalla <hnagalla@ti.com>
Reviewed-by: Martyn Welch <martyn.welch@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250513054510.3439842-5-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_m4_remoteproc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/ti_k3_m4_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_m4_remoteproc.c
@@ -228,7 +228,7 @@ static int k3_m4_rproc_unprepare(struct
 	int ret;
 
 	/* If the core is going to be detached do not assert the module reset */
-	if (rproc->state == RPROC_ATTACHED)
+	if (rproc->state == RPROC_DETACHED)
 		return 0;
 
 	ret = kproc->ti_sci->ops.dev_ops.put_device(kproc->ti_sci,


