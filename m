Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21D933993;
	Sat, 12 Sep 2026 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232863; cv=none; b=CBLchlb0grve+d+nEecsoIOeSXeIuzEb5PgZfMrf6CjdxbC/OTwCBqVFzpUldjPT2uwHcIToEgLSdeqdJyOlwd8jQqRVs/k6MEMMxXq6K6ZZ3lJpmFZzY65KoeWyYRNlTz3M1i41ZFsnCbMUuLhY7z76TifkKPC7fKAGdUF7g4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232863; c=relaxed/simple;
	bh=0ncR02q1469umx3NzgZGX2zoCsA/x7qFbC2yDjrE+Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT0FCd1CTfJI1LNjCfcWbUpy7389gxJeEdCKmDGJK0XSUmd466Gq2KVYqYKXcFXhBYaVJFK/XGt9dukCggp0YW4VviaxNddA6LwZsWJ/MDadqOM/C52Xh+JwCwtNO4AOTBncwXmdjc/IAz/RPQK6o+otfWBCyY9PHVpD+QZkdvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cw0qwuGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cw0qwuGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852961F000FF;
	Sat, 12 Sep 2026 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232861;
	bh=teYC/W7a+qLm7F6h3GFGXPlk7EQ32kGXrWvbQj6M8Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cw0qwuGYLbZV6+798edBdBR0Sr5ocgzqisM87Ga+79W1gzJB5IAVAHjoO0lJt+zFv
	 uhXLBkQsAMdXdto0Sk7LNvUVigmz90W05uEkFmc+JU64S0QXwcgntnXKiTMrJhu7ZT
	 2NjtoFuqLuqkJNCudxa5PeCPwE8TFezO8ocjYzz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 097/935] Bluetooth: hci_h5: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:52:07 +0200
Message-ID: <20260912065529.047522503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -981,8 +981,10 @@ static void h5_btrtl_open(struct h5 *h5)
 
 static void h5_btrtl_close(struct h5 *h5)
 {
-	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
+		pm_runtime_dont_use_autosuspend(&h5->hu->serdev->dev);
 		pm_runtime_disable(&h5->hu->serdev->dev);
+	}
 
 	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
 	gpiod_set_value_cansleep(h5->enable_gpio, 0);


