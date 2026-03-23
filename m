Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCBE386554;
	Mon, 23 Mar 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278594; cv=none; b=aRA7qIBYhYyQUppKbSWYjn44Ksf/oZjbL+ijQ/DucHB9KIZsvHLtlARjd5+tuCAg7d0G8PE0jFHJLN6slvfHuYeFBPZ0RDHfB5QhMViimCvpnig/IUpLa9PEJ7bLt3Lib59pKbazeqeWB+mAe+z4+BOaRnkwX292+S32gmc41iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278594; c=relaxed/simple;
	bh=kiVveZPzTLz1q0GUCHkonSbnlQQ38dzTm/lJ4HIYLGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omqh2EOx8kkSueWohM7Q6vkZlGUycmJCVgMnH3Je5GONHrWDoCTRKSiWQ9aV0lrJ1CPzZEJDuaz28Y1alzv7tGYYw00F9Y29mj+rF137PtLvYzsEwXPECWB4z3JnqibvbJxWhVdHx8zhdRm+SWgbeLtEuuZLYbRM6bHmU3/KqYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UASbQimX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UASbQimX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6518C4CEF7;
	Mon, 23 Mar 2026 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278594;
	bh=kiVveZPzTLz1q0GUCHkonSbnlQQ38dzTm/lJ4HIYLGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UASbQimXh/u6Dz1nfdO1AICDwbpl9REiwDOAaD6H6HyKeyAfNKS2eBi78gRALN+WL
	 k8KuX9dXl50yfHFHSM0uzIEFDkj/QsABXY//1P9KfRS6whOeoh5JY5UkDizsl183m5
	 PXuhlFs5WkrofiOwTfMajslP7FwTl3GYOA0UbjM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 6.6 356/567] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Mon, 23 Mar 2026 14:44:36 +0100
Message-ID: <20260323134542.642475534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


