Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6F326056C;
	Tue, 11 Nov 2025 01:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823407; cv=none; b=fqamNBctG/L0oqoSa7YW9RBqzIuNKAsHRDVErLL9ja3i2EwTV49kL6B9hgQPDKSE2hcxrImdhCQoR0jFRM0R9wRJkfrRLNI4iAXOUTNnCKURDnK6REFFQUvMCNkaXRqyr+qWLqKqs0IMLWsQKPTxQhlVKus+B69jV28Xal6X+ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823407; c=relaxed/simple;
	bh=g4+LNxktTZO35wepfisFRZG1xGLkXv6VWpHy6zUECvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TopM4hlV1JcY2wGnPtnSVMCulXBfF+RIxXLYU0jsSlcQ25VIAypzSFHRKc0sj7X5WJLmcA72z6kPlmfisvJSNGEcUBsvsTaJWiGHbHAYqaF+I4LIeh5+bXqkC7oXIWXpZtbZBQpdQxeMMLr1CU2kuhiFUxJ/MDPwrvXzpYoaWYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgNXRJ8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgNXRJ8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F18C19422;
	Tue, 11 Nov 2025 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823407;
	bh=g4+LNxktTZO35wepfisFRZG1xGLkXv6VWpHy6zUECvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgNXRJ8u5O3xMDbqZ1wbjk3WvmiM095dUPdMZ0/7PwkXZplIDktIVxChXsWynS5tm
	 3eDnE7oV0h08RVu9RwUNKhg8ogIVyw6dGhH2xdLq7Z4tIGnExidtOHz0tag0M5DtjP
	 l0efi94AZU8Q4ej0JaCMOgPzZgSOa8KSV7LluXms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/565] tty: serial: Modify the use of dev_err_probe()
Date: Tue, 11 Nov 2025 09:41:37 +0900
Message-ID: <20251111004532.334746414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit 706c3c02eecd41dc675e9102b3719661cd3e30e2 ]

The dev_err_probe() doesn't do anything when error is '-ENOMEM'.
Make the following two changes:
(1) Replace -ENOMEM with -ENOSPC in max3100_probe().
(2) Just return -ENOMEM instead in max310x_probe().

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250819120927.607744-1-zhao.xichao@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 2 +-
 drivers/tty/serial/max310x.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index cde5f1c86353e..e0fc010a9b9ff 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -704,7 +704,7 @@ static int max3100_probe(struct spi_device *spi)
 			break;
 	if (i == MAX_MAX3100) {
 		mutex_unlock(&max3100s_lock);
-		return dev_err_probe(dev, -ENOMEM, "too many MAX3100 chips\n");
+		return dev_err_probe(dev, -ENOSPC, "too many MAX3100 chips\n");
 	}
 
 	max3100s[i] = kzalloc(sizeof(struct max3100_port), GFP_KERNEL);
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 2f8e3ea4fe128..9850446ae7037 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1266,8 +1266,7 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 	/* Alloc port structure */
 	s = devm_kzalloc(dev, struct_size(s, p, devtype->nr), GFP_KERNEL);
 	if (!s)
-		return dev_err_probe(dev, -ENOMEM,
-				     "Error allocating port structure\n");
+		return -ENOMEM;
 
 	/* Always ask for fixed clock rate from a property. */
 	device_property_read_u32(dev, "clock-frequency", &uartclk);
-- 
2.51.0



