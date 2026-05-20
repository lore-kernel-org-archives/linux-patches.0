Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D846933509B;
	Wed, 20 May 2026 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295139; cv=none; b=YNR16pC0ZgBHQonRsoPVQbX0Rn7EP1x7xfEm1lJSIbzpD9DKppVl4Pe6xcBw18rtS1fkROYETLT4aF5puoNH00CiAtxIWPudWL09MdITxh0dPcJ0gWl07xWn5YymFD6VqFHuHa/+AvM3t2b3Q4LM2USnE3AO8fYFMvvaLIJTDRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295139; c=relaxed/simple;
	bh=jW9QsIIFyc9vMdtQts6bVSGGnS/mTBqDr1SROexj55w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y2QMNd1fuhKdfhgXP6KNMcBxKUG0ExGwlFUwqIqhETS/HI7I8UOTQU0s42KFDmc7ztxAtzUBSeUIOi9Pfv8GOHpX+/OCgsc0OhGD+IWN4N+cQ7Hej9Q200tAJtO/NVlmXfJtPwFA5vJo36cWiuBtN36FfeBS6IaKq38WqdIQnC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4DHJDAO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4DHJDAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131881F000E9;
	Wed, 20 May 2026 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295137;
	bh=Q7/QX1odxPPJxPTSPWz+LLPPBXm5hWnVQGpSiRZkhsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4DHJDAOqmEUxOznsn7j7XAYdRquil1VGcCz0IM4TmEm2Trxa6vowyjfKGekcQ7kj
	 4fHvBxUm2T7TZNW+d6BtuoKvTRCs3+E0wNEq2ZBG3H5wSClVktDoP/7D9E7w0K9oSy
	 RUnxIU5q83FaQ9ZYGVfrKaIWPK0Q1oM4+V/R9/z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0298/1146] drm/amd/ras: Fix NULL deref in ras_core_get_utc_second_timestamp()
Date: Wed, 20 May 2026 18:09:08 +0200
Message-ID: <20260520162154.955269517@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 2b8101cc3b34d4d80d799360d2744829d5964479 ]

ras_core_get_utc_second_timestamp() retrieves the current UTC timestamp
(in seconds since the Unix epoch) through a platform-specific RAS system
callback and is used for timestamping RAS error events.

The function checks ras_core in the conditional statement before calling
the sys_fn callback. However, when the condition fails, the function
prints an error message using ras_core->dev.

If ras_core is NULL, this can lead to a potential NULL pointer
dereference when accessing ras_core->dev.

Add an early NULL check for ras_core at the beginning of the function
and return 0 when the pointer is not valid. This prevents the
dereference and makes the control flow clearer.

Fixes: 13c91b5b4378 ("drm/amd/ras: Add rascore unified interface function")
Cc: YiPeng Chai <YiPeng.Chai@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: YiPeng Chai <YiPeng.Chai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/ras/rascore/ras_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/ras/rascore/ras_core.c b/drivers/gpu/drm/amd/ras/rascore/ras_core.c
index b81741a339b1b..1ad555eff5927 100644
--- a/drivers/gpu/drm/amd/ras/rascore/ras_core.c
+++ b/drivers/gpu/drm/amd/ras/rascore/ras_core.c
@@ -507,8 +507,11 @@ bool ras_core_is_enabled(struct ras_core_context *ras_core)
 
 uint64_t ras_core_get_utc_second_timestamp(struct ras_core_context *ras_core)
 {
-	if (ras_core && ras_core->sys_fn &&
-		ras_core->sys_fn->get_utc_second_timestamp)
+	if (!ras_core)
+		return 0;
+
+	if (ras_core->sys_fn &&
+	    ras_core->sys_fn->get_utc_second_timestamp)
 		return ras_core->sys_fn->get_utc_second_timestamp(ras_core);
 
 	RAS_DEV_ERR(ras_core->dev, "Failed to get system timestamp!\n");
-- 
2.53.0



