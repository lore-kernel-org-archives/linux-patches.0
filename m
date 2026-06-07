Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03A2D3A69;
	Sun,  7 Jun 2026 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828687; cv=none; b=C2fsuKM9kXd4TFQTFQ2QeNw4XK2lgGYQ49LjEO9FaG0AmLqJj8CfaEaiSQJkJiAjy9rqX7W4o5QxpbyUWNCWDlS0bhkYxO5c9T4JxAVBmLTeu1qhpwR2e2asOVjA0Qi2Qn7ccNkPX6r6d1H5/NUwDTpKEJkTaL2Q4RDgx/jkVvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828687; c=relaxed/simple;
	bh=3nJruFdg9dxWHu4nWqJKs7BmukAgFE7gdlQoGm8dc68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT7UkvBMDQ7sPILfPcGOteplhMnvykCCaPjKo+t6DYVwDXN+EiPH8ga1G1B8Vx5HTyojqvl3wjaqdRdo6XRjIOL1VEhguflLUYHZl/mGXIH9AYXFmO74ofaGw3lg0HYwDyNXWs+a/QYQ9aN85zfsxGWWBd2ptPYfB/xhgl6tPD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flLwnYMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flLwnYMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75E71F00893;
	Sun,  7 Jun 2026 10:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828686;
	bh=yPfFr8nxWIuOjTzGneXu0E7LsenZkyx9zN+bXJMYGLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flLwnYMzd9y1TL/pjqAlFHLiXbkE7te7C0Ht57OddZP0HkZqW4L3Ung2bkREjV7J9
	 6nqFyeBCpYY/+HSKVJ+Gp60tNc0RrXQaNhKaWgpXIY7TMDeAOEbKw4LUoC9ZQJuIRX
	 T2tGhYvKVyWwVhrHInqOkhXg+8mcb84Zx7cC1YTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 7.0 203/332] usb: cdns3: plat: fix unbalanced pm_runtime_forbid() call permanently leaks the runtime PM usage counter across bind/unbind cycles
Date: Sun,  7 Jun 2026 11:59:32 +0200
Message-ID: <20260607095735.514676205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Peter Chen <peter.chen@cixtech.com>

commit ae6f3b82324e4f39ad8443c9020787e6fc889637 upstream.

Call pm_runtime_allow(dev) conditionally at cdns3_plat_remove.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-3-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -186,6 +186,9 @@ static void cdns3_plat_remove(struct pla
 	struct device *dev = cdns->dev;
 
 	pm_runtime_get_sync(dev);
+	if (!(cdns->pdata && (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)))
+		pm_runtime_allow(dev);
+
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 	cdns_remove(cdns);


