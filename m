Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800726ED5D;
	Sun,  7 Jun 2026 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828320; cv=none; b=ANju7YbKBprEtcJ90umOBnq8WzEPZCac5I+RlM5Gfm+WYr5jnWAM1cFFqz6eR3sEzErAS/CeniMPl0l5uRp3ytYENBZmTb8sqiPEAr/tiz1OnWGV58E/IXjdF5a//US+a0+dM67adHobh9k4nXLllfn2cC/16aPnQ+cxt56PPq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828320; c=relaxed/simple;
	bh=MEwDV89wa+6WKl//+5sEEmV7Pu3M3W3FU0tG0f8Hw7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2E0lJ/hNeSHLshWuNiTfPvZE+UZieNaNZyRI2DjWJzepWyBHSOoLIZ/w8j9TE3DOF9YigAV2K+MCelU6tDAuTOC7ZlIXBL+/v0K4TL6asz1Mke18hyRoO2KTfPtdltOCfcsyNvIVp6zpk29vSBL5znbdNKO9/0KAOlfda1kt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcv3Q40U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcv3Q40U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FDF1F00893;
	Sun,  7 Jun 2026 10:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828319;
	bh=I0H3n6cFxMQxHk+h5MeD+spfvzoriae04ZSH7MQZXlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcv3Q40U++PfGF0bxA4M1cHAu8tuibh8Hu48LO5GtQLHAWz2MbhRq9l4cCmgKtXnj
	 SxFE4AO5k/I6MjwdCMtJynxPbbm1kSnKh4tiILOAwpP/8yAUmThq35qnEqSZUfEtJ5
	 NJno9HVP9oJzpymzo4g58JYBV+DrM55hi9IESQV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.0 172/332] gpio: shared: fix lockdep false positive by removing unneeded lock
Date: Sun,  7 Jun 2026 11:59:01 +0200
Message-ID: <20260607095734.374873660@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 9d7697fabbc72428f981c01ddbe0a6be0ce8b6fa upstream.

By the time gpio_device_teardown_shared() is called, the parent device
is gone from the global list of GPIO devices and all outstanding SRCU
read-side critical sections have completed. That means that no
concurrent gpio_find_and_request() can call
gpio_shared_add_proxy_lookup() for this device at this time. There's
also no risk of the parent device being re-bound to the driver before
the unbinding completes (including the child devices).

Lockdep produces a false-positive report about a possible circular
dependency as it doesn't know the ordering guarantee. Not taking the
ref->lock in gpio_device_teardown_shared() silences it and is safe to do.

Cc: stable@vger.kernel.org
Fixes: ea513dd3c066 ("gpio: shared: make locking more fine-grained")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260522-gpio-shared-deadlock-v1-2-76bca088f8c0@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-shared.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -605,8 +605,6 @@ void gpio_device_teardown_shared(struct
 			gpiod_free_commit(&gdev->descs[entry->offset]);
 
 		list_for_each_entry(ref, &entry->refs, list) {
-			guard(mutex)(&ref->lock);
-
 			if (ref->lookup) {
 				gpiod_remove_lookup_table(ref->lookup);
 				kfree(ref->lookup->table[0].key);


