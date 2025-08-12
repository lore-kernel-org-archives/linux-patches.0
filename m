Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6E4282E1;
	Tue, 12 Aug 2025 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021691; cv=none; b=kVsZoL34aplGzB0UfaLuekNwXF8lKbtqiz60SfcbQBA3Up29fwgGT1atrEhIzZEyp6wCKMqlCOxgvpMczIqnZSYhyzPShVB96Af4XsVaUAo/J8C61QnASfF3t88zDXk5MR578J2XZ0YfMHSJmXiozNw/OJBurahapdKbLJ6KZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021691; c=relaxed/simple;
	bh=I9usJA+My72Ws5ApLUmgSA+Zhhc197hCqSAMogiJ8a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIoLeKyKMKwG5WZNSioQs9CNfoixTqVnAzxI1R+j9wHilZOBfGECEqXgr1LqLm7YacVCaeXDsg2/UEBVyQauMg4g1R4H5swm1G/eAXj/hndgTI1iVi9Ak8ATMvPzElmeWwCqo/LAM947+hUkskEhgXxJDbYAsqswFrkAwt2tCgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8KiUP7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8KiUP7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B216DC4CEF0;
	Tue, 12 Aug 2025 18:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021691;
	bh=I9usJA+My72Ws5ApLUmgSA+Zhhc197hCqSAMogiJ8a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8KiUP7cNAMy27XJj2Eyfg1KxIjCEryivVe3ahAyh/6YWFQydTTDJaBDvGjSJAAId
	 nMJIuiyvOgOYrlOkjbdcliuvKdEw8ri0Ix0tjc8algLn/+El/soV5BoJIn+EuWGSUE
	 zMvOqYD+M/QCbqt2rggcy0CEK08+Yocf5kUbBfkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/262] crypto: qat - fix seq_file position update in adf_ring_next()
Date: Tue, 12 Aug 2025 19:29:01 +0200
Message-ID: <20250812172959.615014506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/qat/qat_common/adf_transport_debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index e2dd568b87b5..621b5d3dfcef 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
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



