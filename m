Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5493BED37;
	Mon, 23 Mar 2026 16:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282743; cv=none; b=ioaYdNdU92nN0R2znslHqZ+8wZNzAjzB36dGrQmuLX//ehHNQ/LJSvu04I+eEo4g3jqpm4ZfVvZqFNfATRj1+NggOk4yz8bB1A562feT9y9uDN7Z+gLKlik3kMxsnJv35TyQWY6CX1utljB1GUrbjC7mjMupsnrjoAiU1vl4HMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282743; c=relaxed/simple;
	bh=zefPZ1gk6Y2O9NL59yA7E2njqd/CMzN3/fEbbamx8z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9Bk1vHjkpds2EUhpx2F4jH8MwFtgU++B1Q0MqJLf99nqm8kUtw2zBAfdmQEAp8eH877zZSP/1iotA6UAdbkIfA6Iso9s6a/orReJnrSzpWUWkvXFrPM+ZCjhqV/5xGJ7MwecnbELIZGi+kn1YSkqNm4hKsc4bf9ffe7cM+ca14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQ2FSfue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQ2FSfue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D21C4CEF7;
	Mon, 23 Mar 2026 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282743;
	bh=zefPZ1gk6Y2O9NL59yA7E2njqd/CMzN3/fEbbamx8z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQ2FSfueWRHES8THwx7552wyNYtsuLQIpYZPzu2/aZYYBg/W4s3cB3kNsavS7YPf4
	 ic2hEQxvCwwK2VGqPpEZxKrF/QBAeO8IsO5BcZsnTfiaPCuupvLYDKVfirM1cphLJu
	 i/jWQC75keQGzzC3tjI0hNy+MXyeMwX9tfCthYrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 6.1 268/481] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Mon, 23 Mar 2026 14:44:10 +0100
Message-ID: <20260323134531.667979705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Schmid <lukas.schmid@netcube.li>

commit 85e4614524dca6c0a43874f475a17de2b9725648 upstream.

The MCP4131 wiper address is shifted twice when preparing the SPI
command in mcp4131_write_raw().

The address is already shifted when assigned to the local variable
"address", but is then shifted again when written to data->buf[0].
This results in an incorrect command being sent to the device and
breaks wiper writes to the second channel.

Remove the second shift and use the pre-shifted address directly
when composing the SPI transfer.

Fixes: 22d199a53910 ("iio: potentiometer: add driver for Microchip MCP413X/414X/415X/416X/423X/424X/425X/426X")
Signed-off-by: Lukas Schmid <lukas.schmid@netcube.li>#
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/potentiometer/mcp4131.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/potentiometer/mcp4131.c
+++ b/drivers/iio/potentiometer/mcp4131.c
@@ -222,7 +222,7 @@ static int mcp4131_write_raw(struct iio_
 
 	mutex_lock(&data->lock);
 
-	data->buf[0] = address << MCP4131_WIPER_SHIFT;
+	data->buf[0] = address;
 	data->buf[0] |= MCP4131_WRITE | (val >> 8);
 	data->buf[1] = val & 0xFF; /* 8 bits here */
 


