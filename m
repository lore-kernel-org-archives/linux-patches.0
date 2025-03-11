Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A5225EFB4;
	Tue, 11 Mar 2025 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707563; cv=none; b=B7U3j8/PN+4W8MawPRQ8Z/S616MPX1NoFwEEDWSK+FsH4YJgl6f/O279Yuo0ae5wmhFtaCjs6cw9Zy7Q6OUHtJLT5LT41N8QAebXhA6PW9E+s/6EhI01nQgIZHUG/BAsq8Yyy+lWzFTyNs/SgUuLQbPwkiZvwKbUez0NO03NT38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707563; c=relaxed/simple;
	bh=hjwbALbaSPJdaIVjtnd/F8jwjwz+ZGekAd5eI8jJnpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx6pIQ+pQpgo1UrnD6DI9JFlMEKqpQMmNUyTwKH13NIUYiE/i6FBxA0Uo/QJUhfmYJJ8D9d6lT8whs1Topf8MyFW7nRRAgP2E5fV5QtNM+J3wWAF3wKZGzRCeIVDyh24WcHhrXJw6MXHJbK8HTYJqg7fEqwp2uSQjX6D8P1VvlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGfkM2/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGfkM2/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555ECC4CEE9;
	Tue, 11 Mar 2025 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707563;
	bh=hjwbALbaSPJdaIVjtnd/F8jwjwz+ZGekAd5eI8jJnpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGfkM2/VKr2pxgCpjtinZr1qK8R0f3vBHm7DZPjyYsqybSiuf60kF9oHk7XUls5qr
	 rkRi+LF9xha7tn1bGS3vHMMw184ILJY9blMG+otCj5XxjXegqevmCkzJN06GaLU2FC
	 1qVI4cm1Z3TPl+lXgECSi8YhBrJAm1liGrbQc65k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <boddah8794@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 431/462] usb: typec: ucsi: increase timeout for PPM reset operations
Date: Tue, 11 Mar 2025 16:01:37 +0100
Message-ID: <20250311145815.361390948@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


