Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ECE1ACEDE;
	Tue, 17 Mar 2026 17:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766918; cv=none; b=G52+N3ALyr9ZNG8zBMRda0LerLkYvD+4MzQpz3sWw1XZ1caVIC5hgpyNJ7l05xzPPhhFYXbSqdBb1DPhBSDgfLgB2ynit0hcdz7xPuZ3EZZSF2EDCfGp/LRao6TveIfovRwxOwcDn+JgNPQZXwu5eGQ165dr8ve0SjNheZ3tzSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766918; c=relaxed/simple;
	bh=kPn8Pe3o4g4I+J5O8T6Ge7FxZ8CeRg9YU69aUSH1/Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DP7CUXNPGzwBudI0noBtO8ZP7SnB3uawyv/L/AzX7MTs4lj6AfFexE58fE4zNVFuNVm/a8kafooXbXhxTg28bimC+ZJRe51PztGJJvtJOk8NSlM/XooWehFpQ2e2bb+vY/2gC9GJu3Sl9b8V4VlVcvGX8wAfZQQboVKeXsvmXBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqA0d61Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqA0d61Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263F4C2BC86;
	Tue, 17 Mar 2026 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766918;
	bh=kPn8Pe3o4g4I+J5O8T6Ge7FxZ8CeRg9YU69aUSH1/Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqA0d61QPnZjvYPdZlVbuNjuSCWi2vtleKiomj4LIL25E+nKAwfD4lH/Ss1sslm3g
	 GhD0AjWGZ7+EXOG0SM0+nEcXCBj8B3XG0ya7PCoIvYl1rqjuqlZerN5QqN4lR1X5GR
	 cVI2PMgIWPtpIOpognhnnahhdqfse0ii+EOyPko4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 6.19 351/378] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Tue, 17 Mar 2026 17:35:08 +0100
Message-ID: <20260317163019.899960956@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -221,7 +221,7 @@ static int mcp4131_write_raw(struct iio_
 
 	mutex_lock(&data->lock);
 
-	data->buf[0] = address << MCP4131_WIPER_SHIFT;
+	data->buf[0] = address;
 	data->buf[0] |= MCP4131_WRITE | (val >> 8);
 	data->buf[1] = val & 0xFF; /* 8 bits here */
 


