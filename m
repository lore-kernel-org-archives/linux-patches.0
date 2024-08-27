Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339951C57BE;
	Tue, 27 Aug 2024 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770158; cv=none; b=q3XjK5nXXIln7Rh2p9L0FCnIvZ/F0g/4bF5cBK8YRNztLTzfJob/P5yVmMKjNL70Zvwk+W2GoIP1SP0bxJjT5h9+E5BX4XYXNuQ1h9ekSk9sHJIMNIUxmtXmYxmOj9V3eLSxbeAmUrYVsrWZLlwNn9Zj8tWLzbTFQpwdE+D+RlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770158; c=relaxed/simple;
	bh=o/9xEUXYA6GrVwe4ILpaOhsA1lQAMvTGZXVGMqVBQxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz9I+88Jn6gLwm1x405ixeS/dFyAB5jytRQbOaT8woF8CdKbpbXfKyJ67lvJByJ6SkZgv+V/Xjkdup3z3We5MImzwPkF9UFQ2QEURasV/IEGqA/TTpXwn/bs4E1bOqhUUpvs6cF0dGOxcMBaio6048B4K2OcbKjUwI3vdXvECvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmOzSZ5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmOzSZ5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79453C4AF13;
	Tue, 27 Aug 2024 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770158;
	bh=o/9xEUXYA6GrVwe4ILpaOhsA1lQAMvTGZXVGMqVBQxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmOzSZ5lZStJyC3ib1QS1uEg5oPmJbuCJ76BB41vczSK8FAju2TXkRR71OVcWLS+p
	 N8E2dPkRBSdEhMskxDlq4nYFaa4kLS7XSSTLuWyu/Bdw794zgmwv2l0znVeJkypEQw
	 KYBlcblGt5/J+KRXl6/zn0RA1wInyxFkT7VWlG5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Cromie <jim.cromie@gmail.com>,
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/341] hwmon: (pc87360) Bounds check data->innr usage
Date: Tue, 27 Aug 2024 16:36:15 +0200
Message-ID: <20240827143848.899532703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 4265eb062a7303e537ab3792ade31f424c3c5189 ]

Without visibility into the initializers for data->innr, GCC suspects
using it as an index could walk off the end of the various 14-element
arrays in data. Perform an explicit clamp to the array size. Silences
the following warning with GCC 12+:

../drivers/hwmon/pc87360.c: In function 'pc87360_update_device':
../drivers/hwmon/pc87360.c:341:49: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
  341 |                                 data->in_max[i] = pc87360_read_value(data,
      |                                 ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
  342 |                                                   LD_IN, i,
      |                                                   ~~~~~~~~~
  343 |                                                   PC87365_REG_IN_MAX);
      |                                                   ~~~~~~~~~~~~~~~~~~~
../drivers/hwmon/pc87360.c:209:12: note: at offset 255 into destination object 'in_max' of size 14
  209 |         u8 in_max[14];          /* Register value */
      |            ^~~~~~

Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20231130200207.work.679-kees@kernel.org
[groeck: Added comment into code clarifying context]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pc87360.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pc87360.c b/drivers/hwmon/pc87360.c
index a4adc8bd531ff..534a6072036c9 100644
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -323,7 +323,11 @@ static struct pc87360_data *pc87360_update_device(struct device *dev)
 		}
 
 		/* Voltages */
-		for (i = 0; i < data->innr; i++) {
+		/*
+		 * The min() below does not have any practical meaning and is
+		 * only needed to silence a warning observed with gcc 12+.
+		 */
+		for (i = 0; i < min(data->innr, ARRAY_SIZE(data->in)); i++) {
 			data->in_status[i] = pc87360_read_value(data, LD_IN, i,
 					     PC87365_REG_IN_STATUS);
 			/* Clear bits */
-- 
2.43.0



