Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BF551CF41;
	Wed, 30 Sep 2026 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784500; cv=none; b=jkIC6MorTZguSvZ3HLdOph41Dj4Y4tc8iWmOCQatw4ga6ZuJtw4djVgQiJcEKxJp1V1nXCL7RIcaZ3b49fYYbtZjQhJzgo2XLfrEbPtg/fN39MD5rmyYrkkFf5bh9SEbKBrH08UevD6WyDVFpg6k9hftdFHYLMs7qDeCpRTpFCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784500; c=relaxed/simple;
	bh=lsDlcV6dTNy4Wx9S9DHHeXbbBhQFDl93D9GvHY4Zl+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOoJ/kdVUBqbxmoMZSfQf+Va4sO0j+t5dulI3BRwb7tThN6qA2rG92iom8MpiQB5Idqtc1om5broqzvH9DgvBSJLV0ItqAZ7rjIFhr18q1IfMlSiKNFXMBQ7voLsV8QYg6z/gY0WSP25MQ8oYl2jghHGFEQrTc9WkUrzOdIH5OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAyPn1mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAyPn1mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4521F00898;
	Wed, 30 Sep 2026 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784493;
	bh=sRMqsI9kBD1Ge+l1roROnuYQjWOVNDxgl1TJmnReCk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAyPn1mjX/+r1OxazubHr7Ulbqh6JUCmxEWyfLxqfLc24gELfoPsbNSP6OiQIj3Z7
	 tg9IavwA+Ajqhmm6WsiOoTOZCcu9V7KW5fITi+c/ah60zcl41IvfvGYyO20tfd68zF
	 SW1LaJ2qpd9uQ9QYbtkw+6X418L7st4KtNaXXNR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Metchev <nikolaymetchev@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/982] platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table
Date: Wed, 30 Sep 2026 17:15:12 +0200
Message-ID: <20260930152420.596353695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Metchev <nikolaymetchev@gmail.com>

[ Upstream commit c39023ca9a447f09c072080efc84d6874c2275c9 ]

The volume rocker buttons on the HP ProBook x360 440 G1 convertible emit
events 0xc4-0xc7 via the intel-hid ACPI device (INT33D5). These codes are
only present in intel_array_keymap, which is used when the "5 button
array" input device exists. On this machine button_array_present()
returns false because the firmware does not advertise the array through
the HEBC method, so notify_handler() routes the events to a NULL
priv->array and they are dropped as "unknown event 0xc4". As a result
the side volume keys do nothing.

Add the machine to button_array_table so the array device is created and
the volume rocker emits KEY_VOLUMEUP / KEY_VOLUMEDOWN. This is equivalent
to booting with the enable_5_button_array=1 module parameter, which was
used to confirm the fix on the affected hardware.

Signed-off-by: Nikolay Metchev <nikolaymetchev@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260609213309.445019-1-nikolaymetchev@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index ddf46fceb1c37..a6d4c8e3a78db 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -123,6 +123,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 4"),
 		},
 	},
+	{
+		.ident = "HP ProBook x360 440 G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook x360 440 G1"),
+		},
+	},
 	{ }
 };
 
-- 
2.53.0



