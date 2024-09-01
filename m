Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3052C190;
	Sun,  1 Sep 2024 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210371; cv=none; b=RqBwX8xzavAySv6cwvg0vH6a6588xRBRgXDCGdxcwNw0ayD+JeKz1QR2Zr84pjQW+HgsKto4B9fdk9H7arYbS8zzv1cy81VoES3UnwQ4dCmsFJws+TOQREcETegNxCvepTcdHDLoxTzl3vBJ8cQlFl1QBqtUrZ1VLlLCik9s1Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210371; c=relaxed/simple;
	bh=ff9r634YEkTTrH0Qdt2VodPyV2F0KXR8Qk/NM3e7ASo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ9ggcpNV7DFgS+uH4msNvIDptsG4e5k+cArvwOTNz0xKJ0conj1dP/mL1a12M4F+MetuhwIlRNdETu3/zy0RtS46QYja9rnDbVpvaphSz0niGXwTPCFFHvf8iiaeYD+DVamu39MTPnVVz3exsBJpsNQdlIM/5/vEFR6wM5gZ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drNdW5/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drNdW5/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C752C4CEC3;
	Sun,  1 Sep 2024 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210371;
	bh=ff9r634YEkTTrH0Qdt2VodPyV2F0KXR8Qk/NM3e7ASo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drNdW5/aBuE/F5p2izX/JqSg4qtOp6AlKoE25FgdJrjZ5d2wcynLxkkVOCwBs0ceQ
	 czEkCFeWzn1uZiMfjL9rjnGkKKVg9TmrRGkifHF9QBLpkhtxAVHYI3HOSad+kUVmZD
	 mF1w7h7e2ts6KB+offV+8vClSuKt5beiW2eDF+9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 168/215] hwmon: (ltc2992) Fix memory leak in ltc2992_parse_dt()
Date: Sun,  1 Sep 2024 18:18:00 +0200
Message-ID: <20240901160829.709296395@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit a94ff8e50c20bde6d50864849a98b106e45d30c6 upstream.

A new error path was added to the fwnode_for_each_available_node() loop
in ltc2992_parse_dt(), which leads to an early return that requires a
call to fwnode_handle_put() to avoid a memory leak in that case.

Add the missing fwnode_handle_put() in the error path from a zero value
shunt resistor.

Cc: stable@vger.kernel.org
Fixes: 10b029020487 ("hwmon: (ltc2992) Avoid division by zero")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20240523-fwnode_for_each_available_child_node_scoped-v2-1-701f3a03f2fb@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/ltc2992.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -913,9 +913,11 @@ static int ltc2992_parse_dt(struct ltc29
 
 		ret = fwnode_property_read_u32(child, "shunt-resistor-micro-ohms", &val);
 		if (!ret) {
-			if (!val)
+			if (!val) {
+				fwnode_handle_put(child);
 				return dev_err_probe(&st->client->dev, -EINVAL,
 						     "shunt resistor value cannot be zero\n");
+			}
 			st->r_sense_uohm[addr] = val;
 		}
 	}


