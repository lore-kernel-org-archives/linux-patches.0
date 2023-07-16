Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEA78F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCBBC433C8;
	Sun, 16 Jul 2023 20:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540657;
	bh=FISp+/7jh8TA3yVCR71QOZDw5MPMquYEOVGRdKn/YRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BstQ22ARVk+TKu8GI5qccudWnvVdz4mgxkyyQHyg0CLGJP9Y5vS6UgmY0Cf8H413O
	 QtJX1PndNJQr3Nn/yyWwzbKWxnX50U6IZgIbUEWwKialmcbSqLIjPW18K75E4F7+nD
	 ohexIvVXWdFotYB8wPKB8gfFR5foLAlpjpwdj3vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 442/591] drivers: fwnode: fix fwnode_irq_get[_byname]()
Date: Sun, 16 Jul 2023 21:49:41 +0200
Message-ID: <20230716194935.345323234@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 39d422555e43379516d4d13f5b7162a3dee6e646 ]

The fwnode_irq_get() and the fwnode_irq_get_byname() return 0 upon
device-tree IRQ mapping failure. This is contradicting the
fwnode_irq_get_byname() function documentation and can potentially be a
source of errors like:

int probe(...) {
	...

	irq = fwnode_irq_get_byname();
	if (irq <= 0)
		return irq;

	...
}

Here we do correctly check the return value from fwnode_irq_get_byname()
but the driver probe will now return success. (There was already one
such user in-tree).

Change the fwnode_irq_get_byname() to work as documented and make also the
fwnode_irq_get() follow same common convention returning a negative errno
upon failure.

Fixes: ca0acb511c21 ("device property: Add fwnode_irq_get_byname")
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Message-ID: <3e64fe592dc99e27ef9a0b247fc49fa26b6b8a58.1685340157.git.mazziesaccount@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 868adeac2a843..b0c40d9734847 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -979,12 +979,18 @@ EXPORT_SYMBOL(fwnode_iomap);
  * @fwnode:	Pointer to the firmware node
  * @index:	Zero-based index of the IRQ
  *
- * Return: Linux IRQ number on success. Other values are determined
- * according to acpi_irq_get() or of_irq_get() operation.
+ * Return: Linux IRQ number on success. Negative errno on failure.
  */
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index)
 {
-	return fwnode_call_int_op(fwnode, irq_get, index);
+	int ret;
+
+	ret = fwnode_call_int_op(fwnode, irq_get, index);
+	/* We treat mapping errors as invalid case */
+	if (ret == 0)
+		return -EINVAL;
+
+	return ret;
 }
 EXPORT_SYMBOL(fwnode_irq_get);
 
-- 
2.39.2



