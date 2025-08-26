Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F2A350831;
	Tue, 26 Aug 2025 14:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218762; cv=none; b=gO4BZy098XSA2Vd0kUQtf+88wdkBFZUzsOYVFq7/g8+FKkqVBBraQF2yTo1+JCcCZzTkqVE3rv1Tul5ZIKavQHyt5d8CVlsubxHDevvq1hYVRGRtYwPr4R+/C7vGRU+rp45hkKe2S1OQUeLyB3O5VlxyY/TcrGZQsVVM5wNfhSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218762; c=relaxed/simple;
	bh=6CXU9kxrvhi4N0ZrBWWjfjkYNDguOxuCGA2Kd0zlhE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjCEqI5j2Z9ui5V/wtZZxxoyXHL8AoudTjA6yII/Vp1NlUMQOak7p7pa5HU9O1Jvam/GMeOkGOHArm5sxp1qQKKMiNhxLiAlSVxqPePmb2k/XDt4zk3dpjXD63UFzomJEjDHyQk/lGmmllCBN4wSJjmaDuaOKuokMitDE4sS1gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlcIiZi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlcIiZi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E49C4CEF1;
	Tue, 26 Aug 2025 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218762;
	bh=6CXU9kxrvhi4N0ZrBWWjfjkYNDguOxuCGA2Kd0zlhE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlcIiZi8biZT8+BbCIS5yccPL8u8hQHXU/8vfAbzrWsMlTW15/spRmGWXPGwO9TwL
	 OioywaTARSY1GYRjuJ+T+rFwpQC6d3nLSOivBqxdCMllN1FZGgB0PT61BrDcc7ucDZ
	 XpqpQRCzTEzHjiMK7E8dKN7iZmxef7Nu5hpalUKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/403] crypto: qat - fix seq_file position update in adf_ring_next()
Date: Tue, 26 Aug 2025 13:07:30 +0200
Message-ID: <20250826110910.163207863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e794e9d97b2c..9303d6318207 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -75,8 +75,10 @@ static void *adf_ring_next(struct seq_file *sfile, void *v, loff_t *pos)
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



