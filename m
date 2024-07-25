Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFDC199E9F;
	Thu, 25 Jul 2024 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918527; cv=none; b=qB/VyffwhHtddN/2XHZ8JDI7hEMGZM1yN/Ujc3YBwpnIcDxMXJw9JewYCHUQ+AxeGV4GTrgMr7TGofpgdAZukvkyJyV2wv8twiSdo4EF8b9ef/0S0PE6GJRTct+l6qDc6/UoRbWPVrfbzZGgn3Lg2WJfgD6pHVZF1Fo5eztAIGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918527; c=relaxed/simple;
	bh=B9NVS+hBtE4w9+dawC2+dt0Vhit69XaKkLn8awiWM0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LStEqp8WbX62AfVBF4jnlkL6EtrtdIJCUc6GyiqINUtd8Mf831GxJEC8g80nmQBHrYDzxBJA7eqvxeRPG5LT8Hb9NuO4kNhYZJqXhkpPVxAVjanYMftF6mNUxT6U/1DfYtEVDw8UpkWHwxrQPFyRzDB7cTHVl2YbwJ4YoKkj0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDf3fNHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDf3fNHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8989C116B1;
	Thu, 25 Jul 2024 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918527;
	bh=B9NVS+hBtE4w9+dawC2+dt0Vhit69XaKkLn8awiWM0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDf3fNHqbyBpgzaitTHTg5jVZywAJWkHkrhifj7i75Rnr5Uh4RIyQ31LHAsE4Jw3M
	 oYwan15n8uU/rhaiJ3bZhRXdplzLUI6Io1STmgNkP9q8df3Psh15TW14KFB4KkTiOO
	 oUPgZvLQZSwHFQXQ+ViJGRGv9Tx9a7ZzB9jbYMcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/43] ACPI: EC: Abort address space access upon error
Date: Thu, 25 Jul 2024 16:36:27 +0200
Message-ID: <20240725142730.639142752@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f6f172dc6a6d7775b2df6adfd1350700e9a847ec ]

When a multi-byte address space access is requested, acpi_ec_read()/
acpi_ec_write() is being called multiple times.

Abort such operations if a single call to acpi_ec_read() /
acpi_ec_write() fails, as the data read from / written to the EC
might be incomplete.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index c7baccd47b89f..43a8941b6743d 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1310,10 +1310,13 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_enable(ec);
 
-	for (i = 0; i < bytes; ++i, ++address, ++value)
+	for (i = 0; i < bytes; ++i, ++address, ++value) {
 		result = (function == ACPI_READ) ?
 			acpi_ec_read(ec, address, value) :
 			acpi_ec_write(ec, address, *value);
+		if (result < 0)
+			break;
+	}
 
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_disable(ec);
-- 
2.43.0



