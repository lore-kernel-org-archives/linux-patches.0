Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901201C9B61;
	Tue,  8 Oct 2024 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391815; cv=none; b=WyFwY1ddhr2IrJH6anvDPioxAIn9RcvHMdfusjOPCC7bI4ucKt1ZEjnQMDQYYGB6VF+ex746vSAD9QYdfPdZ0cPkTyicaNFLQs6bVpCXHJsDt/tdL7HT6Q/Czce4suEwWkMT9ZjK5mwl9FdPavdnsOj+UYszws4fUrFn9x/+WZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391815; c=relaxed/simple;
	bh=u01Mn/bOvuBZQ0XqVB8Tm9ELfhyWxmoqRlTCj/xfI0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riC4gQMgfl8t09w5/M+lOsMy2NxMzAZt24KwbhxJ3uWTA+ojhsw0IKjH8czTNXweX9T/VZLkvx5VKEo7H6sCJRIKlK3Wr1iJUQTP33cOnX5XpveLEo1wZepnPKalNKM3mLHkgZQiWqF3USZNj799XuSKH7mdYgr1B2dA9rUisFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMIuCrf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMIuCrf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3959C4CEC7;
	Tue,  8 Oct 2024 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391815;
	bh=u01Mn/bOvuBZQ0XqVB8Tm9ELfhyWxmoqRlTCj/xfI0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMIuCrf7RlzQmBjBHn4Rcl9ODQQb83S7fxZjWx9HHwaCJvbz4WRNoQzFauFKRYfCt
	 9dmb6ubQqh47T2gjyTo5lJRHTUPh5ahel+siyRUoNlIqqQzVM5auQo3yRVYF0lfAnG
	 1s9+C/A5QNB/RY7ozNcVa2UusVwcHLV/FNBGlCqY=
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
Subject: [PATCH 6.11 230/558] drm/amd/display: Check null pointers before using dc->clk_mgr
Date: Tue,  8 Oct 2024 14:04:20 +0200
Message-ID: <20241008115711.393160966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9e7ba846e032b..81fab62ef38eb 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5383,7 +5383,8 @@ void dc_allow_idle_optimizations_internal(struct dc *dc, bool allow, char const
 	if (allow == dc->idle_optimizations_allowed)
 		return;
 
-	if (dc->hwss.apply_idle_power_optimizations && dc->hwss.apply_idle_power_optimizations(dc, allow))
+	if (dc->hwss.apply_idle_power_optimizations && dc->clk_mgr != NULL &&
+	    dc->hwss.apply_idle_power_optimizations(dc, allow))
 		dc->idle_optimizations_allowed = allow;
 }
 
-- 
2.43.0



