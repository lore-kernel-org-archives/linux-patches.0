Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492F1C6F69;
	Tue, 27 Aug 2024 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770825; cv=none; b=n6JQ4hS0VRYgC7nTle16hAWJZ3iC9fWggw/NrT6Kd230dRyFk8ZXtyFkmBwPPrGaYqsBWS72Q/5dgOnOD4gkTt4FQ2EoqGn7WTMBYF8VC7vABH2Sq43+O9PTEwvtwaHF1NFY2vB3Gz0uN3PC5Huu1MWiVxAnM8DfuMCCCSqnSCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770825; c=relaxed/simple;
	bh=jmwphznRUkAPkeMtjJWQUdxMXr5PQ1ieQuACM4EHEKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpINLTis7paWro1GmVgYPa+oCX1P/xLF2n7FDlOWEzGtuXZfWyh1R1MBczqKUHa2wpvzzqsfQev5zVIu/HZqRoxblDeJSBwLUP7/bDnvZnWTBjkliXsPDIqx1/PZsXEn5gueZ6Or9Xr2XSPobG53z1/y6vI7kt6LIgNPUPdqR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBPyGkfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBPyGkfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ACBC4DDEF;
	Tue, 27 Aug 2024 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770824;
	bh=jmwphznRUkAPkeMtjJWQUdxMXr5PQ1ieQuACM4EHEKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBPyGkfScvr8vp4yVyV4e72klzoZz5xyQjZIN9FO2E1Hb/OjbvrsO+obuFXt4yZ3p
	 74vR9R5+vWY3fRJhIYC1yj8l9LVL2z0AtFDl5OhxNM7TB4bwsb/UwcBr0F5hQ/EzMi
	 a4rPALoA5squuIo6oTzMIjSkl6TxQ/We73I5c4to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 326/341] hwmon: (ltc2992) Fix memory leak in ltc2992_parse_dt()
Date: Tue, 27 Aug 2024 16:39:17 +0200
Message-ID: <20240827143855.800522210@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


