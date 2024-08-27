Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ABC1CFEC6;
	Tue, 27 Aug 2024 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772663; cv=none; b=ddLjYk2Ir9jXaBH4Pl+uEGWkNnrXQOvG6ZJmmc3tGBsyHhWluOuu6ZGp0xu8nXXUPCkXDfN/PgVbyfg4e176Ge2UJsb+Fwi/Zj65DK6AcxwaZl/OKE+NiKeWA3pAicW3nHAPgrK0v2TB16S91Zt/SloF+HKg6hh/0Xtst6CsFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772663; c=relaxed/simple;
	bh=cWuotUulsNg36i7bDONr3yG5JkKHAsqru0xj6C2sa+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwLYw2wNgQ1W7pz2v6/pnhz/K6/vKoXS/yIcpoJMEpf2xwu2Pfhhn7fta3qeX5vF54G0pPXXPthmvM75Rz68fV53ZR9WCjaObV1qa4l573fGms5+R/lKhCAArqmNLs1mAcgXwllOWkR++7JcGhtfNmEDfVvFDYofzpw3cFBUMao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTHXkEuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTHXkEuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD4AC4DDE4;
	Tue, 27 Aug 2024 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772663;
	bh=cWuotUulsNg36i7bDONr3yG5JkKHAsqru0xj6C2sa+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTHXkEuo1W8bRAQjf/ca0Yj1VxOwiRH7Ziug9vSjL96uoxePq1xMi7Nzs4/uBk98n
	 195nSNHje775uidlPRzRXT9rK/2bythV2LzwYANilWSHzpKpfryliwSi3Fa3SYfvKi
	 kFV/+VhCRV2MFxsRjKOyhKf4xQ4VhUCGZNMlTdk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 283/321] hwmon: (ltc2992) Fix memory leak in ltc2992_parse_dt()
Date: Tue, 27 Aug 2024 16:39:51 +0200
Message-ID: <20240827143849.021222693@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -876,9 +876,11 @@ static int ltc2992_parse_dt(struct ltc29
 
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


