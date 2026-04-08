Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18B03D9037;
	Wed,  8 Apr 2026 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674191; cv=none; b=YOLat3r7gdr0/uhZOdPW8R4n6X5K0mmXa3QqKyyL9zb69NZFLjTH0tuPY8NkJofFsQqlUugVee9iJhJBzXmZgwUr22EVsxzoer6JnkDJO2EnFMOeSCT2DmvCmweWPV4Mr4RF1Q6rwDGPJMmMeqaZTg1izuWRj7PCaZv2gcivgJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674191; c=relaxed/simple;
	bh=qnJLzJDRqFAXhb4vK+UOWlOYm7Te59HOwIiUnw3q2pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoo42m+/2jjiYB+k2mkq8DW3CrEWujKXfY+qrJp5R7b+T4o/kW2a7lQrQzzXKxBGWblDs+Dsnjx2PsIZx03veDfEn94OxxWGSKXvY39IqBw7zsNec5bYUnh7Dt5YtHk+qWnIrX2S2aXFh+8bleSozfsLCYlGymSI3OXvN8dcjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNw5kJYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNw5kJYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3980DC2BC87;
	Wed,  8 Apr 2026 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674190;
	bh=qnJLzJDRqFAXhb4vK+UOWlOYm7Te59HOwIiUnw3q2pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNw5kJYn30mqnRULCJ35x8PF5tGZBwwJB9DfmlmprTrEfq86kBR9kzuExi5DeDMik
	 vJFUrXJfokro4mwDgSWK1W8PkgheW4rj2yLffryu00ZDm/F6w4CqYy9D30b89gXXkb
	 txxYpRGPSUfFFCfEAEu6uSP0o9mAGYoIsuIUSZLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 213/242] spi: cadence-qspi: Fix exec_mem_op error handling
Date: Wed,  8 Apr 2026 20:04:13 +0200
Message-ID: <20260408175935.052127592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

commit 59e1be1278f064d7172b00473b7e0c453cb1ec52 upstream.

cqspi_exec_mem_op() increments the runtime PM usage counter before all
refcount checks are performed. If one of these checks fails, the function
returns without dropping the PM reference.

Move the pm_runtime_resume_and_get() call after the refcount checks so
that runtime PM is only acquired when the operation can proceed and
drop the inflight_ops refcount if the PM resume fails.

Cc: stable@vger.kernel.org
Fixes: 7446284023e8 ("spi: cadence-quadspi: Implement refcount to handle unbind during busy")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Link: https://patch.msgid.link/20260313135236.46642-1-ghidoliemanuele@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1461,12 +1461,6 @@ static int cqspi_exec_mem_op(struct spi_
 	if (refcount_read(&cqspi->inflight_ops) == 0)
 		return -ENODEV;
 
-	ret = pm_runtime_resume_and_get(dev);
-	if (ret) {
-		dev_err(&mem->spi->dev, "resume failed with %d\n", ret);
-		return ret;
-	}
-
 	if (!refcount_read(&cqspi->refcount))
 		return -EBUSY;
 
@@ -1478,6 +1472,12 @@ static int cqspi_exec_mem_op(struct spi_
 		return -EBUSY;
 	}
 
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret) {
+		dev_err(&mem->spi->dev, "resume failed with %d\n", ret);
+		goto dec_inflight_refcount;
+	}
+
 	ret = cqspi_mem_process(mem, op);
 
 	pm_runtime_mark_last_busy(dev);
@@ -1486,6 +1486,7 @@ static int cqspi_exec_mem_op(struct spi_
 	if (ret)
 		dev_err(&mem->spi->dev, "operation failed with %d\n", ret);
 
+dec_inflight_refcount:
 	if (refcount_read(&cqspi->inflight_ops) > 1)
 		refcount_dec(&cqspi->inflight_ops);
 


