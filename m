Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CCA4E73B9;
	Thu, 17 Sep 2026 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660438; cv=none; b=kI9Bxr5oHpN5YnD/X6ep6o3XKSpWzKDN7Eb2x4Of55ZdBS6PM3HHaQ4wvJFV8BjbcAh0MlQdpoX/1RjjR3kEUZoklUzVuI4rlE2YvlmHkAeSmflz8BTKvFTyvhy2IDyJ32Y3h0EdoMZKGPF8H14jE+JCcfT9KYlWGhuMexEGfYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660438; c=relaxed/simple;
	bh=aftyCfer7FJ8kdGaU4W4W18YDVPm9dcQaUpquJYJuaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXNQdK4nkFFky4Q0XAJqVnHp4zlLwiZIPsd9qgtw3PXvo45Xg2CdFprH4uexhZ+ioUaJrC3zFHPrY4zR+kMHefzki9fnLssg79WSr41a7vVDVi41+qSIJcAtCH+EumPJ00MamkFWDkbjuDnaR3ZAFHhptQDausGNpBjo9U/J29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7G0QZH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7G0QZH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE221F00893;
	Thu, 17 Sep 2026 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660437;
	bh=JOUJLFfy48v2CuqYuwYtE2Xujd6rzI5LCrsyEK5K+jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7G0QZH4DI3m1XxZNAwJzpkjjfqmEimFWfnislPK5iY6NzcBfTnDMdkGGAfZ4ZE64
	 zO09F56zdHu953hz7wcQfUfgeTZ/MibECk8bByaoNRLtBkrxmMZPqgov6mznCtG36H
	 wtq0PxCYaAMNIgjkCSXjTgFawyJwAIAUI6xy7d90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 593/733] hwmon: (mcp9982) Propagate one-shot polling errors
Date: Thu, 17 Sep 2026 16:15:01 +0100
Message-ID: <20260917151407.217635451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

commit 9607c245ca6674955e5e43e3606db410ae9e0b90 upstream.

When a device is in standby, the driver starts a one-shot conversion and
polls the BUSY flag before reading temperature, alarm, or fault data.
The poll result is currently ignored. Therefore, a timeout or a
status-register read failure can be hidden by a later successful read,
causing stale data to be returned as valid.

Return the polling error before reading the requested attribute.

Fixes: e2fe950f34e5 ("hwmon: add support for MCP998X")
Cc: stable@vger.kernel.org
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Link: https://patch.msgid.link/20260819180701.34797-1-nikhilgurudasani314@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/mcp9982.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/mcp9982.c
+++ b/drivers/hwmon/mcp9982.c
@@ -395,6 +395,8 @@ static int mcp9982_read(struct device *d
 					       reg_status, !(reg_status & MCP9982_STATUS_BUSY),
 					       MCP9982_WAKE_UP_TIME_US,
 					       MCP9982_WAKE_UP_TIME_US * 10);
+				if (ret)
+					return ret;
 				break;
 			}
 			break;


