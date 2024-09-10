Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9BB190678;
	Tue, 10 Sep 2024 10:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962989; cv=none; b=apXfqKfgoHlR3+ZdXDBgsQ0L++HxH5EzqiVPbMr5tfPhsvIfYO3pfM7rfIZgYDneed3QNP2MbRzS35e3HI4RRgoXFzlad5MbrYQlA8myNdaFPQvgPt4Ipj3YsZSsXoTyKX8P27PBgARIPM9yjqVQW6SCkF9ugiFQp2PbHjot+ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962989; c=relaxed/simple;
	bh=oGxvXzLw55o2zr+Ry8u3IIbuv8GzF0Jvd0J1n2BI/kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdflrqEP2PTT+ibyVKfM3eX1LJ+4pcv40Q5qo0WXFjoGrwTwPsZ0IRDFM+c2kTi/m/q0zVZfsJjseZcbOo4DXzdFYmppS0u4swmXYASXwOqI0+TuTEmTs2d8g1Q5OENtrjyx6BBoOkXSOolGlAxrRL4BeMNv+np50bn5+tFVBzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGvmASen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGvmASen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FF7C4CEC3;
	Tue, 10 Sep 2024 10:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962988;
	bh=oGxvXzLw55o2zr+Ry8u3IIbuv8GzF0Jvd0J1n2BI/kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGvmASenfenwP/4FhIVKdnIsDtCuA2SieXaZKYSfjU+9Ff78hZcqqoLEvPHCZWnu8
	 PnYmSIT9zrUZuWdXenNH8xApMm2aDv/AnWUAsjmmocG0315dVb7F1uTbwScJGvV+/h
	 GkhLXPRLPzKXz7xDUCeBsnJGQGxG5zi4qJa0Ah30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/192] crypto: qat - fix unintentional re-enabling of error interrupts
Date: Tue, 10 Sep 2024 11:32:01 +0200
Message-ID: <20240910092602.018944253@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>

[ Upstream commit f0622894c59458fceb33c4197462bc2006f3fc6b ]

The logic that detects pending VF2PF interrupts unintentionally clears
the section of the error mask register(s) not related to VF2PF.
This might cause interrupts unrelated to VF2PF, reported through
errsou3 and errsou5, to be reported again after the execution
of the function disable_pending_vf2pf_interrupts() in dh895xcc
and GEN2 devices.

Fix by updating only section of errmsk3 and errmsk5 related to VF2PF.

Signed-off-by: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c          | 4 +++-
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 70ef11963938..43af81fcab86 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -100,7 +100,9 @@ static u32 adf_gen2_disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
 	errmsk3 |= ADF_GEN2_ERR_MSK_VF2PF(ADF_GEN2_VF_MSK);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 
-	errmsk3 &= ADF_GEN2_ERR_MSK_VF2PF(sources | disabled);
+	/* Update only section of errmsk3 related to VF2PF */
+	errmsk3 &= ~ADF_GEN2_ERR_MSK_VF2PF(ADF_GEN2_VF_MSK);
+	errmsk3 |= ADF_GEN2_ERR_MSK_VF2PF(sources | disabled);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 
 	/* Return the sources of the (new) interrupt(s) */
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index cb3bdd3618fb..85295c7ee0e0 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -180,8 +180,12 @@ static u32 disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, errmsk5);
 
-	errmsk3 &= ADF_DH895XCC_ERR_MSK_VF2PF_L(sources | disabled);
-	errmsk5 &= ADF_DH895XCC_ERR_MSK_VF2PF_U(sources | disabled);
+	/* Update only section of errmsk3 and errmsk5 related to VF2PF */
+	errmsk3 &= ~ADF_DH895XCC_ERR_MSK_VF2PF_L(ADF_DH895XCC_VF_MSK);
+	errmsk5 &= ~ADF_DH895XCC_ERR_MSK_VF2PF_U(ADF_DH895XCC_VF_MSK);
+
+	errmsk3 |= ADF_DH895XCC_ERR_MSK_VF2PF_L(sources | disabled);
+	errmsk5 |= ADF_DH895XCC_ERR_MSK_VF2PF_U(sources | disabled);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, errmsk5);
 
-- 
2.43.0



