Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6504E533B;
	Fri,  9 Oct 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555790; cv=none; b=PaVKkJNtrzBcBCJPD/WMHTxJJYaAIOOck/YW+loc53fIvNaXaFe50q1SbpHzUZNVZRz/b6t6TqANWjIUIPuhLS1jTxZB17XsxqH1vyeOjNRmb587dFW32If9XrnmHO3fmhhNjhVpT1JeTYi02wbYACkT+CAmpntsGKZOBplDISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555790; c=relaxed/simple;
	bh=u2/OPRfJOeeg31KPsRzR5bPkyx8zala3oo4He85v/6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP9fIruOn7E3uzKVv14LqzClWukM+oxMm/yKHx8HOkz+F7Nc3NkVlm26DLRyZP1A1Cyp2bLWRkhsnH19Cbdp6zGGxKyz/IbMCtHyUcKtbKKiH2Ghb9RWGocZgbfiqpM6FaYbs811SK+xsGR/g6ZBgWOiESQx1BuFBcaP05POwyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCO8e5Ae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCO8e5Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB2F1F000FF;
	Fri,  9 Oct 2026 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555788;
	bh=7xMr5mvKL6CX4yCA+/p0bPdrxbuMpCHL1DR1sUiy/2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCO8e5AePdtsLaJ/9C7pSnvE7mbZU4riO5xbQql/k+A/o3XrwBqLra3HfwQZb2Hsn
	 TvD9ARsvZclOD/ucNuIEOfYdRkTPEj7FUdQotUEJhlmQJ5yuIPIy3d2+JS1Pk+ynO2
	 XNQSsUV1pbkUHnXnkafR4/f9v3ibHB9+HHuJhMqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 061/428] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Fri,  9 Oct 2026 16:06:38 +0200
Message-ID: <20261009140947.480496482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit a8b8881d0c1aff544fae190469d86db7b07f43a9 upstream.

pm_runtime_get_sync() keeps the runtime PM usage counter elevated even
when it returns an error, so the reference taken at the beginning of
wlcore_remove() has to be dropped on every exit path. When the device
was not initialized the function returned early without doing so,
leaking the reference.

Release it with pm_runtime_put_noidle() as done on the other early error
paths of this driver.

Fixes: fa2648a34e73f ("wlcore: Add support for runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917122325.2150910-1-vulab@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6811,8 +6811,10 @@ void wlcore_remove(struct platform_devic
 
 	if (pdev_data->family && pdev_data->family->nvs_name)
 		wait_for_completion(&wl->nvs_loading_complete);
-	if (!wl->initialized)
+	if (!wl->initialized) {
+		pm_runtime_put_noidle(wl->dev);
 		return;
+	}
 
 	if (wl->wakeirq >= 0) {
 		dev_pm_clear_wake_irq(wl->dev);


