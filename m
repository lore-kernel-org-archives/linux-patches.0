Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255FE35BDAE;
	Wed,  3 Dec 2025 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780081; cv=none; b=dz+8bQOwzaHPXCIKWHdQSvDfnVy9iwOd6mFOHKdN5v39jzuLgUgkHvhtYPWhXViNUdp6IvfzPt/hlbHOuXYBdV+tcm5uzStJTw+3b8nypv1ch4Y9c4t9odDy7yKuKzUaK9Awrn0q9v7yB2OCSImT7MvtsWuq+burj8GCaLc3PvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780081; c=relaxed/simple;
	bh=EyhENrqjcdsk2j5twZY24VC8FT7iotyCaw2X2GrsKTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8+Jp/ALkm5jpiniAVIJWas569QUjTze/1DQaWjEvk/M79rrRjr1kv0DW9kBhSpqdwdknhdCjbT8+/GRh9edZsxx8Ag5geg1lmlZHoGMwlFa8K5bshM7S++6LY9FcsuMBtIH2uRwHVOPFIgnKxOt9GvcYr/epvzjGt0TKqy2VnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jp2LXA0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jp2LXA0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8872BC4CEF5;
	Wed,  3 Dec 2025 16:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780081;
	bh=EyhENrqjcdsk2j5twZY24VC8FT7iotyCaw2X2GrsKTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jp2LXA0HxdrKpYKxaHNcRlzRL8SXweRqr+B/As400dk7U4kclXfKEGn6ju/FDCALZ
	 0UK+OYFpAiFwSkIHs0cwqeNbGT5myfph+lQvLLJn0x+rxhg1H0JqK5obvO2xd4dfaD
	 rPap2/7XYiHZqMCMgHbZZhDbmnuLIkPI5/WBYZf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 449/568] drm/tegra: dc: Fix reference leak in tegra_dc_couple()
Date: Wed,  3 Dec 2025 16:27:31 +0100
Message-ID: <20251203152457.152764852@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3141,6 +3141,7 @@ static int tegra_dc_couple(struct tegra_
 		dc->client.parent = &parent->client;
 
 		dev_dbg(dc->dev, "coupled to %s\n", dev_name(companion));
+		put_device(companion);
 	}
 
 	return 0;


