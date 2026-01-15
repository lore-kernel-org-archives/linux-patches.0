Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8763BC4C9;
	Thu, 15 Jan 2026 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498155; cv=none; b=sk+yNZMkX4676ojf63ROFZzGq206rfyVn2tS74Nz/MQa67qb5SExaCax3R4xNYDH1SqWJMXZpNgwVV2iiRizR61biGXyBPegVjm6ej5FTPK0zz7Idl40e4vXMWGzkpmqQAX2kJG9y92+YifPP1TmH7H54g/wmPikk026+g06pGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498155; c=relaxed/simple;
	bh=gj+glx0lMmER5PVtUXxIRlOfhsAVv8a3CXRZtJQ23+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgmavEDU/6LbZKuzPkxcw4ZOaT+PczR7Ib0qj61AQZhqPdeFFe7DTH33/gS79PHowvsYZcthJs+0aGlkgJC0NO48FsvVl9MWNxgG6SCoHeEoTI08ptNmImmAqS68MkB9RHx7kB9YgR4s73CdxGNOEHsza8uzqjFrU3jVCW/yPGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCo9T/bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCo9T/bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1561CC116D0;
	Thu, 15 Jan 2026 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498155;
	bh=gj+glx0lMmER5PVtUXxIRlOfhsAVv8a3CXRZtJQ23+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCo9T/bRSxd+jOyMAmkhUoHv2RfhKNK1RUbgUo4mmT2mQKvYakC3hFa6SAfSCg0Fm
	 o4iXTdb5KhnaUdbXno7RoWnFFC2xjUS41G+lmHlMrh4qJ0UXpOvxtV399bXqjNyjsq
	 zVaYSx3vReSCAUHLwmR1Y/wLK7qrweB6f6PGESE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 332/554] hwmon: (max16065) Use local variable to avoid TOCTOU
Date: Thu, 15 Jan 2026 17:46:38 +0100
Message-ID: <20260115164258.248685114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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


