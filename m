Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA5E17C7A2;
	Wed,  3 Jul 2024 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005403; cv=none; b=CvlxVwz+9n3lbAz1o86QmulJTdZQm+jaUI0tu9vy1FcGMQroAPoXo91H8FJoO5G1KMdkaNbLluQTtdyDGgv2w7EjdTJD+a5qFae/MXMW0NidTw34+1rCjDGfqvRKEHlJQtYzjUmACRRa0m7+hfo3RxjQIExKN0ibAKuVmapN6gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005403; c=relaxed/simple;
	bh=islndp2AaKR0P+l9DNOqk8RtEqxZJqq7DRneqxQQQhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTMqgsLxGgLzk0HxDBW+KqWF6hmwS6u8l3D5wHXpCTYvKf3F+Xhj9Qiq3NebhjeKNb80cm3e9jm77RS9prWuw7vO3zhXlpC1yAMmz9OGuZ8eHWhGVZwyYZia84p8I0geZIvJ1Nrw61XtTdvpSbkZWLGa/TyUlj8Wzf55KYYCfPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGsAY2TD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGsAY2TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88998C2BD10;
	Wed,  3 Jul 2024 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005402;
	bh=islndp2AaKR0P+l9DNOqk8RtEqxZJqq7DRneqxQQQhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGsAY2TDPjz/Myz3Diym7s3X8eQBd8EEFIANAgh+W0FlzVX4OGmfgGW7+/fM78Myk
	 d/zG8wHunsGbY1mZZLRD6HW3cpnV2l2FdVd23hivgr2JFfodlzRmofNNxKLe9LGKvY
	 7T5q4zCFuRVs5h/kXIclQ8JK7DVXUvOOfk2EHx7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/356] wifi: ath10k: fix QCOM_RPROC_COMMON dependency
Date: Wed,  3 Jul 2024 12:36:45 +0200
Message-ID: <20240703102915.710931308@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 21ae74e1bf18331ae5e279bd96304b3630828009 ]

If ath10k_snoc is built-in, while Qualcomm remoteprocs are built as
modules, compilation fails with:

/usr/bin/aarch64-linux-gnu-ld: drivers/net/wireless/ath/ath10k/snoc.o: in function `ath10k_modem_init':
drivers/net/wireless/ath/ath10k/snoc.c:1534: undefined reference to `qcom_register_ssr_notifier'
/usr/bin/aarch64-linux-gnu-ld: drivers/net/wireless/ath/ath10k/snoc.o: in function `ath10k_modem_deinit':
drivers/net/wireless/ath/ath10k/snoc.c:1551: undefined reference to `qcom_unregister_ssr_notifier'

Add corresponding dependency to ATH10K_SNOC Kconfig entry so that it's
built as module if QCOM_RPROC_COMMON is built as module too.

Fixes: 747ff7d3d742 ("ath10k: Don't always treat modem stop events as crashes")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240511-ath10k-snoc-dep-v1-1-9666e3af5c27@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -44,6 +44,7 @@ config ATH10K_SNOC
 	tristate "Qualcomm ath10k SNOC support"
 	depends on ATH10K
 	depends on ARCH_QCOM || COMPILE_TEST
+	depends on QCOM_RPROC_COMMON || QCOM_RPROC_COMMON=n
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS
 	help


