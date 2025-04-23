Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA71EEA3E;
	Wed, 23 Apr 2025 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421553; cv=none; b=Y/vGxKQeqsfcBaXvCwgtq/FWRcxJUBlkjEEjX2fKwH3f8OaLBA3//tmu1xLt+lADdfEFMjTNY7a/v3VWUzReSKzXyT5VV7/CFB9LN53POYIjyyYkw236hGAxbmBeMHrnqZDbZHUySd3aUtvCWABjn8VkM8UQcS8hu6l/3gjPjfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421553; c=relaxed/simple;
	bh=eFEnU+Kkkq6tzuYDBCLREcTe7om7U/XaldYBCCG+dxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsG9acInDwzip72fgTT+m6m6JY7Z3dn1XDII9WqIk+2ALhEvlRMevvy7JKZ5LXG3J7XKL4m5zTUksjXLZUWRMAZKiPyE5R/RsPHPSf7GLP5h6bXWoSmsYBTG/DXsvqKWVSOui+v9/VbQK05PYrzBITOen09f+QMMeDK84rn3QIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcCaxTgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcCaxTgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D6DC4CEE2;
	Wed, 23 Apr 2025 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421552;
	bh=eFEnU+Kkkq6tzuYDBCLREcTe7om7U/XaldYBCCG+dxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcCaxTgB3x/AMK+04oWA2AVVzrexWVMt+SmuzXHass4FOkWQasIPhrBJY3vQT+yMv
	 WLDkPg44neY5hpL8pcokeKy5ANzMd6PIOQ324Xm3GEch7Gdgm9TlMBMLS9nocsET3v
	 zC9Le78RczgOjfYl9BxjcUUn/c8K2pvH0fR68+1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 186/241] drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:10 +0200
Message-ID: <20250423142628.114797795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit f23e9116ebb71b63fe9cec0dcac792aa9af30b0c upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c05d1c401572 ("drm/amd/swsmu: add aldebaran smu13 ip support (v3)")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1229,7 +1229,7 @@ int smu_v13_0_set_fan_speed_rpm(struct s
 	uint32_t tach_period;
 	int ret;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	ret = smu_v13_0_auto_fan_control(smu, 0);


