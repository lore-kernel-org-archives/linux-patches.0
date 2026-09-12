Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1186347F2F9;
	Sat, 12 Sep 2026 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220234; cv=none; b=NzIUVhOW5Th1kIC/kmsCJE6C01HgQqbF2ABhsHRyY7LT896OT1qtearlLn+7i/cvmS45T04knvM2Ck7iRlg9qm47vYyZwdObkvRQjtFCMmvAkQa5aY5puy/nLneP/hIv+C/dj/cyolGlPkaL7GWXpst5wuhmdGWPdZFsyTPqeco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220234; c=relaxed/simple;
	bh=2L+xY4xU0XpjHg4+S+KlormbT0iapVLlQrrXOaXdhw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOH4gBChWOSr+ocCJwmh9ZBbAldsp3q4hn8Ufc1DR3hJu6btdRo7yKjG8UpPF84QCqJexpq+vw7lMbZ45+9YG9acighTsk0zSfhOEtxDTjACwNiDF1+78VlcnSuc9AQgmKrkES47VcsgtGL+A1RV7pE+bXo3/TI7Vr4YF29Qfuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r87y6vUW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r87y6vUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C561F000FF;
	Sat, 12 Sep 2026 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220233;
	bh=lP/erpBMGr0/4/87/qPPVVLK3E200G7EBeGwyyaiF5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r87y6vUWpoyvjKVqm40NAxuoaWjxpSpK5wm0Bo0qVZl7uxoEQwpduOa0Tq8ueLV+e
	 ehcj4PyImtiCOXLQe8sz1ZNyzUEv+GjsCfHUUb+fF2I+4rIKMqj5OyqjfQSTJPlMz2
	 hyb+O83WMTqW7Cs1P2gHMnvW3ixsyH3uRocLGa6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0135/1424] Bluetooth: hci_h5: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:42:47 +0200
Message-ID: <20260912065610.322996518@linuxfoundation.org>
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

commit 853a92b97ca547a7ddd9790ff90651b2fd943498 upstream.

h5_btrtl_open() calls pm_runtime_use_autosuspend(), but
h5_btrtl_close() does not call the matching
pm_runtime_dont_use_autosuspend() when tearing down runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: d9dd833cf6d2 ("Bluetooth: hci_h5: Add runtime suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_h5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -987,8 +987,10 @@ static void h5_btrtl_open(struct h5 *h5)
 
 static void h5_btrtl_close(struct h5 *h5)
 {
-	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
+		pm_runtime_dont_use_autosuspend(&h5->hu->serdev->dev);
 		pm_runtime_disable(&h5->hu->serdev->dev);
+	}
 
 	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
 	gpiod_set_value_cansleep(h5->enable_gpio, 0);


