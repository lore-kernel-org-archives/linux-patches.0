Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3524826988C;
	Tue,  8 Apr 2025 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117002; cv=none; b=r+wDAGIDFLB5LJ4k1UdaDQs+0fo1LEXbt3j3V7ZlRwKhvJoRhT1Rq16g2FuZQPuVw/7ZS5ddZTZbKxZWpt9SHZ0wccKCDZtDKb0EXKbOdZIaXyCD+BhVImWlSpdOMkiJ7uS4/yKDWyThe8YoqAMmQMWUjXu/w9YvTVBtXF5OWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117002; c=relaxed/simple;
	bh=cyG994foBt5zP9HLpYcOcLGrJOwgfsQhKvANz0evN2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ0MLnJFyIJ4RoVZq+NmW/4bkCER5AzzO4DaOaTJNVfoA2uixpplxD8ozIpR/Dqos3cln0Z4Vt5CL2UIlObF5ZMR7wkHEdmSy1ahwfmQZ6V4JIyG6HScAt1yroj0d6u7hqlh23X26nWQElmxLpHsSmYiVJvay1ybIRaQPv+qn5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfn1e+z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfn1e+z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A5C4CEE5;
	Tue,  8 Apr 2025 12:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117002;
	bh=cyG994foBt5zP9HLpYcOcLGrJOwgfsQhKvANz0evN2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfn1e+z412k9Lb8V2k62BnpgFYH0yYv73jWizvyEmd2avapvcxlpc1CoaydUKw3VI
	 5jjTf1RWwDSmqeciYXLnAOrUXVDiPrUW2m3yzCfm+ozRTQRgWaJy3BTzI5Gupwext7
	 pgmtaQclIudQIhFObtUux7hUG/RKrkr0dVYRAntg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/423] firmware: cs_dsp: Ensure cs_dsp_load[_coeff]() returns 0 on success
Date: Tue,  8 Apr 2025 12:50:34 +0200
Message-ID: <20250408104852.974915792@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 2593f7e0dc93a898a84220b3fb180d86f1ca8c60 ]

Set ret = 0 on successful completion of the processing loop in
cs_dsp_load() and cs_dsp_load_coeff() to ensure that the function
returns 0 on success.

All normal firmware files will have at least one data block, and
processing this block will set ret == 0, from the result of either
regmap_raw_write() or cs_dsp_parse_coeff().

The kunit tests create a dummy firmware file that contains only the
header, without any data blocks. This gives cs_dsp a file to "load"
that will not cause any side-effects. As there aren't any data blocks,
the processing loop will not set ret == 0.

Originally there was a line after the processing loop:

    ret = regmap_async_complete(regmap);

which would set ret == 0 before the function returned.

Commit fe08b7d5085a ("firmware: cs_dsp: Remove async regmap writes")
changed the regmap write to a normal sync write, so the call to
regmap_async_complete() wasn't necessary and was removed. It was
overlooked that the ret here wasn't only to check the result of
regmap_async_complete(), it also set the final return value of the
function.

Fixes: fe08b7d5085a ("firmware: cs_dsp: Remove async regmap writes")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250323170529.197205-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index bd1ea99c3b475..ea452f1908542 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1631,6 +1631,7 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	cs_dsp_debugfs_save_wmfwname(dsp, file);
 
+	ret = 0;
 out_fw:
 	cs_dsp_buf_free(&buf_list);
 
@@ -2338,6 +2339,7 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 
 	cs_dsp_debugfs_save_binname(dsp, file);
 
+	ret = 0;
 out_fw:
 	cs_dsp_buf_free(&buf_list);
 
-- 
2.39.5



