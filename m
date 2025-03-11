Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC11BD00C;
	Tue, 11 Mar 2025 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706260; cv=none; b=jwSqF90BtU0Yld82TNZdRK7UPe+g06xmkUgabukDBFYD9Gw7hM5vYHoGxlxVYr1F6yzl85viMjrfe+qf/E9UeKXaIjGZkmt6eMZ/D02DLgDqxTFwAA+WYqs6w3iAd201YRLaTzU9ZviRklyKgv+2+zpA5IbenT9l76oocSdcJvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706260; c=relaxed/simple;
	bh=i5xMx2i0cv5AHmxPBhn2dB1V87/zj+Ay56z9s60mpwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC9LfMH4CZgRzPA6yAPJGIq267TH/bbyTLIl5vXEkGcKbWRMm0KkVqObcSdC12kQj5DnR8q41C6JyPhEvmNvKQf1vUuPBtKrVwsbbLnzrltzvaSDjEhNV56Txt3LWS1A806PrBWyH7vg+sPZi6wuvGIUdWLgzJ6ZPwajjJEffmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1g4bYDDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1g4bYDDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACF6C4CEE9;
	Tue, 11 Mar 2025 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706260;
	bh=i5xMx2i0cv5AHmxPBhn2dB1V87/zj+Ay56z9s60mpwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1g4bYDDvzAcxR8XyBIV33AgvNMMCE5OybSqVqzmj2WKjlySUCOEE8IYJgBIRbmYJS
	 Ln8EcMjC/J0qfXAqKVYEhnJEkFCgr8hVhXR3qhzs5fAZT30c285WpeGGBqCXkVXoOd
	 tCQ7xdc1mUSnAFktAgr/KioJrZRc5VEwYoND5lF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <boddah8794@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.4 317/328] usb: typec: ucsi: increase timeout for PPM reset operations
Date: Tue, 11 Mar 2025 16:01:27 +0100
Message-ID: <20250311145727.501272953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <boddah8794@gmail.com>

commit bf4f9ae1cb08ccaafbe6874be6c46f59b83ae778 upstream.

It is observed that on some systems an initial PPM reset during the boot
phase can trigger a timeout:

[    6.482546] ucsi_acpi USBC000:00: failed to reset PPM!
[    6.482551] ucsi_acpi USBC000:00: error -ETIMEDOUT: PPM init failed

Still, increasing the timeout value, albeit being the most straightforward
solution, eliminates the problem: the initial PPM reset may take up to
~8000-10000ms on some Lenovo laptops. When it is reset after the above
period of time (or even if ucsi_reset_ppm() is not called overall), UCSI
works as expected.

Moreover, if the ucsi_acpi module is loaded/unloaded manually after the
system has booted, reading the CCI values and resetting the PPM works
perfectly, without any timeout. Thus it's only a boot-time issue.

The reason for this behavior is not clear but it may be the consequence
of some tricks that the firmware performs or be an actual firmware bug.
As a workaround, increase the timeout to avoid failing the UCSI
initialization prematurely.

Fixes: b1b59e16075f ("usb: typec: ucsi: Increase command completion timeout value")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <boddah8794@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250217105442.113486-3-boddah8794@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -28,7 +28,7 @@
  * difficult to estimate the time it takes for the system to process the command
  * before it is actually passed to the PPM.
  */
-#define UCSI_TIMEOUT_MS		5000
+#define UCSI_TIMEOUT_MS		10000
 
 /*
  * UCSI_SWAP_TIMEOUT_MS - Timeout for role swap requests


