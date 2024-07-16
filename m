Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71A719F499;
	Tue, 16 Jul 2024 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145357; cv=none; b=Rop8zwWucFpM3PNb/yTcXBtDVVWdWYEoyKvYaSoERTcnC/6s//TiBg6vnF6sh78SN921HYmjKRA5m/9o/QjVmgma750YHC9U9C5jgSWx8R026oyTqxTAKXvBI6rWQMuuZDnwU2dq7x7UDgTjvwc0kJp9vFq8lSgiEmCP7CFWAMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145357; c=relaxed/simple;
	bh=IbdNYdEkVuwT11hHNWbpRcYClrL8mwBJW0IbsVtSQp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwjlXSTV8NXJ3BVzIDCYgB61dm523W0KpfrjJI6BuLcasn5C5ifp6vTIdZfNiAm3dHUbjxZofvYRpLjI7RKa7rGEt99cAhg7QeT9j7kmBxfskp6LHKbv+eYVOqNQhH0sB1MWmEj9hSQrPLd1Mtf3EGxkuIw4f+BhQkIqjKROauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRoLsfnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRoLsfnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC1EC116B1;
	Tue, 16 Jul 2024 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145357;
	bh=IbdNYdEkVuwT11hHNWbpRcYClrL8mwBJW0IbsVtSQp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRoLsfnua5+5snfo7/iC06xdvZaUzlpfA2/oGxEpy8907+t585mhwnFU0ytBnbVN1
	 C3/n+k9k733VCxAcZxPN8UgN8XKrQrNlcIMAR6XSI9U8jPjwEsCAqrTS+eS02UHfFW
	 zXxZsojWu+5eHnDD8rCncdbO00wMOAg1660rFjYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/96] firmware: cs_dsp: Return error if block header overflows file
Date: Tue, 16 Jul 2024 17:31:43 +0200
Message-ID: <20240716152747.749364924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd1145b2894b3..208c799af7968 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1348,8 +1348,13 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
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
@@ -2037,8 +2042,13 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
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



