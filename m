Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1472236EB;
	Tue, 30 Sep 2025 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245217; cv=none; b=h/n2k2TMqVW8yQArg9SWv0HzuzSlYQraruAGdMt/3xAIXjHt0+4g7+/W8Yg2X+sHfi/pFwc72nnna1A1hqSQ65Tqln/kd7zVUsz55L4j43jBt/nozqyORKDbTHHHxBXTfN8a7snxWPe7UF/4hwAQgYyrhjnhU+AG/omMQwlM2d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245217; c=relaxed/simple;
	bh=dePl+uUNDGOmZ1D2J5HAyCpTKbeydAQ5KAaJwZJISks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWh1CVu+fVvtYLDfbyf5A2uvA03aarFJqZqlQ38wUa8gwZQTFJJr5766p2IK4X6TomtlrRqCEIim1yWTfTT+r+XwfeJtNTe6wfRaP4X0eN7F6fXKFQKcwiD7Kizw7D6HnUuNp0SQPiJS9ruz7FHfi0v0PiP+/lLqw0B9v4NBD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGasKrEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGasKrEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FB8C4CEF0;
	Tue, 30 Sep 2025 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245217;
	bh=dePl+uUNDGOmZ1D2J5HAyCpTKbeydAQ5KAaJwZJISks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGasKrEkUYaucJu7xGK1jPkW7sNL3jF0my7yfGgGekDGOVuZaxcCPrYNJwyshQZTo
	 K4CYO+C4sn2/Hx4Mw8bjHfm4z6rMEQpbcBblYP37QclIIUGeVKJvhL74qQQyMiFb7c
	 8+rOB7hg1IGs6uPdiFflDGLK6si862CPgNy+oFoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/151] net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer
Date: Tue, 30 Sep 2025 16:47:12 +0200
Message-ID: <20250930143831.663965393@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit b6f56a44e4c1014b08859dcf04ed246500e310e5 ]

Since commit 7d5e9737efda ("net: rfkill: gpio: get the name and type from
device property") rfkill_find_type() gets called with the possibly
uninitialized "const char *type_name;" local variable.

On x86 systems when rfkill-gpio binds to a "BCM4752" or "LNV4752"
acpi_device, the rfkill->type is set based on the ACPI acpi_device_id:

        rfkill->type = (unsigned)id->driver_data;

and there is no "type" property so device_property_read_string() will fail
and leave type_name uninitialized, leading to a potential crash.

rfkill_find_type() does accept a NULL pointer, fix the potential crash
by initializing type_name to NULL.

Note likely sofar this has not been caught because:

1. Not many x86 machines actually have a "BCM4752"/"LNV4752" acpi_device
2. The stack happened to contain NULL where type_name is stored

Fixes: 7d5e9737efda ("net: rfkill: gpio: get the name and type from device property")
Cc: stable@vger.kernel.org
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20250913113515.21698-1-hansg@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/rfkill-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -78,10 +78,10 @@ static int rfkill_gpio_acpi_probe(struct
 static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_data *rfkill;
-	struct gpio_desc *gpio;
+	const char *type_name = NULL;
 	const char *name_property;
 	const char *type_property;
-	const char *type_name;
+	struct gpio_desc *gpio;
 	int ret;
 
 	rfkill = devm_kzalloc(&pdev->dev, sizeof(*rfkill), GFP_KERNEL);


