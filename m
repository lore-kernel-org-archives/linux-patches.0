Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E90248883;
	Tue, 11 Nov 2025 01:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823437; cv=none; b=UkBV/2AOY0K1pZbGTdLbO+jY7xNURz24dRbtUzP4jb8sXc/d+JnpE3Vuej/XYkv+vofzhjrqS2t3ktwm7P/Nie8So2BhYUOQCH3Ko4zBCzmKeVZ4Flhq2JIOury6lwBj1G37hLNFU6RtY+Kt53wN31wOlSA/1zTIS3lJbQ1Plzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823437; c=relaxed/simple;
	bh=9t/RU+eYxNNNdSKxyp+nFWyuKD38zcssJ0/dgSGWfvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeMO04euuGPAR5yFeIN1AHSACwCGZ9VSMM1P/H9d+N3yDp1Ue+JEOjrVPA1amw0MdgvXmthyMwc9AeqpQ2gKuMqTYlZTqHSi0DNSgNmcRrsMud4SN2TrFXyTbN5LrXIu53dd5iGkt4Fjsy4KrQjuTz3bb1N4SrXnc17P7c1JISA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bymmt0DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bymmt0DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB16C19424;
	Tue, 11 Nov 2025 01:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823437;
	bh=9t/RU+eYxNNNdSKxyp+nFWyuKD38zcssJ0/dgSGWfvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bymmt0DQkN8UndCphVQfWT6YgL/ffrLhVrx+OuDRfGP2ZnniFw6DpcybeIwYNE6UP
	 H0UrnFZn4Z7lFCSZrdud3qjhHolMBrZTQ1mRdc2oUNxJc6OepQQJqs7bLlnRfK+gX4
	 pcHh9H8uvhRTgbg4ZXERuTdIxHVyI3hYyBTO3Kxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/565] char: misc: Make misc_register() reentry for miscdevice who wants dynamic minor
Date: Tue, 11 Nov 2025 09:41:29 +0900
Message-ID: <20251111004532.157988818@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 52e2bb5ff089d65e2c7d982fe2826dc88e473d50 ]

For miscdevice who wants dynamic minor, it may fail to be registered again
without reinitialization after being de-registered, which is illustrated
by kunit test case miscdev_test_dynamic_reentry() newly added.

There is a real case found by cascardo when a part of minor range were
contained by range [0, 255):

1) wmi/dell-smbios registered minor 122, and acpi_thermal_rel registered
   minor 123
2) unbind "int3400 thermal" driver from its device, this will de-register
   acpi_thermal_rel
3) rmmod then insmod dell_smbios again, now wmi/dell-smbios is using minor
   123
4) bind the device to "int3400 thermal" driver again, acpi_thermal_rel
   fails to register.

Some drivers may reuse the miscdevice structure after they are deregistered
If the intention is to allocate a dynamic minor, if the minor number is not
reset to MISC_DYNAMIC_MINOR before calling misc_register(), it will try to
register a previously dynamically allocated minor number, which may have
been registered by a different driver.

One such case is the acpi_thermal_rel misc device, registered by the
int3400 thermal driver. If the device is unbound from the driver and later
bound, if there was another dynamic misc device registered in between, it
would fail to register the acpi_thermal_rel misc device. Other drivers
behave similarly.

Actually, this kind of issue is prone to happen if APIs
misc_register()/misc_deregister() are invoked by driver's
probe()/remove() separately.

Instead of fixing all the drivers, just reset the minor member to
MISC_DYNAMIC_MINOR in misc_deregister() in case it was a dynamically
allocated minor number, as error handling of misc_register() does.

Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250714-rfc_miscdev-v6-5-2ed949665bde@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 30178e20d962d..9ee78c76e8663 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -300,6 +300,8 @@ void misc_deregister(struct miscdevice *misc)
 	list_del(&misc->list);
 	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	misc_minor_free(misc->minor);
+	if (misc->minor > MISC_DYNAMIC_MINOR)
+		misc->minor = MISC_DYNAMIC_MINOR;
 	mutex_unlock(&misc_mtx);
 }
 EXPORT_SYMBOL(misc_deregister);
-- 
2.51.0



