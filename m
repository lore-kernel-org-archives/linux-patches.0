Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8C935AABE;
	Tue, 26 Aug 2025 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217516; cv=none; b=c/kE+cgh+2e8hPYTm5UAlOoJVA0J3YvTzCjqpo5hVTOdlAylZJXL2BbkXe327rJrWxx0kfMf2apYRWivv/GLZ1g4kvXgT5fK6lZSCyPRKhF7VkkAtgk8a1Yrz4AE1qw90ZV9t95UXkdrFLF7ka0CKlv5Gz3RUgpdYhsKqz4o568=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217516; c=relaxed/simple;
	bh=7PIDwsgiBkk1hQoxpKeJFw9ZXvj5Ag79A4JOzuF3rps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbJ1VoDf5mPmPCN1dXZdtDMhk6oEK2tZpSCAprrm69C9nr6QZNjCK1CZp31sa7/EYx2jAMlhauEPi1p1ANlHSI7yMloJUM450y5pHQ+/fqTMhieDT5jJXDZe5fA5LWKhZRcgiQ2Ortka9ZWQJcIOwKfhEJSS+Rpopa1S3TUgxGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsrgxFIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsrgxFIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7E6C4CEF1;
	Tue, 26 Aug 2025 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217516;
	bh=7PIDwsgiBkk1hQoxpKeJFw9ZXvj5Ag79A4JOzuF3rps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsrgxFIE8cV/gaBBdf2JpE/GpA64jxcqznEB9Rv2QfV2iw9ol7CBFKaorCuntuLEg
	 xudsh2H+2o73Joz/d23DnlkLI16ZlTTebNzDoUGdtnUajiofj+BqMcxTcD2XA4qljk
	 OHzana675qXWrFOsZtrVSjIBveM17hfAl51ycE/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/523] crypto: qat - fix seq_file position update in adf_ring_next()
Date: Tue, 26 Aug 2025 13:05:51 +0200
Message-ID: <20250826110927.976128873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 6908c5f4f066a0412c3d9a6f543a09fa7d87824b ]

The `adf_ring_next()` function in the QAT debug transport interface
fails to correctly update the position index when reaching the end of
the ring elements. This triggers the following kernel warning when
reading ring files, such as
/sys/kernel/debug/qat_c6xx_<D:B:D:F>/transport/bank_00/ring_00:

   [27725.022965] seq_file: buggy .next function adf_ring_next [intel_qat] did not update position index

Ensure that the `*pos` index is incremented before returning NULL when
after the last element in the ring is found, satisfying the seq_file API
requirements and preventing the warning.

Fixes: a672a9dc872e ("crypto: qat - Intel(R) QAT transport code")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_transport_debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index e6bdbd3c9b1f..b0a553d680dc 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -31,8 +31,10 @@ static void *adf_ring_next(struct seq_file *sfile, void *v, loff_t *pos)
 	struct adf_etr_ring_data *ring = sfile->private;
 
 	if (*pos >= (ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /
-		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size)))
+		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size))) {
+		(*pos)++;
 		return NULL;
+	}
 
 	return ring->base_addr +
 		(ADF_MSG_SIZE_TO_BYTES(ring->msg_size) * (*pos)++);
-- 
2.39.5



