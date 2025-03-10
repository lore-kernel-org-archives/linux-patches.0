Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7D118DB24;
	Mon, 10 Mar 2025 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628236; cv=none; b=mYmeRdTGhETO9Y6uY4VrMg0tCTTaIAAGVMI54eKqyZcC6Phn/pf5tz2LyuVRqNQJz1/WKgq9q33l7sy8cLjfWrcUnyQ4B1n4VmGriPjkZ0eubXx0mrmXvmCGcoUgZso+fqsTT5O1a5j4HkhYj8hP5KFUpBWZdlkbh2Y2UXgah8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628236; c=relaxed/simple;
	bh=G4yLjX0M35rfqWSSl/crRbCODCiN6uIiPrxiaEp09O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYwRFsZBlWHWc4IAOBIiIbYnTsja38s3jcnby7P1VPgXO/cSQM6aHt+zz09DwkqraYB6fwG+Zhk2V2XvjFAJgABTBeXa0NSsavCwmIVoBkLnbgSygM4Q9VWTeWOHJ6NvJISCUW8BIgnTVK3TQvodOejSrtrITvgrb73Pr12a5X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXKQV6xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXKQV6xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBD2C4CEE5;
	Mon, 10 Mar 2025 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628236;
	bh=G4yLjX0M35rfqWSSl/crRbCODCiN6uIiPrxiaEp09O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXKQV6xuo5siK9qZGwXhhnXGIz03UxjmkndgIS0EgEj6ykHmLp56f4gn6N2VmW/xn
	 IN0VJMg2F7xW7JSvBhtp5fLc+fKyLoAnTjq55GMnTK6J6ZyyNC8Y/HXxtWkeeQ6FOO
	 RY7MKeLRXS3rDfBQp5VmXjm0P3G6gZKsHvi0J9JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <boddah8794@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 103/145] usb: typec: ucsi: increase timeout for PPM reset operations
Date: Mon, 10 Mar 2025 18:06:37 +0100
Message-ID: <20250310170438.921265809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -25,7 +25,7 @@
  * difficult to estimate the time it takes for the system to process the command
  * before it is actually passed to the PPM.
  */
-#define UCSI_TIMEOUT_MS		5000
+#define UCSI_TIMEOUT_MS		10000
 
 /*
  * UCSI_SWAP_TIMEOUT_MS - Timeout for role swap requests


