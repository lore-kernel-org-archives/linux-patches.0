Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC31533F5BC;
	Sat, 12 Sep 2026 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221827; cv=none; b=SquIUyfbFpdHT9ZYac6b7HMA9UgqFwoV6Qv/lXgqq/V/HWd+9oOPyp3oP6W0H2R4mGWgBAGkd0ugOsBFJExZLsnUCGMls9407DsEgQue+G7ulhINiAGTWGFqPGmWyuI15Kpc+w9R02CKg9Hyk4gOQA3loqqyFPHsIuOnLveX/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221827; c=relaxed/simple;
	bh=WFVQeFRoPkQSdC/KTEhTWrX4s1NaR0Rm41VW20BDM+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMa796dkejqZWKI4JV5MiFr6g5PSbSt1QgzIc81GEauDeU/+nEkC+VSPHkrhH9fw9Z1bIcrgYhJvNc8cK76lLrDh9T/itrpyzaKdk69clFoDIlOOJoKkZ5LUQ++fEkCaUJ7s1zZiBo5vYAU1s3yC95B9Q5jsh9bM6FMBF1eWUpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5hqdRhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5hqdRhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B017C1F000FF;
	Sat, 12 Sep 2026 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221825;
	bh=7cutZQO8j4HIwH5JfC51hNmWtuu6WLLnXFb7dRnw1Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5hqdRhhrT3XYZ3MwGO29/BsKGv0GEksLRiF3mTBJXFFCvoVTRZJMsGS2SYg60IWv
	 4F28kySyTFcyNt+oyJfB3DvN89TniH/oDLGWH+K54ECKaDrMRwliJ5vlq+4dbwkDGR
	 5UZMidocRdzi5UxMBl826a2CQN5PtKKQ+Uxh8AZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0462/1424] media: s2255: check firmware size before reading trailing marker
Date: Sat, 12 Sep 2026 08:48:14 +0200
Message-ID: <20260912065617.633158255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

commit 330f2936ab768c7215322a476f033143e8891d28 upstream.

s2255_probe() reads a 4-byte marker and version from the last 8 bytes
of the firmware blob (fw->data[fw_size - 8] and [fw_size - 4]). If the
firmware file is shorter than 8 bytes, fw_size - 8 underflows and the
access reads out of bounds. Validate the firmware size before indexing.

Fixes: 14d962602c8b ("V4L/DVB (8752): s2255drv: firmware improvement patch")
Cc: stable@vger.kernel.org
Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/s2255/s2255drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2288,6 +2288,11 @@ static int s2255_probe(struct usb_interf
 	}
 	/* check the firmware is valid */
 	fw_size = dev->fw_data->fw->size;
+	if (fw_size < 8) {
+		dev_err(&interface->dev, "Firmware invalid: too small.\n");
+		retval = -ENODEV;
+		goto errorFWMARKER;
+	}
 	pdata = (__le32 *) &dev->fw_data->fw->data[fw_size - 8];
 
 	if (*pdata != S2255_FW_MARKER) {


