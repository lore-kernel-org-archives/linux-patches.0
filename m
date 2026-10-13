Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F02184;
	Tue, 13 Oct 2026 12:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894820; cv=none; b=hOdWo7uAf/k6mKKpGouJmrWsOiFivXqAwMbM1itTsTLVpgpXDlDhpekZzEJ+YpQ8f0j0UWw6uNWgLWI2E1rIXKF+mCmu84SsBPiRNJRYfv/qgo9JWnGA8yOjYHEnXklwKiGE7gyeOCdbYulokTC8tdXSqSU1lE1kTw8IO4sKrGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894820; c=relaxed/simple;
	bh=jErbDRg5HpyA537Jlnvgha7F8dmWgL/r8lHTwdA7x7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NldYqtXEKe0Zb35gcK6qI6qHRzB2r+jmFH1FT+jELa+LJ6cIkeB13mYNhKkhoboZ43pPfsBb9SPMnkuuc2UdvuALYEHawR27brPerzKbzZTBHO1WqBSdFQLhfLgiX9DX8sHFoR6oHg9P3IbvUn5GnYZ/YvoHHYurQ+9F71V+QUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h++BNl2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h++BNl2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4281F000FF;
	Tue, 13 Oct 2026 12:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894819;
	bh=1mIerYskdwJGNI/WASEEbA0U47m42va94Ze6nBz1alI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h++BNl2StinodH1Ah21b93Hzm2obNzX/dRQm1LMT/EPrspTS5qBRquATEuMl3RoZY
	 708AtQ/s5H013EJ21tykZh9lXeo/GQFftq2uwielYiL+oo2fTmU/Iui/wnaJ+rIXHx
	 EWDK4vyZQYDXl6qHhOZKDoXE3j/9dtXXJp2/vo60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 040/497] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Tue, 13 Oct 2026 13:33:27 +0200
Message-ID: <20261013112908.841752670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6831,8 +6831,10 @@ void wlcore_remove(struct platform_devic
 
 	if (pdev_data->family && pdev_data->family->nvs_name)
 		wait_for_completion(&wl->nvs_loading_complete);
-	if (!wl->initialized)
+	if (!wl->initialized) {
+		pm_runtime_put_noidle(wl->dev);
 		return;
+	}
 
 	if (wl->wakeirq >= 0) {
 		dev_pm_clear_wake_irq(wl->dev);


