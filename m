Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175B13D75C9;
	Wed,  8 Apr 2026 18:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673953; cv=none; b=Q28QNDupSN6tHccBPVKREBHRCTBI5IcLq3QJohOntPqz+OnwkL00xPOZEV36/oUfLU507fQk7fKIMq3mtNzV7Nlzwwl4ncXBsQckkL3rNpV/wfk+KDS/TlHP91n5zn9xERzF/AT7CmSFZSxYSQkI77vkKOFa6iR4aHB/KxQwn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673953; c=relaxed/simple;
	bh=oR2inzQHTcbJ6s46dqaY4MxXVlp16nnjwXYdcJan9E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOQJ8sV8cBKe8XhrCgAk0qO/SIsETpCt1XXVbIaZ/5lGWiu2IbNkZdkOtKFSKYNImuCVxjtIOHYHXN6dGjtzOv8LlRA+S/jR442h7E22c2AZg0nTgFWF92weoB5D6QqX7HQFhvZ88AFeh8Li4mSZkZwO+A1L+IgwWxldFyakwU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUrxMSM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUrxMSM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F5FC19425;
	Wed,  8 Apr 2026 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673953;
	bh=oR2inzQHTcbJ6s46dqaY4MxXVlp16nnjwXYdcJan9E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUrxMSM8uM/ugXUEvWz/3DO/TenkDEIGc+D91+bQuwK5Zl252hwvHWl9AS5116hSL
	 kFR5T8/8LOqVVsBhoj9st2Zgl26hPcCVHet1MxOX4Oa0bB+olPbaRaoUzVAgZv823h
	 xkRU8Kxi7psIRtJJsgZjBroyh42MWe2lScJZpviQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 153/242] iio: imu: bmi160: Remove potential undefined behavior in bmi160_config_pin()
Date: Wed,  8 Apr 2026 20:03:13 +0200
Message-ID: <20260408175932.817197424@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit c05a87d9ec3bf8727a5d746ce855003c6f2f8bb4 upstream.

If 'pin' is not one of its expected values, the value of
'int_out_ctrl_shift' is undefined.  With UBSAN enabled, this causes
Clang to generate undefined behavior, resulting in the following
warning:

  drivers/iio/imu/bmi160/bmi160_core.o: warning: objtool: bmi160_setup_irq() falls through to next function __cfi_bmi160_core_runtime_resume()

Prevent the UB and improve error handling by returning an error if 'pin'
has an unexpected value.

While at it, simplify the code a bit by moving the 'pin_name' assignment
to the first switch statement.

Fixes: 895bf81e6bbf ("iio:bmi160: add drdy interrupt support")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Closes: https://lore.kernel.org/a426d669-58bb-4be1-9eaa-6f3d83109e2d@app.fastmail.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -573,12 +573,16 @@ static int bmi160_config_pin(struct regm
 		int_out_ctrl_shift = BMI160_INT1_OUT_CTRL_SHIFT;
 		int_latch_mask = BMI160_INT1_LATCH_MASK;
 		int_map_mask = BMI160_INT1_MAP_DRDY_EN;
+		pin_name = "INT1";
 		break;
 	case BMI160_PIN_INT2:
 		int_out_ctrl_shift = BMI160_INT2_OUT_CTRL_SHIFT;
 		int_latch_mask = BMI160_INT2_LATCH_MASK;
 		int_map_mask = BMI160_INT2_MAP_DRDY_EN;
+		pin_name = "INT2";
 		break;
+	default:
+		return -EINVAL;
 	}
 	int_out_ctrl_mask = BMI160_INT_OUT_CTRL_MASK << int_out_ctrl_shift;
 
@@ -612,17 +616,8 @@ static int bmi160_config_pin(struct regm
 	ret = bmi160_write_conf_reg(regmap, BMI160_REG_INT_MAP,
 				    int_map_mask, int_map_mask,
 				    write_usleep);
-	if (ret) {
-		switch (pin) {
-		case BMI160_PIN_INT1:
-			pin_name = "INT1";
-			break;
-		case BMI160_PIN_INT2:
-			pin_name = "INT2";
-			break;
-		}
+	if (ret)
 		dev_err(dev, "Failed to configure %s IRQ pin", pin_name);
-	}
 
 	return ret;
 }


