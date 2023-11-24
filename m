Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3EA34189;
	Fri, 24 Nov 2023 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM5Y2Ro6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7E2C433C8;
	Fri, 24 Nov 2023 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852842;
	bh=BNjgYGveehWQX3kQK7xr4nEqwdbhv7x6f6frhguvK3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM5Y2Ro6GbitRNjbWxHs5ZqLT8GPBUeKXv3TTZeN6QW/6NMGk0J6uvGxTlpXMuA2E
	 MCPT6myn3xWI4CTP4/Gd5wrSfDsJ22cjc07PSRiVpZXYNcFHadVAv7pnZ4VBmRtJwt
	 3TdL3e2Q3QhISFfpUWFkxkBPG+gcbSjMY/s2vr+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Berman <quic_eberman@quicinc.com>,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 120/193] firmware: qcom_scm: use 64-bit calling convention only when client is 64-bit
Date: Fri, 24 Nov 2023 17:54:07 +0000
Message-ID: <20231124171952.036204854@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>

commit 3337a6fea25370d3d244ec6bb38c71ee86fcf837 upstream.

Per the "SMC calling convention specification", the 64-bit calling
convention can only be used when the client is 64-bit. Whereas the
32-bit calling convention can be used by either a 32-bit or a 64-bit
client.

Currently during SCM probe, irrespective of the client, 64-bit calling
convention is made, which is incorrect and may lead to the undefined
behaviour when the client is 32-bit. Let's fix it.

Cc: stable@vger.kernel.org
Fixes: 9a434cee773a ("firmware: qcom_scm: Dynamically support SMCCC and legacy conventions")
Reviewed-By: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Link: https://lore.kernel.org/r/20230925-scm-v3-1-8790dff6a749@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom_scm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -137,6 +137,12 @@ static enum qcom_scm_convention __get_co
 		return qcom_scm_convention;
 
 	/*
+	 * Per the "SMC calling convention specification", the 64-bit calling
+	 * convention can only be used when the client is 64-bit, otherwise
+	 * system will encounter the undefined behaviour.
+	 */
+#if IS_ENABLED(CONFIG_ARM64)
+	/*
 	 * Device isn't required as there is only one argument - no device
 	 * needed to dma_map_single to secure world
 	 */
@@ -156,6 +162,7 @@ static enum qcom_scm_convention __get_co
 		forced = true;
 		goto found;
 	}
+#endif
 
 	probed_convention = SMC_CONVENTION_ARM_32;
 	ret = __scm_smc_call(NULL, &desc, probed_convention, &res, true);


