Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9604B1411CD;
	Thu, 13 Jun 2024 11:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279528; cv=none; b=W6dNjv9dveHyWWRAe1OoVpaR7w54siNLbR9UTJmwgF/RF3Ea4GUrgXIxLRVhelbDheJHG7f4K7vBtJXhSb4UvKxczBgzYx5Z0IzefcKVbAMxJQHcdgZsS67tuAruVTcPorNeqzVdNd5OVwcRLR+KXUpRT9IkDE4Osc1TPeets+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279528; c=relaxed/simple;
	bh=LiZgHOPKozFcwCn1orjTTmx+E+2Xr/TQq8f5p1V7vG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bL3wN+diSYn38QU/SYAXfu5VjD0bkLUddxE0WL01AkhzbrwBx2VptlGfiJwDwQpJ/ugZyforqXmE1S6o3+3QhxHXD3BuqVmJ9ODXBvYZClC1ws3zpENTMduvoG9s+Z6TfKYBpliGQY1+hxI15UW3+KieldoXJbdaw+SEgPm2rlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCHqcT27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCHqcT27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184ABC2BBFC;
	Thu, 13 Jun 2024 11:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279528;
	bh=LiZgHOPKozFcwCn1orjTTmx+E+2Xr/TQq8f5p1V7vG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCHqcT27qTRz3cOGMFrpQGGpyNuiJ6+i8JLygHGVlnG8t+4viIVruGkNObUwFXcwu
	 omp4PIudRjD6ibbnF9r2mRBJMNJjvrwHCJ2ngPUdZyGQHT4L5QWBV6VRIizN5cBTVa
	 X+Qbplu97aje6iprA80Cf1bVGLxSt5d0Kc0KcoVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.9 107/157] wifi: ath10k: fix QCOM_RPROC_COMMON dependency
Date: Thu, 13 Jun 2024 13:33:52 +0200
Message-ID: <20240613113231.559120584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 21ae74e1bf18331ae5e279bd96304b3630828009 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -45,6 +45,7 @@ config ATH10K_SNOC
 	depends on ATH10K
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on QCOM_SMEM
+	depends on QCOM_RPROC_COMMON || QCOM_RPROC_COMMON=n
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS
 	help


