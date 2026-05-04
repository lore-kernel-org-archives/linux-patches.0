Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774D4378D8C;
	Mon,  4 May 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903260; cv=none; b=cGAMBcyLR+Gz3RlROuOSyCtkf0SiLoDBa+qHuKYVaul3w0rPszdU6nX/wB46IpKzIWvjQlG0HAjuO5jauGm4aCKq4uo57TQcdhOUpJ3pYIcwaNEDsiTNuzzOq6id1NK4HNX9igRFMUJ8rr/723ekkiWp/ExphnYrSnJuhXE53gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903260; c=relaxed/simple;
	bh=C5VXDLojTgNESoMxCVQdwC86h4getigo7JbndifZFkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/THZ+E0bvX76nwkwcB7XTBtsv7xBayyOtl2ZPWkVBJvEUovInOnrcjAnpBfRv6XvzeV+gQl9ATFky7f4RWvagV+br/Y6glmveCNYUyL5FRAXj2+HsL9JScOM52XRrvbX78YmelevsjlCH/v3ZYJfv+TqPKd+Wze21OCYqRjqWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlqSk8Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlqSk8Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7CDC2BCB8;
	Mon,  4 May 2026 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903260;
	bh=C5VXDLojTgNESoMxCVQdwC86h4getigo7JbndifZFkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlqSk8FfMirLZZ0ofyhjZlaWDS9eeKVTt4n3cSFcaciQWJ0SXgSmPyGlSKni9wUwB
	 S1rc1r9KoC7iuMZoMmzEXr9yCmMK3GvhpgPU4D8JZFJ8k8pTVCuXVOVhQdBGAMUF4k
	 H5KsjZph6/qt/fI3DiYH4Gf1oCD9DtvrfkKSl7/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.0 164/307] hwmon: (isl28022) Fix integer overflow in power calculation on 32-bit
Date: Mon,  4 May 2026 15:50:49 +0200
Message-ID: <20260504135149.035139840@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit a7c0aaa50e40ffd8fd703d006d5a04b540b9ca92 upstream.

isl28022_read_power() computes:

  *val = ((51200000L * ((long)data->gain)) /
          (long)data->shunt) * (long)regval;

On 32-bit platforms, 'long' is 32 bits. With gain=8 and shunt=10000
(the default configuration):

  (51200000 * 8) / 10000 = 40960
  40960 * 65535 = 2,684,313,600

This exceeds LONG_MAX (2,147,483,647), resulting in signed integer
overflow.

Additionally, dividing before multiplying by regval loses precision
unnecessarily.

Use u64 arithmetic with div_u64() and multiply before dividing to
retain precision. The intermediate product cannot overflow u64
(worst case: 51200000 * 8 * 65535 = 26843136000000). Power is
inherently non-negative, so unsigned types are the natural fit.
Cap the result to LONG_MAX before returning it through the hwmon
callback.

Fixes: 39671a14df4f2 ("hwmon: (isl28022) new driver for ISL28022 power monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260410002613.424557-1-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/isl28022.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/isl28022.c
+++ b/drivers/hwmon/isl28022.c
@@ -9,6 +9,7 @@
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/i2c.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
 
@@ -185,8 +186,8 @@ static int isl28022_read_power(struct de
 				  ISL28022_REG_POWER, &regval);
 		if (err < 0)
 			return err;
-		*val = ((51200000L * ((long)data->gain)) /
-			(long)data->shunt) * (long)regval;
+		*val = min(div_u64(51200000ULL * data->gain * regval,
+				   data->shunt), LONG_MAX);
 		break;
 	default:
 		return -EOPNOTSUPP;


