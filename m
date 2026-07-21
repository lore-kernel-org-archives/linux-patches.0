Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73F047127A;
	Tue, 21 Jul 2026 18:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659418; cv=none; b=fAXjPuKjKA/zunu2hg3MY9YD94U8B3o/BhzUfsns00uLWDiwGSgz8FlYaCE3hPSLwc8YYxdSqD5hZAKzoWJ8SuGCKD2hWDXTmvidDyCYHjjsL2T1amUSHp5AIroXcf10hD/8JOv8zgPYEvzo7I0dlO8tZTR3hFxzNBSV/cPDjWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659418; c=relaxed/simple;
	bh=ultzo16wk4sEClwt7uWuzIW2Zsl9LyUCJ11zclIC6B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHTtVm0XcWkWDT6dMFI/tfbyEgIFnTfGeF1wy3Hwp6ejDJtioyWCtpLvMRR9ML/bvkH9DPmclc6oEzh0oHQxts6jjsUchXEIDrKU9FENerjG1Olf6v7jhNPN2Wv7lmT+TjrCMor0T+Y+lzTcw+FsK7QS+MPDF6WU7OSaT4JEiTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qIwJknt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qIwJknt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6B11F000E9;
	Tue, 21 Jul 2026 18:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659417;
	bh=O1tjESXO+Dd6yR18f96bePjj2rAOFS2LrcVJEyXpcHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qIwJkntLfWMonotM/w6k2D13DZYXfsmA73EpUUr8jd80OiFZdXrbMG8IAEL60W77
	 Wfhwz2fhGirScTRcXFtDe0z3xCj36l4VnG9ymzHVp4fICyAF++PVMV82PC1CuqN/KT
	 qhuPJy2udcAgrd376MPFgaoCch50R7BR1/JGvylY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1512/1611] mmc: sdhci-esdhc-imx: use pm_runtime_resume_and_get() in suspend
Date: Tue, 21 Jul 2026 17:27:08 +0200
Message-ID: <20260721152549.452291695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 8da5930144712412d85e7f868693d96ec5c2018c upstream.

Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() to
simplify error handling. pm_runtime_resume_and_get() automatically
drops the usage counter on failure, avoiding the need for a separate
pm_runtime_put_noidle() call. If it fails, the device is unclocked and
accessing hardware registers would cause a kernel panic, so return the
error immediately.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2038,7 +2038,9 @@ static int sdhci_esdhc_suspend(struct de
 	 * 2, make sure the pm_runtime_force_resume() in sdhci_esdhc_resume() really
 	 *    invoke its ->runtime_resume callback (needs_force_resume = 1).
 	 */
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret)
+		return ret;
 
 	if ((imx_data->socdata->flags & ESDHC_FLAG_STATE_LOST_IN_LPMODE) &&
 		(host->tuning_mode != SDHCI_TUNING_MODE_1)) {


