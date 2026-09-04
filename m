Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CCB26AC3;
	Fri,  4 Sep 2026 05:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499693; cv=none; b=utN/B0AutxJgMgLQFqDQDY7D4SE8r8BpEBlABCxXQgvc+hqtrYJ3gXBuFFjK3g5zHYdLNdkeFDbxKiiWoaGlvOm7dnvXUoAlO/P+cUo/o01M1n8jR+WnvmYfu4HYObHh2MJM2JhN0xJnyescqYFyTDvD0jPiR01ASmbWDI+rvWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499693; c=relaxed/simple;
	bh=VUSse3haGEn9XjYWDcg2h5K2UbHgyuL6pHpo/gIFzhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/cC7qkXuPb5Xl2myXrWsY7VmZH+o88NP2Up+YZYvAQKZhECvHUTgR0NNnHN/E2GCFId1zV2cBCgP/Hi9HFsShFVzomAVyms3v8cfM9i/wrqUQFpAb/HvfMv4uBdZAbwlBXDkmrjl5gPo5CQW/oPVQsqfB7VZwvhE6DXzgS0FFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Jj/aaTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Jj/aaTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A171A1F00A3D;
	Fri,  4 Sep 2026 05:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499692;
	bh=+XP8Rj20B4d2oUsOoEKWf3sEHRq9bxXUFdXprYyZRts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Jj/aaTOr+OyqX3uGee4uH/BLhRczGjUlVHkY2QdwR8FvwiFDAjYanSnGZsRvsrvm
	 1k6cErTDdBAQtHxa51ybTLWjSu3kU2RlGUP6hWXAsFUbrPc4/HmB3RMLhONY1HCqUw
	 CALpMpmgtWIIgFOWTskk0vBigU746kMARFYE00/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 508/713] power: supply: qcom_battmgr: terminate the strings from firmware
Date: Fri,  4 Sep 2026 06:57:56 +0200
Message-ID: <20260904045815.209122824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1232,7 +1232,7 @@ static void qcom_battmgr_sc8280xp_strcpy
 		memcpy(dest, src + 1, len);
 		dest[len] = '\0';
 	} else {
-		memcpy(dest, src, BATTMGR_STRING_LEN);
+		strscpy(dest, src, BATTMGR_STRING_LEN);
 	}
 }
 


