Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9853D648A;
	Wed,  8 Apr 2026 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674858; cv=none; b=F462lrbXO6XNby0QI7iNw6+E42zE/r0bGKunMlTan0N9Yw1Y4KY8vSjUeRyqLc4m6PxpvCb3jOUeOvMBmdWAj3IjkP+o8cKYyNlPQ1HzSsHMEk3JJfg0131uKoByG4T5PSrtnYZxWI1nwUvd+KNkRw4kIiU9F+voJMUoLnbfHAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674858; c=relaxed/simple;
	bh=bmD4r6B94XFVrhR4P+PkMF0yt+T1kuKEncJtRDK0+Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX4P5X1J5W/D7K3+UrRgt9ROBzuc5RfX2pD2KhxX4qP0R22IcGBW+y3Y23B8deWJcUvfQjqWrdakmWDs4MXXxQK71k8v9eIOkRIEYWsemMBMwPj+c79gy6sJud7ZzRepM43SI21fUMy9QtOpGkXX7labeRucQOK9zVjBMUPsrlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UX/nDgwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UX/nDgwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23358C19421;
	Wed,  8 Apr 2026 19:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674858;
	bh=bmD4r6B94XFVrhR4P+PkMF0yt+T1kuKEncJtRDK0+Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UX/nDgwgf/W1o76GKFt8M+dGQBo0KxfJc2hV6YKu2id3HJHclBkjb606gH+n/hugz
	 iO2/kabkkO3aScFD6m932wKdzruV2U5uOufISbWKpGo3zxzLY/Z0rRC79Fp4m2FIMv
	 +6XfAC7d6tIh3wmUl/IesflCU6aSQatKCBShVY5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 261/311] spi: cadence-qspi: Fix exec_mem_op error handling
Date: Wed,  8 Apr 2026 20:04:21 +0200
Message-ID: <20260408175949.130361310@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1478,14 +1478,6 @@ static int cqspi_exec_mem_op(struct spi_
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
 
@@ -1497,6 +1489,14 @@ static int cqspi_exec_mem_op(struct spi_
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
@@ -1505,6 +1505,7 @@ static int cqspi_exec_mem_op(struct spi_
 	if (ret)
 		dev_err(&mem->spi->dev, "operation failed with %d\n", ret);
 
+dec_inflight_refcount:
 	if (refcount_read(&cqspi->inflight_ops) > 1)
 		refcount_dec(&cqspi->inflight_ops);
 


