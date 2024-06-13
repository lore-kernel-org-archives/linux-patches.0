Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6472D1465A8;
	Thu, 13 Jun 2024 11:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279602; cv=none; b=ECEAp05RVx+yVTYtsyLGOZp3VTtXg3CJ8p6n0yxsnho1CRwSMWo8l35SjNjoCDslpvN/BjkGOk/Mse7gVFxM4yazGyR9ppWjpxWxoz+1qN2GkwIZK1czLuBd7KvRnA058/tln+wCDCBDIqoZlpiWBidUokURS+iQXCPcTqaNyA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279602; c=relaxed/simple;
	bh=UE0mpphYQUSMKvPSCxBFat4CJLTM8HjtGKdP6u4oymc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h34IWLGIT3116sHuztElUafYa4PsBggWrpdU8mgMBPiVQZnV+rI0cSU935Qcz6PZGIaF511bNwlI/WCpIN+1eDVIdjh4o5nI0+riQuZTAIoolZfdgW16DBwWS14LMnm+dCjHXNBHcsUD5UZ3rAMmKh/b0FbpvMKoFfMJ33zsGHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrZgNgTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrZgNgTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84790C2BBFC;
	Thu, 13 Jun 2024 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279601;
	bh=UE0mpphYQUSMKvPSCxBFat4CJLTM8HjtGKdP6u4oymc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrZgNgTh5uSITt5FxfPvc3uyXI/7bI5paeBz1EEV1fKyE56DEBhQx4ao46TZ4tbCc
	 xkDLElEFgg8p49VZhmHhZ9XEum94oBeni1ElOlArnDiGEifUdFY6WPMeoEb2TAPz0A
	 k6By+XXtEja2g8JLLaDLQDC5vJ1+DOCqctXEC7WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.9 132/157] hwmon: (ltc2992) Fix memory leak in ltc2992_parse_dt()
Date: Thu, 13 Jun 2024 13:34:17 +0200
Message-ID: <20240613113232.513377766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


