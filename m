Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A82F15DBA5;
	Mon, 29 Jan 2024 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548434; cv=none; b=JQDGqNrqz+Wac2vIy0hIcLrSa8Uhkry30CHCtvsJgfoJcq/3BZW0cor5n/X34DWV6Jeifo+y0rTieEm7bsU3OhImrNhdeBJIVsU1zONv2vjCJzrDuOX/QsvABPBt2hXqzXc2w4SRkVBfeU6PSKsvsr0XI+D8ZIC5uo/MUpjFOSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548434; c=relaxed/simple;
	bh=1/eSwRFe90CpA8IO2LFN+w93HB8LjUqNg7zmfeLlG/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbapo5/nETIcz64XiiB+sNpBIn31XtSLXT8jfeFRptId6Jj2tErx/SKvtK1GzVmQ3bykV4IF5fQMlrYKYnWJflBsY1oWVhDb81nYGzbmi8IdwDqu4KkMO9CvH0ycPILzL2KumJcb0uj0/cxSJftIvuTl3aThNq0pGSPrqhQhJu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJB6A+N8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJB6A+N8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D843BC433F1;
	Mon, 29 Jan 2024 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548433;
	bh=1/eSwRFe90CpA8IO2LFN+w93HB8LjUqNg7zmfeLlG/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJB6A+N8n4uyYK+qTX34sOFl+KkUUhT1JpxeCjlqC5mWvf/pIpdalSZsvPLPiucf2
	 nvfHlbAeA7TFoBjd+1/fjJve8yNf6n8zUCcyYXVku9P1WeRiZXzuc5ltvrDzUVRCln
	 xrQ2NLYMmcuM8SRsusKscp9mmvwTWNJyBNkxqOP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 037/331] crypto: lib/mpi - Fix unexpected pointer access in mpi_ec_init
Date: Mon, 29 Jan 2024 09:01:41 -0800
Message-ID: <20240129170016.024465853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit ba3c5574203034781ac4231acf117da917efcd2a upstream.

When the mpi_ec_ctx structure is initialized, some fields are not
cleared, causing a crash when referencing the field when the
structure was released. Initially, this issue was ignored because
memory for mpi_ec_ctx is allocated with the __GFP_ZERO flag.
For example, this error will be triggered when calculating the
Za value for SM2 separately.

Fixes: d58bb7e55a8a ("lib/mpi: Introduce ec implementation to MPI library")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/mpi/ec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/crypto/mpi/ec.c b/lib/crypto/mpi/ec.c
index 40f5908e57a4..e16dca1e23d5 100644
--- a/lib/crypto/mpi/ec.c
+++ b/lib/crypto/mpi/ec.c
@@ -584,6 +584,9 @@ void mpi_ec_init(struct mpi_ec_ctx *ctx, enum gcry_mpi_ec_models model,
 	ctx->a = mpi_copy(a);
 	ctx->b = mpi_copy(b);
 
+	ctx->d = NULL;
+	ctx->t.two_inv_p = NULL;
+
 	ctx->t.p_barrett = use_barrett > 0 ? mpi_barrett_init(ctx->p, 0) : NULL;
 
 	mpi_ec_get_reset(ctx);
-- 
2.43.0



