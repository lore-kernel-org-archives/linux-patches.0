Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2172882C9;
	Thu, 27 Nov 2025 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255208; cv=none; b=X1WVw7g1s9Jsh/uNh7Gut9hgim6sdviTGLKq1z7xkmpVVcqzasPNpp7iiCdwGmlpfP05nvRYeLXDupND6HU9fMDIwrFl9gbH/OcB+GiHa5RQEwn52wAUjRPusgnIM0QPVCfKu9DZe7UiCo0xX519rT7zK/40Xi9N3Qic+5kFrUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255208; c=relaxed/simple;
	bh=m173meyssuiYBOsHc4/RN16jop9AfT/YnEH98fEiwqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDMBjAtlIlJOlk1n6k+EMP+YkbNbU1tWYoZ6/XtSOJQIbrCdPF4JL/ftLO0F2iOBq2SEX4ugKOkcZZLIdq8P/lMnAQnQmPlvv1NqWAviOb0iIY3o6Kp0StjpCjkm6/XweEW9Vpp4fwcMdHr/StQ0WCdDN6df8UyARJgtzz2IT3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6iQMmaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6iQMmaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC7BC4CEF8;
	Thu, 27 Nov 2025 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255208;
	bh=m173meyssuiYBOsHc4/RN16jop9AfT/YnEH98fEiwqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6iQMmaCtgaXahrY1WGSv8E4epUY2zcNPLZCkU5S4pCzZWTFUmqloGeaM8Atj0OYe
	 HPITfCEIzQGbdCMQNefShIxOKy4vBPLJf3ubk0kkupk/e2vqRQcrgNov9b0Ey4QE4v
	 yzxF9+ghm5OZWDnTPW43La1OJ6WTqJewCtZWbegI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 045/112] drm/tegra: dc: Fix reference leak in tegra_dc_couple()
Date: Thu, 27 Nov 2025 15:45:47 +0100
Message-ID: <20251127144034.490706978@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 4c5376b4b143c4834ebd392aef2215847752b16a upstream.

driver_find_device() calls get_device() to increment the reference
count once a matching device is found, but there is no put_device() to
balance the reference count. To avoid reference count leakage, add
put_device() to decrease the reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a31500fe7055 ("drm/tegra: dc: Restore coupling of display controllers")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20251022114720.24937-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -3147,6 +3147,7 @@ static int tegra_dc_couple(struct tegra_
 		dc->client.parent = &parent->client;
 
 		dev_dbg(dc->dev, "coupled to %s\n", dev_name(companion));
+		put_device(companion);
 	}
 
 	return 0;


