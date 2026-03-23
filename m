Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC6C17DE36;
	Mon, 23 Mar 2026 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275752; cv=none; b=rF5Na3qtygETFRqkFZ9jDm0ZysunRN6Y89nytsItpJgeNw3Oio2hSFm3gJGqyq+54/vX1IvN5/3/f29UusiYtUC8kWCzGAbKfDOCe1/iZf5PgIztqoRfGleDGveRJkt1UwjjtDEiHgyF/ocLZV89HRQracilHR8C3apZ8v8lPSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275752; c=relaxed/simple;
	bh=fkwf5R4dKaUaky0XAP1SPXQKuZG7uTxdfuOM5BQhdYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLd2fYZ7L0MCh5E0WIKCehDCRrQBi27Ox7H/95ayB3czc9vN3IKRphpxIAGs7eMdwW6xihlx//6Ejx2G8eBGdlbterPnbxxGXu9scAguzzyHSDZLekevIO74ZClhziSgNrP9xYqZNT4vPsIXUMBomqCJKSzCtdH9Os6QJ0SQmY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvp2Sm7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvp2Sm7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644DEC4CEF7;
	Mon, 23 Mar 2026 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275751;
	bh=fkwf5R4dKaUaky0XAP1SPXQKuZG7uTxdfuOM5BQhdYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvp2Sm7bwfV5laCz8AKhkiGVbYW6q8waaycczyOZqR+0eDpQdcke62/UfBP6bSYOz
	 Maj8jlb6Wwu2tAI0bsLb1H5eUDzFdh+ShSubDXAHv1byTEJ9dFQ1+2mV5zcriBiR7p
	 47BSSqXKTF3pXquIFo5A+JV/zPaIK/UGp/sHZ+3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 6.12 207/460] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Mon, 23 Mar 2026 14:43:23 +0100
Message-ID: <20260323134531.611903438@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


