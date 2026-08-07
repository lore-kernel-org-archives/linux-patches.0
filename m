Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E861929AB1A;
	Fri,  7 Aug 2026 15:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116721; cv=none; b=JNnOg7xQD3u8Hl1c63oR6NLzojuZSwv99IbMRzNxgwUPSedbGRclxd4iAc+8aDX8xy+XaJFfqGljlbi63CvL9ud42C8HCkNwAUg9GTZf1Q7iulB5IhloqT+7KTqsw5J98nt/zRMQ4ldX2avZHDfgJwbTuCKcF6XSC0tjfqN7+yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116721; c=relaxed/simple;
	bh=BZS9kIueWdYXruUW/6jSP91plHuwr31hZtNJDMiZtHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1HAL2V908tSE/HFwvE/E14SIxdBnMbe3e1wMy5qY2qiFjSIw3lTXyKwFfyu+05NgZAamdiIwJPOkqVUDLdLkXlJjF4XBLvRK9VFg21nqRUjr+qqePihXT4amHqTHXZXxvfsxEG0jwTzPxvlttZ3Vu55lUadhtg2+ufclecsugo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgxyM0x7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgxyM0x7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ECE1F000E9;
	Fri,  7 Aug 2026 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116719;
	bh=a4/Y/pS4aWJzbHeFC5RC55LLTSjb9VU8na0tlIBhEqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgxyM0x7H2qdokjTzTyStuxW3V7Z8I+1gkM/gtr/qr0gYU/tLy2rASYbuzXUUihfo
	 LPVn2QUk9Ci39VqJqd2tpY4Jlpj9mhYO7Y2SfhVTkfsK5Tl18nkhQd9/ODKmD+WWnG
	 rpofzm9d4wERVRplfCPCQ0Bl7+S7ohUjk169ZEFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 065/438] ASoC: SDCA: Always free firmware in FDL path
Date: Fri,  7 Aug 2026 16:34:21 +0200
Message-ID: <20260807143429.376811325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 7f64ccc374b2fe1f6a169182e95ab8e104cae406 ]

In the case a disk firmware exists but is invalid and no SWFT firmware
exists fdl_load_file() will return without calling release_firmware().
Update the code to call this to ensure the firmware is released on the
error path.

Fixes: 71f7990a34cd ("ASoC: SDCA: Add FDL library for XU entities")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260722103500.872714-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_fdl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdca/sdca_fdl.c b/sound/soc/sdca/sdca_fdl.c
index 994821a6df617..60fdd406220d4 100644
--- a/sound/soc/sdca/sdca_fdl.c
+++ b/sound/soc/sdca/sdca_fdl.c
@@ -258,7 +258,8 @@ static int fdl_load_file(struct sdca_interrupt *interrupt,
 
 	if (!swf) {
 		dev_err(dev, "failed to locate SWF\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto error;
 	}
 
 	dev_info(dev, "loading SWF: %x-%x-%x\n",
@@ -270,6 +271,8 @@ static int fdl_load_file(struct sdca_interrupt *interrupt,
 				     SDCA_CTL_XU_FDL_MESSAGEOFFSET, fdl_file->fdl_offset,
 				     SDCA_CTL_XU_FDL_MESSAGELENGTH, swf->data,
 				     swf->file_length - offsetof(struct acpi_sw_file, data));
+
+error:
 	release_firmware(firmware);
 	return ret;
 }
-- 
2.53.0



