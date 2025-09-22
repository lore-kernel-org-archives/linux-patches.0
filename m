Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF6E1F91E3;
	Mon, 22 Sep 2025 19:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570344; cv=none; b=Ag3itzeidVFydnRKOqh6egMHQNYGLY/tQciVc63EvLq0bSFK+ht+coUmGVLBND1kelpvNfPFoFpx/ztivJimHOpuLoJQPROfOpMtFF4KgtQKLbCRswWX83FkBO/jLVs8Ssu7VYPV3yPSgxhRSmgc1ykXltw9MMA8BNZS6zYI1qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570344; c=relaxed/simple;
	bh=CksHH4xfdKQSip6tdqInQfR8xg4Iu9gHHZT1U67Nxas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXsQIohpa5UKTjpQyfaCuz3vKdWI8rXzJJ+NiCu3cl+QXgqKqz6t3/rmSOBiCh+l+bwlTbpYFO4xMR94PgIiFf7dnKt4056zK7jKzTqWRv5LmMiNtwY5Zl8Usnalx+kLssZLR2NRXZorhH73q0sCVO7v6+7zEE/y8X/aiQrk7Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1ny3fr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1ny3fr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576CAC4CEF0;
	Mon, 22 Sep 2025 19:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570344;
	bh=CksHH4xfdKQSip6tdqInQfR8xg4Iu9gHHZT1U67Nxas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1ny3fr2tQ3hDxa0k1cK8RnnJsRdHfuXFaciXJqndMCIT7ShfYiJQ3J3rrAty4MVB
	 JpbeX6uJ1N6vm1yoZjoCZE9CaBme1yo5j3Aw4t58ecoHNwCN7fcw3DW4EcN4EKIuOS
	 Y6grX/2YxR/bZgwbBJz8XsB8IVBQhSVSo4y05G94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.16 100/149] net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer
Date: Mon, 22 Sep 2025 21:30:00 +0200
Message-ID: <20250922192415.409509290@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -94,10 +94,10 @@ static const struct dmi_system_id rfkill
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
 
 	if (dmi_check_system(rfkill_gpio_deny_table))


