Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5022571DD;
	Thu, 17 Apr 2025 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915783; cv=none; b=WGqyKKWb7BDEEH6UnsKJiNiuq+i/u/v+b0QxhI+JpZSx2LI+lRUl29NtQWlPBS8ylX7zizBwlQOj1W8RTerm1MCcf7CZLuKmpPOCfw2rDZ0hi2mOLzH9dyGLDwSlbLJLcrkxC/5sElzhSwrX3DgKTD6bz+LyznQAhx0sQ8LxHYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915783; c=relaxed/simple;
	bh=r4p6OJOcYaraDNTW8T2n3vlqMWcxQvCAPHIVEXnsGg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrkUbv2GVzbMwxpYQMwlqWdtq0nT3eSlnzqRfXfB7EEzXiqqEnNksfdaPeP1cf4Fg+hoiAXcAJBTsCNWvc9IZyBw0lLN4FRw0PwNoHseERjr7uInI+1tBtSUWSOUbZEK9zIGmtBQZKbehaB4gs+oURMLhp3sFBBJIEwTcqyAeWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6Tgukj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6Tgukj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A43C4CEE4;
	Thu, 17 Apr 2025 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915782;
	bh=r4p6OJOcYaraDNTW8T2n3vlqMWcxQvCAPHIVEXnsGg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6Tgukj35enRRtDjXbur0XHHBbMhE5y7Deaib+LIzNjnRg7YeyfzDpXfmTbSEEPXX
	 L1Z0rpPbRWt4F033qPjO6E8E39UMR+6xTTEcBF2C19SJBNb73I9tyv3RmFrAUn6uhC
	 d2c55rd3+eoMlfDdddgGbhIPA7kPdZKEJvGXDmMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 221/393] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Thu, 17 Apr 2025 19:50:30 +0200
Message-ID: <20250417175116.475859124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 3d391292cdd53984ec1b9a1f6182a62a62751e03 upstream.

Lift the xshutdown (enable) GPIO 1 ms after enabling the regulators, as
required by the sensor's power-up sequence.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -922,6 +922,8 @@ static int ov7251_set_power_on(struct de
 		return ret;
 	}
 
+	usleep_range(1000, 1100);
+
 	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
 
 	/* wait at least 65536 external clock cycles */


