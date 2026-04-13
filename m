Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D3F24DCF6;
	Mon, 13 Apr 2026 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097563; cv=none; b=EmGF4loJ6FrzWzGviDSu2bsVAz4X8I/V4ikvIsnJ+m5UDTab1YIwr4EBGSSRUCpOjESrXvE4aMSh1RnmTdOR8zYxIKb4SMq/RI56AGGAP8DMYNQmtgePPp3aWQqKsniNt+XRmDux8xc/CQhQW8+RMZx3C62ZU/qUL4O/DQs6M/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097563; c=relaxed/simple;
	bh=UX8e2KZalV6QWojrXU30ppgnbP52PB7AkazrPd8M5kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQHi7cVX1mzIk2p1eFEZjIdTV7oH+nmORS0tzuzn+y7KAch+H1kpg9/EGVtekxLcm5Cm4Cv+NQDXXQF8xcMJOnGC4HRkqr1ns7RWd+MZ9dx2TbKAiiCa+DIaf9OhzgzoJSQxEfB3HwfBb9QkOmhyddVovTobGPhFXrnxOuDdPEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4eKiDWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4eKiDWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAC7C2BCAF;
	Mon, 13 Apr 2026 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097563;
	bh=UX8e2KZalV6QWojrXU30ppgnbP52PB7AkazrPd8M5kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4eKiDWAzJibqgeetHh52f4fdPuPPj7S67yZ5fIbTfjg03g+GvGHPkVCrRtg+tM0w
	 FSVMkcBmhBP8rnv3FhlEqJR1wAAZhn+t+npq4J0Et4wji5MfK7g7ejHYfJFWUqf8YG
	 QJXqzp+I3xj1fKMJH8FOGBNFjDlcr0c9VqRB2KNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 5.15 185/570] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Mon, 13 Apr 2026 17:55:16 +0200
Message-ID: <20260413155837.387756857@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


