Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA8333CE90;
	Tue, 26 Aug 2025 11:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208716; cv=none; b=MrgVldHs7VS3Mh3Zemw14hrb3m/f3Rj26bPRRaz8cCoruNxcHrtSFjnscaBHct5QueZBEuQt5/Czcbg3ioKJX72bvbWluuSeMVsCx0M6nXaLbYlWKU7XULPRMDdOWo1g60jz9xnqyyZmnnq9JYVDEVwR5q+h+/DUAvM6tkUSGMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208716; c=relaxed/simple;
	bh=7bDDgzmOAgfZhKeApk01+K0b3BZnAhvHfYZCMfAbPDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9KXv/wHQTqdJ1oCHJfytHEjKHVlkrPzu70+h1hutVKrZhGMZiIwKQqgxh20iyIlkNklz67Stccaz3DpyW2hy5pgZcTADK/mX2JfD/+W4IxguMlxCz//f6hB2kfjbuaXlxgYDRjc6vPGfolEitW9MzS6f6YLHbL3cVSaOJmtSJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVOU9h/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVOU9h/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17510C4CEF1;
	Tue, 26 Aug 2025 11:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208715;
	bh=7bDDgzmOAgfZhKeApk01+K0b3BZnAhvHfYZCMfAbPDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVOU9h/SslIsBaOdD6yWAWhPvLNhEoVqYnntMuri7l+aZVLnVhkmmmx6izPWWIn3f
	 9dZjCrXenUyzzzWD62KsYJMLkjtp5NuDsa9LlxNlLkAoB7CePXQWDTlekU6TXuck6W
	 fjtuJVRX8kf3qiXKw1mR0pP7Q2nbWHttwgjW0C3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 6.12 218/322] most: core: Drop device reference after usage in get_channel()
Date: Tue, 26 Aug 2025 13:10:33 +0200
Message-ID: <20250826110921.269656515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit b47b493d6387ae437098112936f32be27f73516c upstream.

In get_channel(), the reference obtained by bus_find_device_by_name()
was dropped via put_device() before accessing the device's driver data
Move put_device() after usage to avoid potential issues.

Fixes: 2485055394be ("staging: most: core: drop device reference")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250804082955.3621026-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/most/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -538,8 +538,8 @@ static struct most_channel *get_channel(
 	dev = bus_find_device_by_name(&mostbus, NULL, mdev);
 	if (!dev)
 		return NULL;
-	put_device(dev);
 	iface = dev_get_drvdata(dev);
+	put_device(dev);
 	list_for_each_entry_safe(c, tmp, &iface->p->channel_list, list) {
 		if (!strcmp(dev_name(&c->dev), mdev_ch))
 			return c;


