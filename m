Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F75426D0C;
	Tue, 31 Mar 2026 16:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975257; cv=none; b=sVScQXR+fCB318d5NAqIgv6i1YfW6xV8pAShkjnmDFRwpNcTpLJ3LFI1CD3xoKWc46C00vvsQkT8DMkMWT/tuq8xRj2JL7hcUazvL0ZfkCdA0ck+vFGMG7f5ureP2+5jfK9+huEnnRd/+nZ+Lsp6O8rR5j5NRcshQ3igpyp3whU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975257; c=relaxed/simple;
	bh=emOdB+1TWdJYpMhB9jW8BVn9+ZYNYrBywKCrwlYqZBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqt6BFQMbtzxGvlmZPjVohFdG8UhX4eSF4fAcv+vQ87K85PSfe1nqCdpROEpKWV6kg/84/x6nJellpA/nBuUcAiedfclUvxF9CvmUa9zW1zRG+OwzxRfpvuHMgunHvKl4t0KN9lLbvnNDswtmUx2gHCYakYrNrAu4NGXb4Bg4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIRxxhqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIRxxhqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18263C19423;
	Tue, 31 Mar 2026 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975257;
	bh=emOdB+1TWdJYpMhB9jW8BVn9+ZYNYrBywKCrwlYqZBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIRxxhqXcBADHjDqyHqSl5VGAA1K8x0KiT/TKHv9rIi2bapn8tgQHCMdvXeg5n/+s
	 /QMO9ZWx5moha2SFOocVR0ytVecAzn50OruIdrlLljMSxkqS8JzgoHglJrTZChkZDq
	 Yow4E5JrydbsUd3wYgrsf3flswRn1oQBCYLLUAEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.19 224/342] hwmon: (pmbus/ina233) Fix error handling and sign extension in shunt voltage read
Date: Tue, 31 Mar 2026 18:20:57 +0200
Message-ID: <20260331161807.212428844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit f7e775c4694782844c66da5316fed82881835cf8 upstream.

ina233_read_word_data() reads MFR_READ_VSHUNT via pmbus_read_word_data()
but has two issues:

1. The return value is not checked for errors before being used in
   arithmetic. A negative error code from a failed I2C transaction is
   passed directly to DIV_ROUND_CLOSEST(), producing garbage data.

2. MFR_READ_VSHUNT is a 16-bit two's complement value. Negative shunt
   voltages (values with bit 15 set) are treated as large positive
   values since pmbus_read_word_data() returns them zero-extended in an
   int. This leads to incorrect scaling in the VIN coefficient
   conversion.

Fix both issues by adding an error check, casting to s16 for proper
sign extension, and clamping the result to a valid non-negative range.
The clamp is necessary because read_word_data callbacks must return
non-negative values on success (negative values indicate errors to the
pmbus core).

Fixes: b64b6cb163f16 ("hwmon: Add driver for TI INA233 Current and Power Monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260319173055.125271-2-sanman.pradhan@hpe.com
[groeck: Fixed clamp to avoid losing the sign bit]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/ina233.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/ina233.c
+++ b/drivers/hwmon/pmbus/ina233.c
@@ -72,7 +72,8 @@ static int ina233_read_word_data(struct
 
 		/* Adjust returned value to match VIN coefficients */
 		/* VIN: 1.25 mV VSHUNT: 2.5 uV LSB */
-		ret = DIV_ROUND_CLOSEST(ret * 25, 12500);
+		ret = clamp_val(DIV_ROUND_CLOSEST((s16)ret * 25, 12500),
+				S16_MIN, S16_MAX) & 0xffff;
 		break;
 	default:
 		ret = -ENODATA;


