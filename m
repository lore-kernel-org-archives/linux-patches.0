Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD1815820C;
	Tue, 11 Mar 2025 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706205; cv=none; b=I+YK2zSbf6g4DiVrEt4HoCYh1bAi2yQ9DFdCrbf5+Dy9uo6V5+HUv5VkiJzUns3ckRxCLbihHo8BgV9mvTyvWKsy67U1XN8oxdHgrHimmcHcov7jfE4zPKv8ueXdTZyv9HGGaNLr0RaCeYfptjQLLzbZT4euM1NRon5A3149jsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706205; c=relaxed/simple;
	bh=Ph+ubgudyPSCPwmkFZidSH9W5kIBWQ9iaAzKbIGYuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNWW1iEOdhShw4WInrqw3pE8sju/3Fxt4Jmvaj6WqkBYcKlfgM+rMeW+cnDG1PUAy+ouZIDaT8hHFy970FFwkKA8cCzyrvii0yACkol2DkQbcvf1UGzkAmUMmhRdI1bBoqKrQzgBXyLydVKB1jlfhX3i9H1m1QjgiILu1pOjAms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bp1QIuMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bp1QIuMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B17FC4CEE9;
	Tue, 11 Mar 2025 15:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706205;
	bh=Ph+ubgudyPSCPwmkFZidSH9W5kIBWQ9iaAzKbIGYuWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bp1QIuMMyc6SqiapcJ4rEgZ9joEjUGNYznkkRsKN3DcR4wwi+PoVdfYtBWzij1o8z
	 u2tqVkpE/BU6pvMDiQSuMGBxTnZkt5w/fQTFMMsDTLDaSExP3friYM7FP+xP8bNQvd
	 q/WY02qw6bSwXZ+KbNZumyj+PzJZhf9opjmXKmIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titus Rwantare <titusr@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/328] hwmon: (pmbus) Initialise page count in pmbus_identify()
Date: Tue, 11 Mar 2025 16:01:08 +0100
Message-ID: <20250311145726.748757710@linuxfoundation.org>
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

From: Titus Rwantare <titusr@google.com>

[ Upstream commit 6b6e2e8fd0de3fa7c6f4f8fe6841b01770b2e7bc ]

The `pmbus_identify()` function fails to correctly determine the number
of supported pages on PMBus devices. This occurs because `info->pages`
is implicitly zero-initialised, and `pmbus_set_page()` does not perform
writes to the page register if `info->pages` is not yet initialised.
Without this patch, `info->pages` is always set to the maximum after
scanning.

This patch initialises `info->pages` to `PMBUS_PAGES` before the probing
loop, enabling `pmbus_set_page()` writes to make it out onto the bus
correctly identifying the number of pages. `PMBUS_PAGES` seemed like a
reasonable non-zero number because that's the current result of the
identification process.

Testing was done with a PMBus device in QEMU.

Signed-off-by: Titus Rwantare <titusr@google.com>
Fixes: 442aba78728e7 ("hwmon: PMBus device driver")
Link: https://lore.kernel.org/r/20250227222455.2583468-1-titusr@google.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.c b/drivers/hwmon/pmbus/pmbus.c
index c0bc43d010186..81d4e9e85d3ea 100644
--- a/drivers/hwmon/pmbus/pmbus.c
+++ b/drivers/hwmon/pmbus/pmbus.c
@@ -101,6 +101,8 @@ static int pmbus_identify(struct i2c_client *client,
 		if (pmbus_check_byte_register(client, 0, PMBUS_PAGE)) {
 			int page;
 
+			info->pages = PMBUS_PAGES;
+
 			for (page = 1; page < PMBUS_PAGES; page++) {
 				if (pmbus_set_page(client, page) < 0)
 					break;
-- 
2.39.5



