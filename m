Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207E647DFBF;
	Sat, 12 Sep 2026 13:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220194; cv=none; b=IYDhKYiTDa05+bvSGFaxq/BgQyPnjIKruiRp+RH/kTi1g96XhXMXjDkcRDzyS0xgYUOjno6t391QKZN1TSjsqLf05b2joAq4XseBuSkpTtrUHogd2Lah/xNRIPngiFjF9RuNe1HGFUHM9MJfK2M5rLq+4ImV9GWPs2JdbUtuZGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220194; c=relaxed/simple;
	bh=Un85N9SitUQ+h4A1k2Zqcdf8kbqsrEnxek3Lo2eAF74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQQyG59CV6JgAUXgzokojJ46M539Wo5+2d0+/wnLghc3fZAlaWQrkwuJ4iHjSo0blfCJw2QtDDuJ02SHpaFBs0U3XYYFqUUwu88CfJAupgNzsRKntU09GvGFGM0q+3jDfbowvpiDCRE0PjsSukMrJRjqxvCdxZsDJjUc0nrfMuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kilqbJas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kilqbJas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB51F000FF;
	Sat, 12 Sep 2026 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220193;
	bh=JfbaOe0BJcZxRd1bCd3fQIG9zqRkK/y/vm9hw0UhqVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kilqbJasGTd3UIRLMAFrXO0IVBa+t34Y7MAddJg+OjQuZ2CaxW/1bLEsx82qOOFzo
	 jbhFaI9sw6SJ66B54uFKGgTXT4/wv0q3uamWX+yd/EQIuXyR1N3yD5XxYWjonk45ns
	 ReQO2gBTWdMYJovJr27k3YiQzXsekdYfjuZRqZyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0128/1424] Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:42:40 +0200
Message-ID: <20260912065610.165776943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit dc6b7c771a963e20aedf4a21ffa22543b9837ba8 upstream.

bcm_request_irq() calls pm_runtime_use_autosuspend(), but bcm_close()
does not call the matching pm_runtime_dont_use_autosuspend() when
tearing down runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: e88ab30d3669 ("Bluetooth: hci_bcm: Add suspend/resume runtime PM functions")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -548,6 +548,7 @@ static int bcm_close(struct hci_uart *hu
 		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
+			pm_runtime_dont_use_autosuspend(bdev->dev);
 			pm_runtime_disable(bdev->dev);
 		}
 


