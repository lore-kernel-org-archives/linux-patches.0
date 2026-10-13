Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB6218E91;
	Tue, 13 Oct 2026 12:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894610; cv=none; b=NkgGm29IZb7JTe7ncr1G+HQukLxpnz9rnlHw6bS1VnpBHsA3ud3BFZq9fZbE7+s9dzwKqKCvPVQoCON/4MT8apX9jFd8TQCPUfjH0PDrQgBmqbdhC2WTyU3tf/oNKTBfv+RC3MUyoSYmraCjSUZQSS7VbeLsmNynIQlNPjj2aBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894610; c=relaxed/simple;
	bh=q+YQFw+OSNxG4iyOqxJqqA+YVkP+A2NNe3mF1pziSKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKgpug0yH8mw4Bid+B0vIPCAjAUGqmO9Fp94Iws/RbFyG+2stxkfmXW4dO+YhEKaDyMslVrxVbpjQlFi0M1ucMqJTB8F0AObtFtYvLvxZL1+DWDHvezLRUjlLAJnEm5a4pbc6iZ/obcu4IPsPN6kqnh+SJ6HdkKLAo4q2z0RRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1n/1+8zB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1n/1+8zB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E591F000FF;
	Tue, 13 Oct 2026 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894609;
	bh=lUdGshRuVL7wgK0YYk/BnC8e+31mkYMYM7rXroHIc9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1n/1+8zBFABAmQmBvJfdApyZyZGfpxlJcA+65UNANBss/pVsiC5KjAExQtawauEro
	 D/nDlwT9jYDHiy/bzmXUpyK2I1sqg2PFxvjDYOcLLxUIMB/rZoOA9rkYWTfM6JnWw6
	 HknhifgN6hR/T2o7JHvxidho50IJhCD6FpDixfXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 6.18 616/621] accel/amdxdna: Resume power for creating and destroying hardware context
Date: Tue, 13 Oct 2026 13:40:11 +0200
Message-ID: <20261013112935.418056730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

commit e00f78679f5a3d98b650fc9397c4d358ab570725 upstream.

When the hardware is powered down by auto-suspend, creating or destroying
a hardware context without resuming power will fail.
Call amdxdna_pm_resume_get() before requesting the hardware to create or
destroy a hardware context.

Fixes: 063db451832b ("accel/amdxdna: Enhance runtime power management")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20251008045324.4171807-1-lizhi.hou@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/aie2_ctx.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -616,10 +616,14 @@ int aie2_hwctx_init(struct amdxdna_hwctx
 		goto free_entity;
 	}
 
+	ret = amdxdna_pm_resume_get(xdna);
+	if (ret)
+		goto free_col_list;
+
 	ret = aie2_alloc_resource(hwctx);
 	if (ret) {
 		XDNA_ERR(xdna, "Alloc hw resource failed, ret %d", ret);
-		goto free_col_list;
+		goto suspend_put;
 	}
 
 	ret = aie2_map_host_buf(xdna->dev_handle, hwctx->fw_ctx_id,
@@ -634,6 +638,7 @@ int aie2_hwctx_init(struct amdxdna_hwctx
 		XDNA_ERR(xdna, "Create syncobj failed, ret %d", ret);
 		goto release_resource;
 	}
+	amdxdna_pm_suspend_put(xdna);
 
 	hwctx->status = HWCTX_STAT_INIT;
 	ndev = xdna->dev_handle;
@@ -646,6 +651,8 @@ int aie2_hwctx_init(struct amdxdna_hwctx
 
 release_resource:
 	aie2_release_resource(hwctx);
+suspend_put:
+	amdxdna_pm_suspend_put(xdna);
 free_col_list:
 	kfree(hwctx->col_list);
 free_entity:


