Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E607B17A93F;
	Tue, 16 Jul 2024 15:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144963; cv=none; b=HWOcB+KXNbQRWwLe6utJU15oHB0wtD18ipWZRHESVJVhCThpYDy7hKpM8hbaRJB077ucK28ph89m7P3Yr/ROxET5d1cRZv7qyfZu/JDIngFCvfLMAISGNddVtby7dbaGJ18YLVzJCOzZODKNNgt52fYW8RT5nxNyTrcA3jAIfEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144963; c=relaxed/simple;
	bh=FseyPwoll+V/CnTyhBxynFMlqlq71e1xJX1SbDNYZ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9QJobTk5/ebzB4Y8NCIVcQLi7wgYJGKWXAIwM9HK1NFC0VsyF5Qj9uJR4N3redA24S25nxFYi+CbxJEIPqODpsyYp9KHa5JeZCeqkaTfv9P/Ugz/aQ8P45VyJExzevv9QfDaYSRodrDosp64UvbsrbZLRgU1+ohkkcox7FtoXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr7f2OTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr7f2OTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68199C116B1;
	Tue, 16 Jul 2024 15:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144962;
	bh=FseyPwoll+V/CnTyhBxynFMlqlq71e1xJX1SbDNYZ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr7f2OTGzopb9lOYOsoKIzwMwFcfX311+qJtBboHHe/HKuTItq0FqB23QnwnhOl2u
	 scsL0IQKGka1V/rQDZBeAsQYqqobj0A4ci4en8/ZvnJFWY26JYJHCOot2cCjHPZTvD
	 K55Oq08S+llYgz3Is7IeP3ZP4QH+SN/HKx/mwpdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 052/143] firmware: cs_dsp: Return error if block header overflows file
Date: Tue, 16 Jul 2024 17:30:48 +0200
Message-ID: <20240716152757.986142538@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 959fe01e85b7241e3ec305d657febbe82da16a02 ]

Return an error from cs_dsp_power_up() if a block header is longer
than the amount of data left in the file.

The previous code in cs_dsp_load() and cs_dsp_load_coeff() would loop
while there was enough data left in the file for a valid region. This
protected against overrunning the end of the file data, but it didn't
abort the file processing with an error.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240627141432.93056-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 5acd6611dba31..27eb0b0fc9ad2 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1390,8 +1390,13 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	cs_dsp_dbg(dsp, "%s: timestamp %llu\n", file,
 		   le64_to_cpu(footer->timestamp));
 
-	while (pos < firmware->size &&
-	       sizeof(*region) < firmware->size - pos) {
+	while (pos < firmware->size) {
+		/* Is there enough data for a complete block header? */
+		if (sizeof(*region) > firmware->size - pos) {
+			ret = -EOVERFLOW;
+			goto out_fw;
+		}
+
 		region = (void *)&(firmware->data[pos]);
 		region_name = "Unknown";
 		reg = 0;
@@ -2079,8 +2084,13 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 	pos = le32_to_cpu(hdr->len);
 
 	blocks = 0;
-	while (pos < firmware->size &&
-	       sizeof(*blk) < firmware->size - pos) {
+	while (pos < firmware->size) {
+		/* Is there enough data for a complete block header? */
+		if (sizeof(*blk) > firmware->size - pos) {
+			ret = -EOVERFLOW;
+			goto out_fw;
+		}
+
 		blk = (void *)(&firmware->data[pos]);
 
 		type = le16_to_cpu(blk->type);
-- 
2.43.0



