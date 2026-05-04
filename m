Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85093BE630;
	Mon,  4 May 2026 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903984; cv=none; b=Io+aRI12fGRVSbM3CpZitux+Yql8oQjcKsVjgiHinWB5TFB/2+ULAxsgUmu+/eyOx0RRWkZ9jI+4Uxs/es7hSeTziInKl5ZtqB4AHzvwbq4PbhzYwTAtck5rrESz2wNSXJjPIN7AQ+JR8zJWvk3WfWMfT3ouIMikZLJQxCwwv2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903984; c=relaxed/simple;
	bh=aXZFjL7NQyfi4/jSBu96wcazZJn843KA1WEux1o7y1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY4NrBCFsvS+ID0xREQZXhowh/dFNDzVfymzjwF2KR+wodrQr6ZO8NhwWHVvA/cHUPvpnsZLX7i1eOAosqIFeng686EsEEFxYisxeYowF6KYMrUIaoI00rDDRFAhwh3n6tFafukZa3jvtfdY42/VokQ6sKPTxFhIaw716v5KDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sHJlQhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sHJlQhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B5BC2BCF4;
	Mon,  4 May 2026 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903984;
	bh=aXZFjL7NQyfi4/jSBu96wcazZJn843KA1WEux1o7y1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sHJlQhYgjhLbYsNsuQWNsj9Sxxuw6kcSETaW2xAENRlQbEiMYIFnSnUh8mWHFDU5
	 dAQgpVv9A6JvX2buXo5WsjU8LVzLTPDexvk4lMGZFD477LUVZp0pSEfKBh1KjczwGC
	 xKAAFrL06BqTONQxt+ZDlFypXvE1k/ZWn3zMlmGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 139/275] hwmon: (isl28022) Fix integer overflow in power calculation on 32-bit
Date: Mon,  4 May 2026 15:51:19 +0200
Message-ID: <20260504135148.066998075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


