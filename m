Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835201F75A6;
	Tue,  3 Dec 2024 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240177; cv=none; b=BHEgaJq+7WfUGPauOqAFkBjLY+IPn+Db3LCr4JDqHIRgaVQx4K/m5qrKHo35i2EQ0QICEKLYU6lP8JDviXftPYVg+ykyoSZUvKoQeO32nXD98VewKUTHDBZRtTY1Uy5YnM+2UQtwoZQiadAaQpCSm5p2IQZOpPJDBBx33QSnaXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240177; c=relaxed/simple;
	bh=dMSpPAOfRPVbvKZ/8Biy4NOFtINOd7J5fYUTxxbMXnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2P9JYASYP19vJkDiies3DrJ/QmxpjYrZWGE/OJCoKsAi9nzQbz5XiDWIXxJ/GXEp+cKjwjMAhP8td6D6NJ1uFywx0+m+LefWANfRMgi9953O3hKIhzv61BtljQycgQXKtyC9kLWidiiij/yYnyy+HRzE93hf0hFmb1zY+1FvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5JDTZSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5JDTZSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA64C4CECF;
	Tue,  3 Dec 2024 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240177;
	bh=dMSpPAOfRPVbvKZ/8Biy4NOFtINOd7J5fYUTxxbMXnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5JDTZSigm7gvxRrE8LTDbcznBontsJwEEh7QDRuFC04P5AghT6hOueRUuDuzBrEP
	 SZlFrisYt4+5Pm5tqbDn60HVNvAMTk7KxWGoHUDLOnBFkn763c6D6RZMcP4+kSo9u7
	 0k/IZ02U23KGrrb/6PeEHJ9r/1KjGOEee9Xwo/QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/826] thermal: core: Initialize thermal zones before registering them
Date: Tue,  3 Dec 2024 15:36:17 +0100
Message-ID: <20241203144745.421677252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 662f920f7e390db5d1a6792a2b0ffa59b6c962fc ]

Since user space can start interacting with a new thermal zone as soon
as device_register() called by thermal_zone_device_register_with_trips()
returns, it is better to initialize the thermal zone before calling
device_register() on it.

Fixes: d0df264fbd3c ("thermal/core: Remove pointless thermal_zone_device_reset() function")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3336146.44csPzL39Z@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 8f03985f971c3..7a138bd5d8841 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1465,6 +1465,7 @@ thermal_zone_device_register_with_trips(const char *type,
 		thermal_zone_destroy_device_groups(tz);
 		goto remove_id;
 	}
+	thermal_zone_device_init(tz);
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
@@ -1503,7 +1504,6 @@ thermal_zone_device_register_with_trips(const char *type,
 
 	mutex_unlock(&thermal_list_lock);
 
-	thermal_zone_device_init(tz);
 	/* Update the new thermal zone and mark it as already updated. */
 	if (atomic_cmpxchg(&tz->need_update, 1, 0))
 		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
-- 
2.43.0



