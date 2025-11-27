Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E2273816;
	Thu, 27 Nov 2025 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254926; cv=none; b=bFd9Qmygd2W942xJbqRBJwUHeSAL14681Lmh942i5/SRWRD47qNCdfgPIZg5NSaqgRZaGwRc/iDB5397tUdpdRiDvyOHp+YK5MpUrG4poulv4E9PYvIwEcOP2+d0+pnK6VcrPEMcVSwh7RVVXvs97RajI376P9NEXOe4C3+M7Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254926; c=relaxed/simple;
	bh=8MhS5lkgN6aUjIiJF0wnFyl3renRBKFYlInghju1U1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyoFqx4yOD+cdF76JMswMloCikRoKiebBH14STEPSN/y/pnDXtXEh0BXZri9VgkLMtzpyAVcZ02gUD6MLFFQrOWUMG1bZm0JKnsaJKQfUCKUvVIPgxz4+5E+wxO1mbGm0cCVLbF93cAXCL2heYxV/s9Nmomj/UafLfYi6pXrAFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBm6jZTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBm6jZTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F00C4CEF8;
	Thu, 27 Nov 2025 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254926;
	bh=8MhS5lkgN6aUjIiJF0wnFyl3renRBKFYlInghju1U1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBm6jZTVYyxEtRpUCHMRRLYPkA4AP8A9sRsHXAikpvN8g2axaaBsSevX6N7MPjazi
	 9KppLmCMkzxHfCDBvkRpeGMEQasEyY7QaymWBEH0bXbRjTlkWg9z40lPhT+3I4B+CV
	 sXwtXab/+UuPmkL24hjAh70osvi3Jy1BOtB1sbN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 34/86] drm/tegra: dc: Fix reference leak in tegra_dc_couple()
Date: Thu, 27 Nov 2025 15:45:50 +0100
Message-ID: <20251127144029.071584706@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3140,6 +3140,7 @@ static int tegra_dc_couple(struct tegra_
 		dc->client.parent = &parent->client;
 
 		dev_dbg(dc->dev, "coupled to %s\n", dev_name(companion));
+		put_device(companion);
 	}
 
 	return 0;


