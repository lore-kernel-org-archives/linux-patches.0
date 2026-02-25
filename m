Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D30F2BAF7;
	Wed, 25 Feb 2026 01:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983062; cv=none; b=Lt8mPZ/zCQkPKdXpEMN+lPmHoAW8MbCfXmvopoyJaIQs16eyXFltOz8AOKqfILQ1WzTgqWhqTXvswWWWSbmkma0VoGVj4OonYOIEFQgemtDjvW67c9hSphu22A0o3PJbBI5EdOXtpoaOs9XAri6b1oeYYNTfGauPN+iRtS3PGO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983062; c=relaxed/simple;
	bh=FcbP9avNqIts48pxlw3t7/2c24iGo7YeZudnFhZUY7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMsg8ugyM7L0jnfDdjbt7uNDRB+irkGcRKbCNVCuaNzxPyr5u2TA75ankFsH4FyrVuL8/+j5tn2MTSrnMlt2Goa0aBT7qAb80N3Ahoyq2cv6e6HH6d9GGo+UEytgePjPPEJUuSzUPpZUdELmYVZadL15ZwuBzNBhHIwitwxKZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXkigoeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXkigoeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4EEC116D0;
	Wed, 25 Feb 2026 01:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983062;
	bh=FcbP9avNqIts48pxlw3t7/2c24iGo7YeZudnFhZUY7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXkigoeJi29XXmXm1w8Q6xRGZhd9xhh6hXiOSGEsmCNxxRXC+k/RZNzIyj29otnZp
	 yECugxcBi2qaZORBdZ6Fe12+GY0f/fEMcZBMRD0QPeP1aUG6mQATFChJVXY1b4SVZv
	 unlZ98LdaZC0vqvIZxi3bzDsFrUB3Y2kI/NzUu10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 208/781] firmware: cs_dsp: Remove __free() from cs_dsp_debugfs_string_read()
Date: Tue, 24 Feb 2026 17:15:17 -0800
Message-ID: <20260225012404.817411563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7a9fa7fda93b7b3ae515f40f67bbf8e1d16337e8 ]

Don't use __free(kfree) in cs_dsp_debugfs_string_read. Instead use
normal kfree() to cleanup.

The use of __free() can create new cleanup bugs that are difficult to spot
because the defective code is idiomatically correct regular C. This
function used the suspect declaration __free(kfree) = NULL;.

The __free(kfree) didn't really do anything here. The function can be
rearranged to avoid any need to return or goto within the code.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 3045e29d248b ("firmware: cs_dsp: Append \n to debugfs string during read")
Link: https://patch.msgid.link/20251202113425.413700-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 73d201e7d9927..57296f48dad0a 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -412,18 +412,23 @@ static ssize_t cs_dsp_debugfs_string_read(struct cs_dsp *dsp,
 					  size_t count, loff_t *ppos,
 					  const char **pstr)
 {
-	const char *str __free(kfree) = NULL;
+	const char *str;
+	ssize_t ret = 0;
 
 	scoped_guard(mutex, &dsp->pwr_lock) {
-		if (!*pstr)
-			return 0;
-
-		str = kasprintf(GFP_KERNEL, "%s\n", *pstr);
-		if (!str)
-			return -ENOMEM;
-
-		return simple_read_from_buffer(user_buf, count, ppos, str, strlen(str));
+		if (*pstr) {
+			str = kasprintf(GFP_KERNEL, "%s\n", *pstr);
+			if (str) {
+				ret = simple_read_from_buffer(user_buf, count,
+							      ppos, str, strlen(str));
+				kfree(str);
+			} else {
+				ret = -ENOMEM;
+			}
+		}
 	}
+
+	return ret;
 }
 
 static ssize_t cs_dsp_debugfs_wmfw_read(struct file *file,
-- 
2.51.0



