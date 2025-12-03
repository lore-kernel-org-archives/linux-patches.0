Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA93F3164D0;
	Wed,  3 Dec 2025 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776579; cv=none; b=CzlYvJE+phqWx7KcZ46Mzav87i84RtzWxM5e+gKPjS61+krPFSG9/srYxhlH525RK+SB2TajTA4lmh2Ej3dkDnWYpea10yG80g9upEj68wSRhoTkhtgv/0y9i8N7J+1jOeXURXhQfS7Bb1ozuvlQohAbV+Xv5wQhNkA7GJB78hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776579; c=relaxed/simple;
	bh=uW6pD6sfuiy5eIlGsW1cdDm21JbyKKUPgRRdOlNVOIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9fv8WZ+++puCI5k1XdGO/3ko4X9PlSN3PzBiSXn5wZkI1yZCAYHa8CmKiUjbm3eF3KJbLLUkJTrUcYNqSn+91lJrVarCyaM8oBszbK4ueFE/8iFcQQXA8v71sMBY6HbqKN4+kqONGWWwf6EDKJ9+nKY+21DweeseapTKA3lL2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdZNmmxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdZNmmxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0F9C4CEF5;
	Wed,  3 Dec 2025 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776579;
	bh=uW6pD6sfuiy5eIlGsW1cdDm21JbyKKUPgRRdOlNVOIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdZNmmxGOHum2NNixf8K5v9O70pqzLPj/i/EIM3h70HE0TNfJBGzjg/qKWo2Rul6R
	 JkFN89CF3rEUODG3QudxRFo8KsioQqm64BHM1AJmgrCGQA6tXjfiFyeyLwsMUDRgnZ
	 2cdYDadD+dw+FduW9VwIkHbk7EiAnr/c4Z1LEk+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 225/300] drm/tegra: dc: Fix reference leak in tegra_dc_couple()
Date: Wed,  3 Dec 2025 16:27:09 +0100
Message-ID: <20251203152408.961220512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2524,6 +2524,7 @@ static int tegra_dc_couple(struct tegra_
 		dc->client.parent = &parent->client;
 
 		dev_dbg(dc->dev, "coupled to %s\n", dev_name(companion));
+		put_device(companion);
 	}
 
 	return 0;


