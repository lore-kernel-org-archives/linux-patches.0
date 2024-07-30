Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AE21A76B4;
	Tue, 30 Jul 2024 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360466; cv=none; b=c0Co4i3Ihbj2mBAPx49wEQLhNKH9XnDbjaMfSm7tc7T9jC6iijVeMaX1MBo9rnNBR+1K16ANtJpHJ5t2A6ba6WPBzMi+RQgByU0yap3jsgjPun3luuPPijIDMB4/fbm0EF5f2o9kloSXxhBdHBpECqYAIK3lk+7uZ1rf9vzdMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360466; c=relaxed/simple;
	bh=tkReMl3okzirED4Dgp9K6oE21F4PSzZkXq7tLcDM4oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV1ZILN4WGVlqGt7taty/n1/WgMy9TFz418QBPZ6w64i598U8xVpbjxEHconGzNCe1yHQjfRRYoYDUuzZHBveW5mYp/m8CKMEE3rmYY5X6p6gqyFZC7CH42Bw+hwQO4ARSpAU8gacNn3cqeMeMV8zcPadPtFBxfBhK0w+E4pnOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJhvpQ88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJhvpQ88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1CCC32782;
	Tue, 30 Jul 2024 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360466;
	bh=tkReMl3okzirED4Dgp9K6oE21F4PSzZkXq7tLcDM4oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJhvpQ88S9RQhdhp+f1+aOKnl646xc3ivVqk0sido82Xh+5T+/kK5LS/mcJXsTVP4
	 QTHegQB/ko6TyUZZ0+kvlvrKkPZi+9eEZyBaROthnJhsYORt8RZODPIxhQHFhwP5c5
	 2Jn4gyDp4uWQ0gG1TCeKzuIIZKcbCkYxNcqp5mOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sean Anderson <sean.anderson@seco.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.10 708/809] rtc: abx80x: Fix return value of nvmem callback on read
Date: Tue, 30 Jul 2024 17:49:44 +0200
Message-ID: <20240730151752.891655295@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Chakraborty <joychakr@google.com>

commit fc82336b50e7652530bc32caec80be0f8792513b upstream.

Read callbacks registered with nvmem core expect 0 to be returned on
success and a negative value to be returned on failure.

abx80x_nvmem_xfer() on read calls i2c_smbus_read_i2c_block_data() which
returns the number of bytes read on success as per its api description,
this return value is handled as an error and returned to nvmem even on
success.

Fix to handle all possible values that would be returned by
i2c_smbus_read_i2c_block_data().

Fixes: e90ff8ede777 ("rtc: abx80x: Add nvmem support")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240613120750.1455209-1-joychakr@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-abx80x.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -705,14 +705,18 @@ static int abx80x_nvmem_xfer(struct abx8
 		if (ret)
 			return ret;
 
-		if (write)
+		if (write) {
 			ret = i2c_smbus_write_i2c_block_data(priv->client, reg,
 							     len, val);
-		else
+			if (ret)
+				return ret;
+		} else {
 			ret = i2c_smbus_read_i2c_block_data(priv->client, reg,
 							    len, val);
-		if (ret)
-			return ret;
+			if (ret <= 0)
+				return ret ? ret : -EIO;
+			len = ret;
+		}
 
 		offset += len;
 		val += len;


