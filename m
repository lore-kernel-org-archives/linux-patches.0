Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6586B3DAAC9;
	Sat, 12 Sep 2026 11:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213872; cv=none; b=NRJvoqnrb+2RFjdPTquev5kLf+KEC2UJdSW5cv+JzP8rvffMRhJ9dGiqEHbHYSHBAom8TIfTr8hMcQFV1cVePEK2TyATL760uZivr1fxCIz+uwMhYwkh+NDl+RucdFBG81NxbNILolp4FtjjCmXTQe/2SSX0/wxEti2POv3BycY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213872; c=relaxed/simple;
	bh=GgIosqygAKHZhOM3wtMfxVENewWuLBXU8NOyr0GZrfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0I6fnzJWP6o/vVkLihCYNE/4TgD4eZOqgSXSO3udIyGf+iJYhI+MGmNwIq6iTzbY6b4lwYvSLR0EGlnEgkNN2RWmRjSp5AW4AjLNwtPWbdQWaEZds5e5LGh6SFOHras5A5tcOGbU5UsJMwVKfRhu3GGm6mNWyzYsCR0oNwKl5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1+32AZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1+32AZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BA11F000FF;
	Sat, 12 Sep 2026 11:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213870;
	bh=iDb8RuUDl5xi+/2ILGYy/sz8LvhgRoAtJdo+tCWa8So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1+32AZUoZ1UATl75LATlWgz6cHfspM8t3VOFfcMYpRE6aLc/+aiCUGrhdgo8mokX
	 cHDF/YFmtZ7S4rnF/ab7jEoVQFFOa1ptbnKHRlGpDMwaQbJdK1XcSEnhEACDRZHd/N
	 wZL0eC0SJ+P/MeYM/ML8JQRqMmx6SocRv/6Xjhro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0210/1376] media: tda18250: fix possible integer overflow
Date: Sat, 12 Sep 2026 08:43:56 +0200
Message-ID: <20260912065612.228450808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Ilya Krutskih <devsec@tpz.ru>

commit 6dd8e257f7cafda7fbf10d81b3c55c9bba4825f4 upstream.

Integer overflow may occur, when variable exp equals to zero. Result
of shift 1 << (exp - 1) may then leads to undefined behavior.

Fixes: 148abd3b5b14 ("media: tda18250: support for new silicon tuner")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Krutskih <devsec@tpz.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/tuners/tda18250.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/tuners/tda18250.c
+++ b/drivers/media/tuners/tda18250.c
@@ -440,8 +440,8 @@ static int tda18250_pll_calc(struct dvb_
 		goto err;
 
 	exp = (uval & 0x70) >> 4;
-	if (exp > 5)
-		exp = 0;
+	if (exp == 0 || exp > 5)
+		exp = 1;
 	lopd = 1 << (exp - 1);
 	scale = uval & 0x0f;
 	fvco = lopd * scale * ((c->frequency / 1000) + dev->if_frequency);


