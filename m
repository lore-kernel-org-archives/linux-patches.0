Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435FE1C6FF9;
	Wed,  5 Mar 2025 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198109; cv=none; b=R9PqCzA5QJ4ru3z5IRwuXq5FpuH3I8olL4BSRlq7g0f/HqXu6iVGsZ9KMub3fG1GsE9KjhiwnvK8vANj9vXyi4/uJ2MgqvixVJuKPND5Hppbc4o0saFpt9abqf67WqAdroxnpc2h+mjVR6T9BDADRWni9k6LIVtew5vd7DjqauA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198109; c=relaxed/simple;
	bh=MMxi4W6FRhD2pS5kDSQ+nsc6m5hYoDtUynfIIB6E8Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSKuJfy90sPym0BrFWsbzfoNRZxKxA26XrbMn9fvqUBLX0A/mm6AMXFFqaE+v9w325aqkyj41Mb/6dZ8FDX2COBTUF79wkTzv6bqgXxNo96SYnj4JEGY2iJUZdbYzdfdfDc0+5xfgN2TJAtTrHV/xpaXuF+lZQYO8DAWOTTyLgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytDo4DA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytDo4DA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AB2C4CED1;
	Wed,  5 Mar 2025 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198108;
	bh=MMxi4W6FRhD2pS5kDSQ+nsc6m5hYoDtUynfIIB6E8Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytDo4DA35V8xToQat1CYtAYIaNp+GPkkRjjoUZjBpq+EvlQPxZNdF1DzsoUgxcD7P
	 x681WicNCNDcEvB+R88dsmnStbMlXLQCf+BFCVxKg0tQuxCjfOhEv6Vfzr06v4ge6b
	 aUYHrrqlj0gJFFr9gc6i/gpx3kfDpUvgv7yB/e8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Che Cheng <giver@chromium.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/150] thermal: gov_power_allocator: Fix incorrect calculation in divvy_up_power()
Date: Wed,  5 Mar 2025 18:48:16 +0100
Message-ID: <20250305174506.510189087@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Yu-Che Cheng <giver@chromium.org>

[ Upstream commit 4ecaa75771a75f2b78a431bf67dea165d19d72a6 ]

divvy_up_power() should use weighted_req_power instead of req_power to
calculate granted_power. Otherwise, granted_power may be unexpected as
the denominator total_req_power is a weighted sum.

This is a mistake made during the previous refactor.

Replace req_power with weighted_req_power in divvy_up_power()
calculation.

Fixes: 912e97c67cc3 ("thermal: gov_power_allocator: Move memory allocation out of throttle()")
Signed-off-by: Yu-Che Cheng <giver@chromium.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20250219-fix-power-allocator-calc-v1-1-48b860291919@chromium.org
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 1b2345a697c5a..d59549e616399 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -364,7 +364,7 @@ static void divvy_up_power(struct power_actor *power, int num_actors,
 
 	for (i = 0; i < num_actors; i++) {
 		struct power_actor *pa = &power[i];
-		u64 req_range = (u64)pa->req_power * power_range;
+		u64 req_range = (u64)pa->weighted_req_power * power_range;
 
 		pa->granted_power = DIV_ROUND_CLOSEST_ULL(req_range,
 							  total_req_power);
-- 
2.39.5



