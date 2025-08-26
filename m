Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07A93451DE;
	Tue, 26 Aug 2025 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215951; cv=none; b=jF7rA9CoEQghrZ9aLT68MfGcZvdqpuIpXtCK7l62IkblNWttyQJ5USzGtyyHz4vQeIFPohl7F+rC9ogEwhLMd/8w5xa/yX4ZzBOAHZNziUozqeTCEVO9/haS+NmM5S71nZX3qVpTCrpibb8c5LMLsaRFMcGku67mNl/WECd6vCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215951; c=relaxed/simple;
	bh=JwtekzWspDPsxaLuzN+64O0wPCsxqHXd9yA8mFF2yXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cid26kUhKSS9H8u6fCNrdqbqRx+/Kq25aFSqZCKzEBIxoi/MkInVTsueL6o/kbna+YtPDnuGOBfvc84PxrDuBJsxmio1mlxPdY30yt7y9WZJBvjU4lu7bM6hkBcvOlWjjeu0IhK8UwoHwCTC6NsjCL9QPZs1LMUF+W9VThiUANM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rc0znc2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rc0znc2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80911C4CEF1;
	Tue, 26 Aug 2025 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215950;
	bh=JwtekzWspDPsxaLuzN+64O0wPCsxqHXd9yA8mFF2yXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rc0znc2R8OwUATM5X21iWYoxn5dDQhmvioGf9iKZPkppth5id3dXKjfrL8YXpc/Pg
	 255z3lZWpPwa+Z1TEiWFj4vswpn/t8iWro8PmT1diDpZ9z9wDIx63UOCvBBvGLI5I/
	 kfWwA2Disz6FhX3DW0RxC548EzcteP5wrtuLg4ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/644] crypto: qat - fix seq_file position update in adf_ring_next()
Date: Tue, 26 Aug 2025 13:04:47 +0200
Message-ID: <20250826110951.306420422@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 006867f410bd..494ddab81df7 100644
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



