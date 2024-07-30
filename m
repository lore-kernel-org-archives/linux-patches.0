Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148041A76B2;
	Tue, 30 Jul 2024 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360463; cv=none; b=kNdYOGI89RCpn/wWaCOLi1ONWff5HXWEMIHIQ62vZ9ceQVrB8RnagHHQs46EHbfrvb1WZdZjpL8qiSkTNjOFdVq2v6y8k6NeYnYhl38bwue0ur7TrL0zZxcYfuXP8XAbhd54mXlSuCsF463yWzPBuBRRtFa3jXIAiWpU1VW/FbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360463; c=relaxed/simple;
	bh=Hojl+qyUSLVEntdsnxdTdjEj3gI4cEj5qf3Qkl1cTqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZ8xgm4Sd8k5XeIzFdtGD7eKnl7I1YT3wtfq43lScTWWIfP+FL7js3T+50chveQ3CNC8deneLeYiluwVGaTWBT9xgP2RSPW/8L2RojAChdkmpRnvXJGpv96sZOLa4194LA2Yek1k+tSrU6Jro93Gnr2Dz/gGDwRxi17rc3xtFmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGdEpu+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGdEpu+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E861C32782;
	Tue, 30 Jul 2024 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360463;
	bh=Hojl+qyUSLVEntdsnxdTdjEj3gI4cEj5qf3Qkl1cTqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGdEpu+oIx9Oc7ZzDtMg80UPjpAldwn042xwIYWhFTzOQoFhJBHUyaZUpLGRYwFrQ
	 rI61UviWw7Cyv13Tpn1K/+eTgvv7319AocOKoA+kNk4Ylk8zP5HNNevp37oxhQexzK
	 B6eS+8K8H7l+JNrLfmk9iX285YS3w1oQ6xq+xP7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.10 707/809] rtc: isl1208: Fix return value of nvmem callbacks
Date: Tue, 30 Jul 2024 17:49:43 +0200
Message-ID: <20240730151752.852081732@linuxfoundation.org>
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

commit 70f1ae5f0e7f44edf842444044615da7b59838c1 upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

isl1208_nvmem_read()/isl1208_nvmem_write() currently return the number of
bytes read/written on success, fix to return 0 on success and negative on
failure.

Fixes: c3544f6f51ed ("rtc: isl1208: Add new style nvmem support to driver")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Link: https://lore.kernel.org/r/20240612080831.1227131-1-joychakr@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-isl1208.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -775,14 +775,13 @@ static int isl1208_nvmem_read(void *priv
 {
 	struct isl1208_state *isl1208 = priv;
 	struct i2c_client *client = to_i2c_client(isl1208->rtc->dev.parent);
-	int ret;
 
 	/* nvmem sanitizes offset/count for us, but count==0 is possible */
 	if (!count)
 		return count;
-	ret = isl1208_i2c_read_regs(client, ISL1208_REG_USR1 + off, buf,
+
+	return isl1208_i2c_read_regs(client, ISL1208_REG_USR1 + off, buf,
 				    count);
-	return ret == 0 ? count : ret;
 }
 
 static int isl1208_nvmem_write(void *priv, unsigned int off, void *buf,
@@ -790,15 +789,13 @@ static int isl1208_nvmem_write(void *pri
 {
 	struct isl1208_state *isl1208 = priv;
 	struct i2c_client *client = to_i2c_client(isl1208->rtc->dev.parent);
-	int ret;
 
 	/* nvmem sanitizes off/count for us, but count==0 is possible */
 	if (!count)
 		return count;
-	ret = isl1208_i2c_set_regs(client, ISL1208_REG_USR1 + off, buf,
-				   count);
 
-	return ret == 0 ? count : ret;
+	return isl1208_i2c_set_regs(client, ISL1208_REG_USR1 + off, buf,
+				   count);
 }
 
 static const struct nvmem_config isl1208_nvmem_config = {


