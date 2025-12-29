Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CBF3346BD;
	Mon, 29 Dec 2025 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026064; cv=none; b=aia9Q0+jwHGEzuvQ8vk9V2BMeU4FOcaESVxFPSPemibl+ZFY+T7ZxicyWg7uOxa3ZVUyp8Tg4vvTKPeeud8nXTszZpS8cTfRQUGQWZoRFsm5QQMAep1kIWhpWN7Ozoumh+iS4DB5nrvcjIDXEDS5wLEixAHUQe+6bSBsxk7O3sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026064; c=relaxed/simple;
	bh=VcgVSZGpEvla5dndGBwfIfe8A89wcXkmHK3MwCZRIts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKUPMcpPsbI9RAyHjJ+pWVtqxXFk0KaE95qKZDKuxzgPP7ZtuP2bPMMxH3WDN63HiRj7nOe9t+y23IsctqfX8NVt/tzqqUvxoo3TJqheTIGZnNrkXIAQYBjNYpi35qYsvaDUe8Xdpx934S7xfxwcjDsCUYCt1EafVlHdJGFeNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OozxvwwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OozxvwwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51BFC4CEF7;
	Mon, 29 Dec 2025 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026064;
	bh=VcgVSZGpEvla5dndGBwfIfe8A89wcXkmHK3MwCZRIts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OozxvwwHSm/SPyX5KlLxAlQ9mBqbFPX+hO/HMymuwzYxN6iWOszqC/Ck+a7N7j1VI
	 S2ZMc5TxjA0uZ23PFHbB8JlnsXLQjkrpAXo5fzCHoJEk3BtzXXB28g9jN+2TuJbRUF
	 xsVG/I3uj6ZicuBIC+nyse+qnKSTC6qFnfdIqTOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 419/430] hwmon: (max16065) Use local variable to avoid TOCTOU
Date: Mon, 29 Dec 2025 17:13:41 +0100
Message-ID: <20251229160739.731340336@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

commit b8d5acdcf525f44e521ca4ef51dce4dac403dab4 upstream.

In max16065_current_show, data->curr_sense is read twice: once for the
error check and again for the calculation. Since
i2c_smbus_read_byte_data returns negative error codes on failure, if the
data changes to an error code between the check and the use, ADC_TO_CURR
results in an incorrect calculation.

Read data->curr_sense into a local variable to ensure consistency. Note
that data->curr_gain is constant and safe to access directly.

This aligns max16065_current_show with max16065_input_show, which
already uses a local variable for the same reason.

Link: https://lore.kernel.org/all/CALbr=LYJ_ehtp53HXEVkSpYoub+XYSTU8Rg=o1xxMJ8=5z8B-g@mail.gmail.com/
Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compatibles")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20251128124709.3876-1-hanguidong02@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max16065.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -216,12 +216,13 @@ static ssize_t max16065_current_show(str
 				     struct device_attribute *da, char *buf)
 {
 	struct max16065_data *data = max16065_update_device(dev);
+	int curr_sense = data->curr_sense;
 
-	if (unlikely(data->curr_sense < 0))
-		return data->curr_sense;
+	if (unlikely(curr_sense < 0))
+		return curr_sense;
 
 	return sysfs_emit(buf, "%d\n",
-			  ADC_TO_CURR(data->curr_sense, data->curr_gain));
+			  ADC_TO_CURR(curr_sense, data->curr_gain));
 }
 
 static ssize_t max16065_limit_store(struct device *dev,


