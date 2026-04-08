Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A96B67E;
	Wed,  8 Apr 2026 18:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673490; cv=none; b=eazlIb/uDMuo5lgMu2QEmPMw7uA8wU79VrdXy6JLi3eVftefSpnjkfuGFIrtEZ095Q6mSx2rsCLJoLg8aeDKS2ghrKGVuXZABAbxn1tGp/Q4uOlyxHGx4k1Gf1C855zcn07f6WaGClPHPUQu4ATUL8YNJhFs+8Kuy9J0CMHZ2NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673490; c=relaxed/simple;
	bh=OE1Idw7NnAwNVbNaFx+WetI6HJ3jY+Ry17r7utcnEbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSOdvGd2FISyp2xyha833cHJKhD6ZL1QN7z0VgLsgSyyhBcU7oWfEGeEqraNB54zoN2pXsD60cAnJpJlMFcW3cqaYrdcF3eX9e9iT4l4A08HNKXloLGzmTAY/+vmT8EUbcrv0lT7zx57+Q9q/44CHUF6o3BAvhexQ1w7j2Pcsbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nv6/mHe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nv6/mHe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51104C19421;
	Wed,  8 Apr 2026 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673490;
	bh=OE1Idw7NnAwNVbNaFx+WetI6HJ3jY+Ry17r7utcnEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nv6/mHe8G1O++EiXUkfkCoPlQDj/5vni06WHOC8fMERO16O02LCjWmmm3QIBP+/9D
	 VcsT9MGy4OxX/Y/b0bx8ngNCWEcKVEJpm8HW8XgQ2N207ksaoAI+JhCsDA+8A6yqaM
	 b9e15Fa1G8pOri7Ax9bkaCo1sJ2yAXWVf7Vbzp2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 220/277] spi: cadence-qspi: Fix exec_mem_op error handling
Date: Wed,  8 Apr 2026 20:03:25 +0200
Message-ID: <20260408175942.071874988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1487,14 +1487,6 @@ static int cqspi_exec_mem_op(struct spi_
 	if (refcount_read(&cqspi->inflight_ops) == 0)
 		return -ENODEV;
 
-	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
-		ret = pm_runtime_resume_and_get(dev);
-		if (ret) {
-			dev_err(&mem->spi->dev, "resume failed with %d\n", ret);
-			return ret;
-		}
-	}
-
 	if (!refcount_read(&cqspi->refcount))
 		return -EBUSY;
 
@@ -1506,6 +1498,14 @@ static int cqspi_exec_mem_op(struct spi_
 		return -EBUSY;
 	}
 
+	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret) {
+			dev_err(&mem->spi->dev, "resume failed with %d\n", ret);
+			goto dec_inflight_refcount;
+		}
+	}
+
 	ret = cqspi_mem_process(mem, op);
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
@@ -1514,6 +1514,7 @@ static int cqspi_exec_mem_op(struct spi_
 	if (ret)
 		dev_err(&mem->spi->dev, "operation failed with %d\n", ret);
 
+dec_inflight_refcount:
 	if (refcount_read(&cqspi->inflight_ops) > 1)
 		refcount_dec(&cqspi->inflight_ops);
 


