Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373AE3F44DF;
	Fri, 15 May 2026 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862516; cv=none; b=bMrEFYBIr+ISvMGhQ4abJ7lSX8QIE/glZ+UdHHP5n0iRW2OKQ++NdOIGYPRuPZO0NmC3dg5punFs9PHtXL0rRRl174tMclzqZSmJIYG5K1GAAR+1aOGjvOxY4JYWEubVq1CyehPxGhbgVz2ugsbwm0t4uHY6sCUjj2AlY7SH1T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862516; c=relaxed/simple;
	bh=wk4VK+ZecMTLGbPNLHoYN5NlfPwGT+mRTT6Wv3w7Uo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTQKs6XfcxZzEA4THcl+OAakAvv/SZk3zqsuRoyJ11qPWenNjwKag8Uu9n5G1nb2XTWhMCL/B40YOFFj7R2vVwPuc6eQZrJVEmPn1fIlfe3gMA1bE+Hhx1EeW3fULigRbkoS7HbY0oraIKqo4ZzhA9gPZIGVMTxrKyQIXHrUQhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnOwuuRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnOwuuRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0550C2BCB0;
	Fri, 15 May 2026 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862516;
	bh=wk4VK+ZecMTLGbPNLHoYN5NlfPwGT+mRTT6Wv3w7Uo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnOwuuRIZ80A8BA9HN1eI7MuLWTuoCRRyyjm/2KXdwyLjAhye6TSyGAQ1O32V08VP
	 uh0sFrKr2O7vyq+nXdgkfhzyR5mSOF+WjtIMMCRcWi/Ljm2xze9hTK4VEM+XRPbv2K
	 s4ZwPwxI3i2td/8kDVWVieKB2Ez+/g1u1WccIayM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 077/201] media: venus: fix QCOM_MDT_LOADER dependency
Date: Fri, 15 May 2026 17:48:15 +0200
Message-ID: <20260515154700.200902191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit aa23c94cc433b145d1ce93820ecdfe16d8940e28 upstream.

When build-testined with CONFIG_QCOM_MDT_LOADER=m and VIDEO_QCOM_VENUS=y,
the kernel fails to link:

x86_64-linux-ld: drivers/media/platform/qcom/venus/firmware.o: in function `venus_boot':
firmware.c:(.text+0x1e3): undefined reference to `qcom_mdt_get_size'
firmware.c:(.text+0x25a): undefined reference to `qcom_mdt_load'
firmware.c:(.text+0x272): undefined reference to `qcom_mdt_load_no_init'

The problem is the conditional 'select' statement. Change this to
make the driver built-in here regardless of CONFIG_ARCH_QCOM,
same as for the similar IRIS driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Fixes: 0399b696f7f4 ("media: venus: fix compile-test build on non-qcom ARM platform")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/Kconfig
+++ b/drivers/media/platform/qcom/venus/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_QCOM_VENUS
 	depends on VIDEO_DEV && QCOM_SMEM
 	depends on (ARCH_QCOM && ARM64 && IOMMU_API) || COMPILE_TEST
 	select OF_DYNAMIC if ARCH_QCOM
-	select QCOM_MDT_LOADER if ARCH_QCOM
+	select QCOM_MDT_LOADER
 	select QCOM_SCM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV


