Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAD5349AF5;
	Tue, 12 May 2026 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609571; cv=none; b=PYv1SLE6bst7fmvVmo5PHP+BPbkEE8cMkQuLZMOhovt4fm8MP1kn8lkgUJEvy6wiz+D5vjAHeHnf2z32D3mPcyhIUvZXhRwdD7a3FDG44Q2FFGyo+1vGfQl/bqau+KG+JerAvICajB1YOY4xLSaaHXlGHx4Pl+GGvpazhILpGko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609571; c=relaxed/simple;
	bh=4rEd6XAwQ5WXmSd5AtBvTk9MHjVjBdO4vHbH/V8ArEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezWcp10Lp5KSbn7c4Sgbylzixm6zARLf/UcI+/k5lF02TL4MBghR8zNY6dsAN9Ig+MhqoMHrx+e4LL0OEuz0dF0VxKuTanJjmZQNEnHJC4Sk2KL6iYrkaV/72u8IF0WaC8dobwXQ3IyW+NW5n/XCwG8vVhsXjQPiPj3E+XTmWCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ0Qkabn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ0Qkabn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D42C2BCC7;
	Tue, 12 May 2026 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609571;
	bh=4rEd6XAwQ5WXmSd5AtBvTk9MHjVjBdO4vHbH/V8ArEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ0QkabnDIWlouPv95uHxaMztI1dCYjfjXM7sfnGuwoFKBHiPcKOw9BQT32mxnjfq
	 ABzXNzbMUa2UCviXNwETCa2dUBiANh2fzfPmQubkPlNnk1s6ytJ3qbhDJziRT+xAZU
	 2Eby4peMJsjKWOhlbgGE0jcZeehi8qEVCQeZNriM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 7.0 245/307] remoteproc: k3: Fix NULL vs IS_ERR() bug in k3_reserved_mem_init()
Date: Tue, 12 May 2026 19:40:40 +0200
Message-ID: <20260512173945.295405965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 5b1f4b5c72cc40e676293b8609cacef7e1545beb upstream.

The devm_ioremap_resource_wc() function never returns NULL, it returns
error pointers.  Update the error checking to match.

Fixes: 67a7bc7f0358 ("remoteproc: Use of_reserved_mem_region_* functions for "memory-region"")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260227092110.4044313-1-nichen@iscas.ac.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/ti_k3_common.c b/drivers/remoteproc/ti_k3_common.c
index 32aa954dc5be..3cb8ae5d72f6 100644
--- a/drivers/remoteproc/ti_k3_common.c
+++ b/drivers/remoteproc/ti_k3_common.c
@@ -513,7 +513,7 @@ int k3_reserved_mem_init(struct k3_rproc *kproc)
 		kproc->rmem[i].dev_addr = (u32)res.start;
 		kproc->rmem[i].size = resource_size(&res);
 		kproc->rmem[i].cpu_addr = devm_ioremap_resource_wc(dev, &res);
-		if (!kproc->rmem[i].cpu_addr) {
+		if (IS_ERR(kproc->rmem[i].cpu_addr)) {
 			dev_err(dev, "failed to map reserved memory#%d at %pR\n",
 				i + 1, &res);
 			return -ENOMEM;
-- 
2.54.0



