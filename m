Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D1168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82EEC433EF;
	Mon,  8 May 2023 10:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542529;
	bh=eadT1um1fonIU1gkIfIOUAen4yVN/LhJ6PXOns8kotY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vwpw4o5zgAztl3e7HXda5IU4MPpzj8gGwik9ragQpuv32cvZJr0svB3/AY7hvWEWb
	 pOp3XX604ztfa44YJwHnASxgTmF1D2jVDkj3ilv0mRvAJo4YtuCA0MFu91h3dguqQ8
	 SdZdjFXz/Q/G6GeKWZVGtIYf85FDi53KyeG4q4p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 465/663] of: Fix modalias string generation
Date: Mon,  8 May 2023 11:44:51 +0200
Message-Id: <20230508094443.275277309@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit b19a4266c52de78496fe40f0b37580a3b762e67d ]

The helper generating an OF based modalias (of_device_get_modalias())
works fine, but due to the use of snprintf() internally it needs a
buffer one byte longer than what should be needed just for the entire
string (excluding the '\0'). Most users of this helper are sysfs hooks
providing the modalias string to users. They all provide a PAGE_SIZE
buffer which is way above the number of bytes required to fit the
modalias string and hence do not suffer from this issue.

There is another user though, of_device_request_module(), which is only
called by drivers/usb/common/ulpi.c. This request module function is
faulty, but maybe because in most cases there is an alternative, ULPI
driver users have not noticed it.

In this function, of_device_get_modalias() is called twice. The first
time without buffer just to get the number of bytes required by the
modalias string (excluding the null byte), and a second time, after
buffer allocation, to fill the buffer. The allocation asks for an
additional byte, in order to store the trailing '\0'. However, the
buffer *length* provided to of_device_get_modalias() excludes this extra
byte. The internal use of snprintf() with a length that is exactly the
number of bytes to be written has the effect of using the last available
byte to store a '\0', which then smashes the last character of the
modalias string.

Provide the actual size of the buffer to of_device_get_modalias() to fix
this issue.

Note: the "str[size - 1] = '\0';" line is not really needed as snprintf
will anyway end the string with a null byte, but there is a possibility
that this function might be called on a struct device_node without
compatible, in this case snprintf() would not be executed. So we keep it
just to avoid possible unbounded strings.

Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Peter Chen <peter.chen@kernel.org>
Fixes: 9c829c097f2f ("of: device: Support loading a module with OF based modalias")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230404172148.82422-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index c674a13c30558..877f50379fab5 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -297,12 +297,15 @@ int of_device_request_module(struct device *dev)
 	if (size < 0)
 		return size;
 
-	str = kmalloc(size + 1, GFP_KERNEL);
+	/* Reserve an additional byte for the trailing '\0' */
+	size++;
+
+	str = kmalloc(size, GFP_KERNEL);
 	if (!str)
 		return -ENOMEM;
 
 	of_device_get_modalias(dev, str, size);
-	str[size] = '\0';
+	str[size - 1] = '\0';
 	ret = request_module(str);
 	kfree(str);
 
-- 
2.39.2



