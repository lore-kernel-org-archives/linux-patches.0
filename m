Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266FF3839BA;
	Sat, 12 Sep 2026 19:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242710; cv=none; b=AyHYo+r0T+fnNXVVK1iL/TD2EVTk2e7zuqXzKexQha13Gn/CJLPb17s2VsSLBW2Ss0sXpjAiwuBfj6a4e0jygRvOlSV0K1FOH0sRzrGbOJeVm0+N5HUiwUnUa2tKJledw50No1pQS0RfxggqHOrrRuu+arOUH8/aKUUHwWdDbHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242710; c=relaxed/simple;
	bh=/JSRKfn31fthVwzUhKOxsbal0MRU0wsYaSDPxTakZQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS2m9yO2x9+ckUwduV4au4z5nvW+VDHMJa4S3BUpt7QZajHU0c1oPRrhjLj0WlHgOyjub0YcHgt7jCWjdYImwU4AAhN2SVrvC+qM7TFfW/m00Co6C+YtYnuUh6qal/GX6EREC0uFPAWmtVksxjaFqbSkteSrz9jsSF8dpZzc3tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNS6n6I+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNS6n6I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F92E1F000FF;
	Sat, 12 Sep 2026 19:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242708;
	bh=V6lBq629w1sZAQILHOYgXEVBMrInxnp+aI5DndBGccg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNS6n6I+9Z00vLWVhEDODUHOCPH+t9pMekoSRzu07oDaPmWu1E/Trc0pXdQovWa4n
	 B/DNj9Fs1tD1qo8dMfh6UOoZ5nSvofRA6xEoLMJvKq1Jpj8qwfiRfgl4HFlSrNB3nU
	 VGpo33DcfH/0FUSH8X83QYLh6OZsmCOiBqMlwi2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 498/798] thermal: int340x_thermal: Consolidate priv->data_vault checks
Date: Sat, 12 Sep 2026 09:02:06 +0200
Message-ID: <20260912065528.551959258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit e9a7c526c29b0ae60c888b335bd6cf6e2ee80154 ]

It is sufficient to check priv->data_vault once in the error code path
of int3400_thermal_probe(), so do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d83dc9ce57a7 ("thermal: intel: int3400: clean up ODVP on probe failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index a064a4eb31fba..588d8fb12490a 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -548,9 +548,8 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 
 free_sysfs:
 	cleanup_odvp(priv);
-	if (priv->data_vault) {
-		if (!ZERO_OR_NULL_PTR(priv->data_vault))
-			sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
+	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
+		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
 	}
 free_uuid:
-- 
2.53.0



