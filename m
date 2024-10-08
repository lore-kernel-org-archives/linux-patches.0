Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEF01DE88F;
	Tue,  8 Oct 2024 13:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393393; cv=none; b=BGEX/HKNkPpUQ8RCPHFVU68ZCMJ6cNlbDe+uRmPh0ZxbYxTJrf8ByclMuZfOgptMb7i2nb1G+Sz8zE4FW98qHw3jqkF9zX/MZWpmdKPbu/LhDhAQM92SXtSj0tPasEoZY0hyCpbo0xabuUaVcaqOyjznD8S41RzUuCWzG5Qw7jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393393; c=relaxed/simple;
	bh=azGPQ8fT45UA50E1mzYOl1ZJm6mHCJLl8pDo3TCNCj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY5f4+uleuarpsRyyXl10vC43AayIolbLL5cBKwQ0snsdKU6hnyrgv6LtQJYghc/+mxRxY7287fMpG/76TimKccLTuI+TGmIZIDY33cydOM4s3Lp8VaTx0o5joVxHnWDW4UNPd2X8aGaE9489FyjX7n3h9rub7PagxcZlOWAi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVs95LQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVs95LQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB63CC4CEC7;
	Tue,  8 Oct 2024 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393393;
	bh=azGPQ8fT45UA50E1mzYOl1ZJm6mHCJLl8pDo3TCNCj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVs95LQSHt9BMeh7yNBkPM22aSrreplE2MGDw7jyttY1vDtQnglRcYcN+cC/jtJ0Z
	 LqXC8o+hVdWRxwtZsZ6y6GsdAjRI1ZjMyFbn0JA+HFHMGE7ZUjegl8yda/rTeZvOPl
	 1dLSjGhrm7egAKEWHDqPwKHAmf5S3zxf+EhXNRMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/386] drm/amd/display: Check null pointers before using dc->clk_mgr
Date: Tue,  8 Oct 2024 14:06:24 +0200
Message-ID: <20241008115634.902131978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 95d9e0803e51d5a24276b7643b244c7477daf463 ]

[WHY & HOW]
dc->clk_mgr is null checked previously in the same function, indicating
it might be null.

Passing "dc" to "dc->hwss.apply_idle_power_optimizations", which
dereferences null "dc->clk_mgr". (The function pointer resolves to
"dcn35_apply_idle_power_optimizations".)

This fixes 1 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 0b2eb2a6c8e14..a7a6f6c5c7655 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4716,7 +4716,8 @@ void dc_allow_idle_optimizations(struct dc *dc, bool allow)
 	if (allow == dc->idle_optimizations_allowed)
 		return;
 
-	if (dc->hwss.apply_idle_power_optimizations && dc->hwss.apply_idle_power_optimizations(dc, allow))
+	if (dc->hwss.apply_idle_power_optimizations && dc->clk_mgr != NULL &&
+	    dc->hwss.apply_idle_power_optimizations(dc, allow))
 		dc->idle_optimizations_allowed = allow;
 }
 
-- 
2.43.0



