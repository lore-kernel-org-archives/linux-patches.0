Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D12927B320;
	Mon, 22 Sep 2025 19:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569740; cv=none; b=aJiCpa40wwhKwWQcbFFZIRmZjScIASvoKncF6tr5nepOsz2FDZdGbhWIJONo5SHYrKrJ93J4gQtQmA/fK+dgRFuaQm4yXFaYp587E32pC8GsFM8v2Z6i8a3p+kBspoCob7jAP+ZL0WtAvqs+Ydu58Xf1axs2vq5cO3qU2v2rvy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569740; c=relaxed/simple;
	bh=RTUZwhcPe+jmMiD0l67l41IpfSgeliBCvQkp+VabuI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCbdDPurOKs1KB9obiDw8AbDX0281mnxY2xfa/TD+YbTkcQMZ7N7T9OfMBXUJqvh476og7pGMO5PzhsJ+XKpifUOpUYDvquR8rJQoQJGw1iLa19jNb/Q6iaqparpLjD2xn/XVtnXrlt0Cwq+6/2rY1Jx/slS0fSTi9EoaZzSUoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Mam6kcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Mam6kcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA34AC4CEF0;
	Mon, 22 Sep 2025 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569740;
	bh=RTUZwhcPe+jmMiD0l67l41IpfSgeliBCvQkp+VabuI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Mam6kcwYtZINgsraCVfjEk8HhhqIW/l46zTfJcrTxf1H7pE4Fm8XLIGUvDipNCjb
	 i6HxOpaJpS8479HbWTfsJ71/r73kBZtiLiSaoR0Vnwbl6ykxktPP/pmtEi4drpy3gZ
	 2TiSBjPNFzXQ1LvWlwPVSqnbSeSJVfWp7UnqGjLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 42/70] net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer
Date: Mon, 22 Sep 2025 21:29:42 +0200
Message-ID: <20250922192405.746172092@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

From: Hans de Goede <hansg@kernel.org>

commit b6f56a44e4c1014b08859dcf04ed246500e310e5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/rfkill-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -79,10 +79,10 @@ static int rfkill_gpio_acpi_probe(struct
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


