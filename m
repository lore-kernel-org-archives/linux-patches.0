Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C62923BD1B;
	Fri,  4 Sep 2026 06:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502763; cv=none; b=XeX4IHdsBNpCSmTWvr+HzZN9VbAhm5bGIF3Gg8LcvbBu51WVYndA7BGtavFxWgr9iYKTnk2uN+77fg9P8JGd0nd1EmSlWMStfnOz2Mh0DdQYH3zu8xBN/QYqbdKhF0RCWsmL3qV0AGtr7jQ2ABQbN+owc1mLk1o/w5M34dhSF/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502763; c=relaxed/simple;
	bh=0fbSNY2oOnjx2pgEvEh4JPcm9zsvKxGkg6/6yP+gjWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru+eYMr2EFRtY2N0slbj9qY+IH4gqCTbhK5ZfBOpKJvhW78xv/8xmAWOgdbFwB3eoP6FdDsxY3PI68czY0CQHed6nu1bcLAkEPlDvjommcFYodfzRYT6fjqF8egPlfH95EiiBkeh/f9hNRErnHYYsccZDV5o8yWo0cOZ/o5vdGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yah3zpgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yah3zpgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795A61F00A3E;
	Fri,  4 Sep 2026 06:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502762;
	bh=/HiIgRLpgLp4ty6Rnrr9IjPMTUjV3+XgklYPTehrAjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yah3zpgfEagG2rkBbREWZrepvOUE9B+/ScrsWDXV3vUMwthXAoxLX+d/mBa5XQzr5
	 LBf3fuecWUcBxhaj4R+LmF0RnaNRvO3NIjq0FiAdBP46mEvv08QSJ0EY3Q9359CjIX
	 py+YaucJ5Ju2K0bbNKEv1rYndCscZw6wopNHdeyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 278/403] power: supply: qcom_battmgr: terminate the strings from firmware
Date: Fri,  4 Sep 2026 07:01:21 +0200
Message-ID: <20260904045741.182618675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit ab1112df8f4ffa88cb024dd370c432ced80f77d8 upstream.

The qcom_battmgr_sc8280xp_strcpy() takes a Pascal-style string when the
firmware sends one. Otherwise it copies all BATTMGR_STRING_LEN bytes and
leaves the destination without a terminator.

Those destinations are model_number, serial_number and oem_info, each
BATTMGR_STRING_LEN and declared next to each other. They go out to user
space as val->strval, which power_supply_format_property() prints with
"%s", so a firmware string that fills the whole field makes that read run
into the following members.

Use strscpy() so the copy always terminates, the way the SM8350 path
already does for the same field.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260727074119.2585463-1-sammiee5311@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/qcom_battmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -976,7 +976,7 @@ static void qcom_battmgr_sc8280xp_strcpy
 		memcpy(dest, src + 1, len);
 		dest[len] = '\0';
 	} else {
-		memcpy(dest, src, BATTMGR_STRING_LEN);
+		strscpy(dest, src, BATTMGR_STRING_LEN);
 	}
 }
 


