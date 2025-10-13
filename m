Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1951A9B46;
	Mon, 13 Oct 2025 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368746; cv=none; b=Uyho3DzA0e0X5eeXaictdThfIFBLe20ZkDWiy6m0mSNlIVWOyStzNBcGEYW4n01cnVwle5Lr9j60+K6/8rrnnaGLTwAFlcidDz+T0NWmx1AKwew4ii6+AyFTlGcZaffhs2Aw6tp2Rz/Lox4UKUc0yRahZFnerjlrFHcYtEtjiVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368746; c=relaxed/simple;
	bh=f56wNkBTP+PI3pHlWxRnpHYERySq68ulkfftHaAHA54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2dDitVMl8gWAxhHFlqU8f4POCN9HZUYkGRaIyxmW7pGwHMLpFUsh7Ce5NLfmXhqUJYEV+TVjzYkRXJk1tJ1W7Efx0/9zeVbd5dnbbrv3EuHQjdWFXjiVCrR+0eAfATt9/gKM9FrnUSR5gIYPh4Xw5OP4k22Oh3oaf2TwC6DqNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEBUEIjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEBUEIjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AE4C4CEE7;
	Mon, 13 Oct 2025 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368746;
	bh=f56wNkBTP+PI3pHlWxRnpHYERySq68ulkfftHaAHA54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEBUEIjVx6wHYW0S1XdLJIE/I1/FYRTj0SrS3t7iHu5r6dPS4UJdEQvqcCFXA3qID
	 ydrOf9hHZJdalujYGioUTcYlz1D6yzcdGqFi4bkuOx7iZGKb5uZUkXiFS5mn2eW0xf
	 wC287D4Uuqbf2MxsYJV7mutulvoIK81J3vZOiMec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.12 254/262] remoteproc: pru: Fix potential NULL pointer dereference in pru_rproc_set_ctable()
Date: Mon, 13 Oct 2025 16:46:36 +0200
Message-ID: <20251013144335.382651725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Zhen Ni <zhen.ni@easystack.cn>

commit d41e075b077142bb9ae5df40b9ddf9fd7821a811 upstream.

pru_rproc_set_ctable() accessed rproc->priv before the IS_ERR_OR_NULL
check, which could lead to a null pointer dereference. Move the pru
assignment, ensuring we never dereference a NULL rproc pointer.

Fixes: 102853400321 ("remoteproc: pru: Add pru_rproc_set_ctable() function")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Link: https://lore.kernel.org/r/20250923112109.1165126-1-zhen.ni@easystack.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/pru_rproc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -340,7 +340,7 @@ EXPORT_SYMBOL_GPL(pru_rproc_put);
  */
 int pru_rproc_set_ctable(struct rproc *rproc, enum pru_ctable_idx c, u32 addr)
 {
-	struct pru_rproc *pru = rproc->priv;
+	struct pru_rproc *pru;
 	unsigned int reg;
 	u32 mask, set;
 	u16 idx;
@@ -352,6 +352,7 @@ int pru_rproc_set_ctable(struct rproc *r
 	if (!rproc->dev.parent || !is_pru_rproc(rproc->dev.parent))
 		return -ENODEV;
 
+	pru = rproc->priv;
 	/* pointer is 16 bit and index is 8-bit so mask out the rest */
 	idx_mask = (c >= PRU_C28) ? 0xFFFF : 0xFF;
 


