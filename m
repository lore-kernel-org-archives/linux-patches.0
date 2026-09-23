Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8642F52FE4E;
	Wed, 23 Sep 2026 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173921; cv=none; b=l51ULKjKzQFZ7/j+W8l2lSdbebTJfUoaceKRbCMh7mqGmZjfWGQI2o6vrBjGAk1MvEcKreFqd1YPqu8GlD8MBwHbbjZIu7H9FcuGBzBv9fc7VuUc7W3jaZwK1fahylhcBSZJlNlZqlsPmZLavbszHANq07/rpLxsIxjmwHClBAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173921; c=relaxed/simple;
	bh=UzIsHAe95Wag0m/4Ka++pz2eqO8+vr/NAm64LUIG0Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHZYPfO1nCVBQeMU8NX38+hS6E8TMAXWYrybEkiTR3B1y38xIFk8TEgovPBp9ZQJy6wOCShGIJSNBkjNT72r+0devR4DJA1rcGW+UiEuMpTqapv4X7ATQAZISf/KkhC9aAKnyAfm663acbfadk4r00l/rb4D34DixfN1sx1RKho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khgmdLWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khgmdLWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19691F000FF;
	Wed, 23 Sep 2026 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173919;
	bh=BLxHhpx1+pDgIphkIkXrlE2B9FjwM8OcANqXxdLDnys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khgmdLWLh9yLjbgZ5N4TpVoYAgeSqABsk+J1rCAUqoTGKDjUuY8fpedC2XRb0Ps6J
	 t7bjnj7HYPeUNar49TlbUDyb/7Uc26DeRXTHVLep+eexmH6vBE+nVZP+4C3o9J3hSr
	 GdlV8kdY6gqSVtLKHuNVh0JgiNeCFmsT/q7B22m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 368/438] hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676
Date: Wed, 23 Sep 2026 16:06:29 +0200
Message-ID: <20260923140654.395002310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 089070b51ccbac411462a30a454690274c6e4270 upstream.

tps53676_identify() derives the number of PMBus pages but does not
ensure that page 0 is selected for single-page configurations.
pmbus_set_page() does not update the PAGE register when info->pages is
1, so if boot firmware leaves PAGE set to another value subsequent
register accesses may target the wrong page.

For single-page devices, select page 0 explicitly.

Fixes: cb3d37b59012 ("hwmon: (pmbus/tps53679) Add support for TI TPS53676")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://patch.msgid.link/20260916235406.681131-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/tps53679.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -200,6 +200,15 @@ static int tps53676_identify(struct i2c_
 	if (phases_b > 0) {
 		info->pages = 2;
 		info->phases[1] = phases_b;
+	} else {
+		/*
+		 * pmbus_set_page() does not update the PAGE register on
+		 * single-page devices, so select page 0 explicitly in case
+		 * the boot firmware left the device on another page.
+		 */
+		ret = i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+		if (ret < 0)
+			return ret;
 	}
 	return 0;
 }


