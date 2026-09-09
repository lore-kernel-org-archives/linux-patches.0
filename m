Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E2E569F0E;
	Wed,  9 Sep 2026 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962661; cv=none; b=Rj/bx57W7iet8UGnULaj2ed7WCr02c66JORroP2ca/KY80bvbAD0WTy1dNs7e1T8Jgr70/6zyfIeG/NkWgo0HOLHotxXpMylxSSvRVI2PW1OoY8YiSy4F537iK1DZa3K2AqqsJGubwADEWHTjTeqCG1ZFf+1mH/lox6o+8pgnyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962661; c=relaxed/simple;
	bh=na56MAyNKmEAsDcRArrvkhIPeq4p2Ej7GAVNcqt5g0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s26ms371kOW1jp9gAvZdMAehvfOO+ZKHBex3isbqqBgoaKPvfdvbFErkQ1NyINpEfdOhpFmStFFfrha3lNFH6vS2AZHPMlElNcii/pameqqFFhNBz7iy3fBKIJXVCwj7sUgN+ZxFev3/l38vJQv3bXKcmJYo2OfEBMypSySnPv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khIH9tvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khIH9tvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C09F1F00A3E;
	Wed,  9 Sep 2026 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962659;
	bh=LxAe7KpKsaEKXvI1PvkP5t0zGrPu95i1heqkOx8E3Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khIH9tvFYWRVMxMfYkW/tdtZtfmJ44YjmT+FPYGR336VLX0iWzFlGG2R6v7V5lFC6
	 ZtBxwYSdQve6Rp5JuMOBuniKDQjyb/pD2qvoJlXMXu/aKFGspq58GjJUwEAl6Cv0Nm
	 SliR9j8qGy3f6IKrCAdsBvRyGNESNjl9ScsE4QqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Richard Leitner <richard.leitner@linux.dev>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 367/556] media: i2c: ov9282: restore flash duration calculation
Date: Wed,  9 Sep 2026 15:40:47 +0200
Message-ID: <20260909134243.588711931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Leitner <richard.leitner@linux.dev>

commit d836f57e8ab971c1cd3b607d9e466513f654e644 upstream.

The migration to CCI helpers made V4L2_CID_FLASH_DURATION write the
requested duration directly to OV9282_REG_STROBE_FRAME_SPAN, dropping
the conversion from microseconds to the register value.

This made flash strobes too long and produced overly bright frames.
Restore the missing calculation so flash duration is programmed
correctly again.

Fixes: 273f52f3cbec ("media: i2c: ov9282: Convert to CCI register access helpers")
Cc: Xiaolei Wang <xiaolei.wang@windriver.com>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Leitner <richard.leitner@linux.dev>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov9282.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/ov9282.c
+++ b/drivers/media/i2c/ov9282.c
@@ -648,7 +648,8 @@ static int ov9282_set_ctrl(struct v4l2_c
 				      ctrl->val ? OV9282_OUTPUT_ENABLE6_STROBE : 0, NULL);
 		break;
 	case V4L2_CID_FLASH_DURATION:
-		ret = cci_write(ov9282->regmap, OV9282_REG_STROBE_FRAME_SPAN, ctrl->val, NULL);
+		ret = cci_write(ov9282->regmap, OV9282_REG_STROBE_FRAME_SPAN,
+				ov9282_us_to_flash_duration(ov9282, ctrl->val), NULL);
 		break;
 	default:
 		dev_err(ov9282->dev, "Invalid control %d", ctrl->id);


