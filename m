Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F56A2405EC;
	Wed,  4 Feb 2026 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217234; cv=none; b=geeE/wJqcKYi19cK40FKhwQElac++6LeYaT4M87HBcLivI/Tnzmpa1ZpZzxvz/JAbsSZCG2pfMNVLaDdr+DNZ0Is+THFo6u0l6lF/BPuca8WLORSBB5ZOmDQXuVfZYoOTs6GjPENq/iYkEgy3Nk4qnBuzGvtgXxCQzt1r9mFyKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217234; c=relaxed/simple;
	bh=BJA16gHOz2oOsEAI3mSUv1gw9bvXHAUhCyNqqkP9yLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEHuZfVKu2zprK7ucJ5FtZq0okkQOoCMVZ7ljTHkRP+9lL1OYXwx9ClvS0tqBM5q84Q/+FTFa1SUq8qBCoZ6bU/Go5ToPmSiV9W6OuG7BLIIu+RQ9VBKkr6YtePLT/IDvO7uhtUxCTVjLNF2BhCbqIDbn76G9ozTFrNMK653+lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUYVOFJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUYVOFJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA48BC4CEF7;
	Wed,  4 Feb 2026 15:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217234;
	bh=BJA16gHOz2oOsEAI3mSUv1gw9bvXHAUhCyNqqkP9yLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUYVOFJdB2bkeFI6Yc5pQyBbLAgPs+Q04Dkl37ycR3MuaI/rLEEWJ62Q27LZzoTt7
	 0jooR4jEgZU0Hjwe/1Jik9rHavtT/3eQ7TJLN7EA60S2qfWxvvVA+/HZ2ximBA40Na
	 nrxUh/a3IU76uahUrLcm62CrBWpzymMA8ct9fIB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	David Yang <davidcomponentone@gmail.com>,
	Yang Guang <yang.guang5@zte.com.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/206] w1: w1_therm: use swap() to make code cleaner
Date: Wed,  4 Feb 2026 15:39:53 +0100
Message-ID: <20260204143904.040923510@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit e233897b1f7a859092bd20b10bfd412013381a10 ]

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Link: https://lore.kernel.org/r/cb14f9e6e86cf8494ed2ddce6eec8ebd988908d9.1640077704.git.yang.guang5@zte.com.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 761fcf46a1bd ("w1: therm: Fix off-by-one buffer overflow in alarms_store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_therm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -1782,7 +1782,7 @@ static ssize_t alarms_store(struct devic
 	u8 new_config_register[3];	/* array of data to be written */
 	int temp, ret;
 	char *token = NULL;
-	s8 tl, th, tt;	/* 1 byte per value + temp ring order */
+	s8 tl, th;	/* 1 byte per value + temp ring order */
 	char *p_args, *orig;
 
 	p_args = orig = kmalloc(size, GFP_KERNEL);
@@ -1833,9 +1833,8 @@ static ssize_t alarms_store(struct devic
 	th = int_to_short(temp);
 
 	/* Reorder if required th and tl */
-	if (tl > th) {
-		tt = tl; tl = th; th = tt;
-	}
+	if (tl > th)
+		swap(tl, th);
 
 	/*
 	 * Read the scratchpad to change only the required bits


