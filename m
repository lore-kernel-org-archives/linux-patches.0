Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A9332144B;
	Tue, 26 Aug 2025 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207762; cv=none; b=BFGh3dYQAFz4rl80QUy425fFHMSya7SdhhAooaoiruOwsAwZZD8tRH+UKtYURm2j0VKUA/qq9WG4dM9wisHcE3LA4evJuOfyqukogaTgMKM71EtfyNMbI6nLb1XV2Me0F6tPO6fX0ISIjMjl9dIYiIA+mKwjFbhNQcgle1Q3xuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207762; c=relaxed/simple;
	bh=KMI+pmI4o9QQxwYY7NjPvlYRmU36lzzdAwo514y+Pxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj1vg1PSkkbEmJ8FWK7IaVyJUlMt+vc+iqrEY0JzSmh14hbAjNqvY1+qQi7FYSE+9zZx+GWIv7BXxpk5mmy9poFsM+TEJr780+mM5hGFyqmZc7Ifm3J7DqwdTUkDiEHEA7XbkgFlMoV69MTmhjirSkDum7nkpkd9foY64ed9KWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysJZ16YK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysJZ16YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F2CC4CEF1;
	Tue, 26 Aug 2025 11:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207762;
	bh=KMI+pmI4o9QQxwYY7NjPvlYRmU36lzzdAwo514y+Pxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysJZ16YKK2BD5uMLU3DAGJx+wPTXdrzwgHDpUDwP1/+sVuV22kDH+sDOOYte7USTv
	 ka3+otiOnvwaukJ48VsSX8dji37JYaQ5Kz5Gdfrj0UX+WVvH0GMz9+qR0hh2l81pdv
	 PH8vBBsKRb7ReQx2HXMag9ZXGcRaUSVteARHm3I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 6.16 307/457] most: core: Drop device reference after usage in get_channel()
Date: Tue, 26 Aug 2025 13:09:51 +0200
Message-ID: <20250826110944.951654481@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


