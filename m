Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8847E299A94;
	Tue, 26 Aug 2025 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213970; cv=none; b=GpXQd0Q0OrpPDc650oeoJEyMp5L7PszcW/D7j4JCvOe9G8fhiYlD0QRK9se0itWwyYWMhUG56175tvsU4jWeiDUTN2w7ULx24U2+t4LOUeV7mSee4ignwDra4TZi/i4bn/96dDvdXJT8QAK8Q6U+531j36foj7XsXf58ZwmaVU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213970; c=relaxed/simple;
	bh=ImaaN4mw6LXqUH5ewBs4s42dGEorvSWwwcmK57WeyrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuafyuZdnTZR6AxapA5Fdxggew5o/aPsb/dnXPoGjzPHmDkfIL6wDnhK/DU0jqhdY9A54tvjUz0FEvxLN5HJY5hJP14xUN27BaClBYCbs6oC/49tUIhBlUFKDG9HA8anaAMSVBcjedWPKkTyiciRSjlj8Nk5S8GsZPmv2SzyIso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEdHGM5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEdHGM5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF44EC4CEF1;
	Tue, 26 Aug 2025 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213970;
	bh=ImaaN4mw6LXqUH5ewBs4s42dGEorvSWwwcmK57WeyrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEdHGM5nJ9V/i7sKtbcI3OlwH0FM/9IS5+Rygkhh2mGZmTdq2Kq1q3DosVbdoPRtk
	 QdlGmy9ciRQxM9hCnMiFJzk3+gf6FQjaBvHaOpmy7RlMJeuFLmfUPz0dWK3DtYZkVr
	 5B4D1NSUGZtytCm2v80N3cHDiLlzvaVMy2uMTD0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 6.6 517/587] most: core: Drop device reference after usage in get_channel()
Date: Tue, 26 Aug 2025 13:11:06 +0200
Message-ID: <20250826111006.148015879@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


