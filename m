Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659B23438BE;
	Sat, 12 Sep 2026 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227111; cv=none; b=izFoUFJZn7OvyfjcpW39Zv1jXvu7zS+M8Lmhi4VeWcf9gzio+tQlmMYggj3cHqbN5tqqYD+Zs7o00gMt0EDrAz2Me0LrBqteoIR5fMhlniQDP7B2RTF4jouFqdvaOkpBsUq/pdp2vPBpSFne6OqafYMMWvTX+FykRj/zEHgcJoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227111; c=relaxed/simple;
	bh=Fu+pI9TB9DugAqHgG16pu6SFCTzx730QqggEBfNDdFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJpLrFvAlJwguxkmHkjxSGLj+GgRXVU5fUMUjXoyvyfykBpbLwdPFYdQCb7S4ryaDEEGUs3dP0RX4SmwtKNQ9xn14BfK/PSOSxZbSXCHUeEhsQw/M5HrsSaLxtsZemFpca5mqVpCUMceAN/3mNowWtcxzQAyrc7YzxLJ9QWTt1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heAEGBCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heAEGBCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673D11F000FF;
	Sat, 12 Sep 2026 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227110;
	bh=UOX/82ytrS/Xeur5L0fxfU707lDW/jw4PBYg7lcSGrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heAEGBCFdvm3dloY2bIbfxB1941UOT1fkCVjeQbJJp8kGeg/nzmPnfW96w4a4eUTm
	 BN0+aII942bE5PSud9jP5ZSELiNRm+x9GHiZIU/H1wh0h2qSNr4UoFjyjCAvD2e/Fp
	 k/PsTU1kD7ktVEtHZv75hQ7p6eW5U6uSXEAnVbuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0115/1191] Bluetooth: hci_h5: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:47:23 +0200
Message-ID: <20260912065550.772789944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -983,8 +983,10 @@ static void h5_btrtl_open(struct h5 *h5)
 
 static void h5_btrtl_close(struct h5 *h5)
 {
-	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
+		pm_runtime_dont_use_autosuspend(&h5->hu->serdev->dev);
 		pm_runtime_disable(&h5->hu->serdev->dev);
+	}
 
 	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
 	gpiod_set_value_cansleep(h5->enable_gpio, 0);


