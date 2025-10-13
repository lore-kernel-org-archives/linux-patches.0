Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437D9316195;
	Mon, 13 Oct 2025 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370312; cv=none; b=dfjEgWfv291To7XFFJPcvU7rqhLOqYr2aCgwlpztIwVyt1MI8tXrpt6/uo5XW5f3Lr7BKO4nuk/+HmYOksBK/6IRqNdYROprBYACNH3KbqdsyqmGyAVJnGhXufTK44Wb3CZ89R4eGL/Duf4wWLLQ6SYbq9InyWOU82tCCUb5gMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370312; c=relaxed/simple;
	bh=OvvFqPxnYm7/pXP4B/yzedU4ZmEKueXYxwKMM5mjdfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE6SOl5Wjn0DcxrgsceeuNra7VOZqvfGYPPvXxDusfIDYnT+GpzYYxY0ypxXastiRTZDVo+xINpj71blmhERW5PzXHvYHkZbsz2hTznMG//o07eFD2l17BFNzt2gauJd62YcgJBzwiV7gEWKN3QV/wH2rQ2ST5HjfkWFnG9lRro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyxkRJUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyxkRJUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB80C4CEE7;
	Mon, 13 Oct 2025 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370312;
	bh=OvvFqPxnYm7/pXP4B/yzedU4ZmEKueXYxwKMM5mjdfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyxkRJUpwsrqbkp78WSAh4q2A5MH9ocnek/SNFSvK08Crn3QqLOEh4rw861YjhNm3
	 mn1k+GagLfwirtclWUjhTH28sDkL8agE150S2bHa/H5+BuPhw5IR2YeqI2DbB089k3
	 4X4c54PSAoo+30f+6luf7/TIZ8TOY5NqpI+lINa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.17 551/563] remoteproc: pru: Fix potential NULL pointer dereference in pru_rproc_set_ctable()
Date: Mon, 13 Oct 2025 16:46:52 +0200
Message-ID: <20251013144431.265444115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 


