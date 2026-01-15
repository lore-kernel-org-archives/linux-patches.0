Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F883AE701;
	Thu, 15 Jan 2026 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498335; cv=none; b=gBpqiu5jPFrDFK61HX35I9rsUhAjCYkEVDzp9HyQ5kNfRjqJCY8QH6aSNYjjxkBGXAHEwupB9aT0kdabm7qjouzBY7lj3I37LDpmggYkSnm9Mr3eEJWdP21YIhbVo7EnDIUcJhbCAVlTq3EFYOHO/Dxl495iYwFCJFWelEuriAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498335; c=relaxed/simple;
	bh=Qc75mJcGH02Bba9l7efjPebYCxz08WLObBFtjD8pwPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTY+Ajydt4US0F1MO3NxCMSiDnp9iuwWNXB96b6wrbclKvSsXgMBAU+mzWFpgaJ1eszaaWXdLwlHqFqJv6Oq9Cf5b8ZnPP9WVjLfik2Fdat0Fc4Ya5sdU9jnBAxUMBg7xpgCHr42Bevyq/AZMFk+h1MY41FGYgWUGYf7hNegCfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKf2RRKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKf2RRKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DED6C116D0;
	Thu, 15 Jan 2026 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498334;
	bh=Qc75mJcGH02Bba9l7efjPebYCxz08WLObBFtjD8pwPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKf2RRKZL35efywMhO/MWWcd41tbDnTRjV9lyv/hmlwVoXlGV6ugPicVzE3skIFfm
	 mjeGSUWqxYjI8sebNJ3FNbyLtmCBBW+ZEwIoqe7duj+Zg2X5AauamDM3IivVfsvvym
	 DCBxSivi9oTn7Y3PV2yFF97ZOeibkRkf2RXgvT/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 396/554] media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()
Date: Thu, 15 Jan 2026 17:47:42 +0100
Message-ID: <20260115164300.568897322@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

commit d2bceb2e20e783d57e739c71e4e50b4b9f4a3953 upstream.

It's possible for max1 to remain -1 if msp_read() always fail. This
variable is further used as index for accessing arrays.

Fix that by checking max1 prior to array accesses.

It seems that restart is the preferable action in case of out-of-bounds
value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8a4b275f9c19 ("V4L/DVB (3427): audmode and rxsubchans fixes (VIDIOC_G/S_TUNER)")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/msp3400-kthreads.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -596,6 +596,8 @@ restart:
 				"carrier2 val: %5d / %s\n", val, cd[i].name);
 		}
 
+		if (max1 < 0 || max1 > 3)
+			goto restart;
 		/* program the msp3400 according to the results */
 		state->main = msp3400c_carrier_detect_main[max1].cdo;
 		switch (max1) {


