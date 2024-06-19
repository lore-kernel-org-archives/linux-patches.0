Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66EA14F111;
	Wed, 19 Jun 2024 13:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803710; cv=none; b=A8ay4j6Brfj1F1YfXBmkruKrvHhVtl/1qoNJDDfN/kHdIM61YoThFIiV+zn1nzlhVqHArqGHUCQLpGM2WMrC9NLdBh4I1nQb7dcnPOP+I0lrfd6IoDEwKLb0ZbrBGiVUwTcsEI21jsGCUDlNcu1UKg03QH6KMuQoTPw08uCsI7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803710; c=relaxed/simple;
	bh=S3zw0VwKsJ7UaRoNjXjhCEBRqWosNtvnXY5SQcSrRmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne2uSrqiruGc/6UjoGsV3vFsHJV0pMecKQ0MU6w5iTqSmauUXQtM60GB8CvWIVKDeIItkj0evJq6NyYD2rS4nCt7wgxGYXfptaQ2MwCquEilaOlmTfjV8LvjOZcIn/lNjOPOTCAeWXrXKJPGRZvd5+BhuiFKZPczta6oONk2ukY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2lBfKlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2lBfKlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA26CC32786;
	Wed, 19 Jun 2024 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803710;
	bh=S3zw0VwKsJ7UaRoNjXjhCEBRqWosNtvnXY5SQcSrRmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2lBfKlHGK2Y1aSMkmOZok32MP1YxB2oB9aKU7xz7W5s5k95C7/+KPXGUAkEjQMf5
	 p7ZNVhAocuyyy6eMNVfWXa824yhqyXAF1ZqGT4y/1yyixOjRaoPfWv/8KPlOBrQOSD
	 fbIvY85Ercq+a0vVYYPLPKN0Xv0ldEIqcdOyVunw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/217] wifi: ath10k: fix QCOM_RPROC_COMMON dependency
Date: Wed, 19 Jun 2024 14:55:21 +0200
Message-ID: <20240619125559.697172694@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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


