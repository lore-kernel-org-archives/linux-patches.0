Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF33B335067;
	Wed,  3 Dec 2025 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778265; cv=none; b=pfVcGU7pCDFzVT7sQ3GtVj01ZPOcpw2Qq06i4pCdhh9CgWO6zg5bQy0RbfperdDSN3NYLjL9rdcSDPhWjMkb/0/Obw8O9cu29IdcHWngEqYZ5fPYkTKi+Z7Gp4arrvSnc/pX0fzhg8bRXV5rmuaLCrErwuEi0WTIH2JX3+ypuRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778265; c=relaxed/simple;
	bh=7Rarqk5Zto9gXmY6PXYhQ6jX7q5nMFOXZLiOjIwHycE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG0SwZu9lyDhoPZcR1uQEaJJt4+w44roeILpFhsNhfnOHs+6EOZXObGBzp1GhQ5jZBCRqtkF283b16QtfD8VIzDEpxQDHP2MIHMzDu5yja5R6eqEhd5VVa7Nq6vxTjVi/sYppDbHGGfBgc48c3/ci2Qi5kha/kNDOUm5N6K1tis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPhVFp2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPhVFp2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CCEC4CEF5;
	Wed,  3 Dec 2025 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778265;
	bh=7Rarqk5Zto9gXmY6PXYhQ6jX7q5nMFOXZLiOjIwHycE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPhVFp2cCHFR7NUg5Lk6WbiUt2RfzkbqIlfj83uluL08mOJc2h9rnyMPB/9FtDLGs
	 2v+Ean9n17nCAaCf1E/7OPLd6G3DOOsrPczlDAKeb+2Isz32FwgjdJoQrpXFtnio/Y
	 FLRcFYzWyHAt8LPXrfx2uLhNA1TZBh9v209jbK1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 293/392] drm/tegra: dc: Fix reference leak in tegra_dc_couple()
Date: Wed,  3 Dec 2025 16:27:23 +0100
Message-ID: <20251203152424.938787435@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
@@ -2982,6 +2982,7 @@ static int tegra_dc_couple(struct tegra_
 		dc->client.parent = &parent->client;
 
 		dev_dbg(dc->dev, "coupled to %s\n", dev_name(companion));
+		put_device(companion);
 	}
 
 	return 0;


