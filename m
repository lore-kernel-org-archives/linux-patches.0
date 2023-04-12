Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A5E2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F0DC433D2;
	Wed, 12 Apr 2023 08:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288935;
	bh=AaZnGgDqsWDGLy+0hDLUeAk3IV+nja+M/w+5G3rRoSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvYqKhQL1k5NlkBMqhHihNtS1MnYsHTTjegua+NEO+A9vDopfUz16+IsnCkGZb81s
	 JyOvx3M72XEbb0dwH242+QwHQXSq93MCPwldq76dHNF/B0LOQaDH+ewq2rmt1WoXS/
	 hs7m0iwZwR2wzLgP2QY7j7NVVlMg9NgtxbVRJA/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 073/164] iio: adc: qcom-spmi-adc5: Fix the channel name
Date: Wed, 12 Apr 2023 10:33:15 +0200
Message-Id: <20230412082839.863803113@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 701c875aded880013aacac608832995c4b052257 upstream.

The node name can contain an address part which is unused
by the driver. Moreover, this string is propagated into
the userspace label, sysfs filenames *and breaking ABI*.

Cut the address part out before assigning the channel name.

Fixes: 4f47a236a23d ("iio: adc: qcom-spmi-adc5: convert to device properties")
Reported-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20230118100623.42255-1-andriy.shevchenko@linux.intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/qcom-spmi-adc5.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-adc5.c b/drivers/iio/adc/qcom-spmi-adc5.c
index 821fee60a765..d1b86570768a 100644
--- a/drivers/iio/adc/qcom-spmi-adc5.c
+++ b/drivers/iio/adc/qcom-spmi-adc5.c
@@ -626,12 +626,20 @@ static int adc5_get_fw_channel_data(struct adc5_chip *adc,
 				    struct fwnode_handle *fwnode,
 				    const struct adc5_data *data)
 {
-	const char *name = fwnode_get_name(fwnode), *channel_name;
+	const char *channel_name;
+	char *name;
 	u32 chan, value, varr[2];
 	u32 sid = 0;
 	int ret;
 	struct device *dev = adc->dev;
 
+	name = devm_kasprintf(dev, GFP_KERNEL, "%pfwP", fwnode);
+	if (!name)
+		return -ENOMEM;
+
+	/* Cut the address part */
+	name[strchrnul(name, '@') - name] = '\0';
+
 	ret = fwnode_property_read_u32(fwnode, "reg", &chan);
 	if (ret) {
 		dev_err(dev, "invalid channel number %s\n", name);
-- 
2.40.0



