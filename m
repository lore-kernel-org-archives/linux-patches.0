Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA65E289374;
	Wed, 23 Apr 2025 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422464; cv=none; b=u9GWqdRpaLtTUxHX4mXsZ5o/BoOGkoIUUZpttt9eT8jRJfKauHgAT1wSe0LSihc2MpTWcghBfI1UMiM3GFEiKCUibfxA+ZH8pSNS1ngURt42/bTHBrw+fWfrX+LdITwAp7KmYpZf2RV902lUb/1NH/jnG+shaaIdT+KZZfQBTKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422464; c=relaxed/simple;
	bh=1JDi/9n3Z+ZU7/beSUpQXaTtfSA7eq+UTjVwxrOBWg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9PA7nS6c101Tsf6oXTr3VPJS94DQREocDoW6hULRYauoGzG3n6So1QveNBDm5ZnyTNdjYA3acMKLhfhLDc3laaJOKOn161ijt6uAhoqgg71hE9Jr9JUXlvO21ybdf8XQ8ca/FeRzmS+VXkEWzuIo+qVdw7BkypUrXxjz0LVm+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geifjLw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geifjLw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49285C4CEE2;
	Wed, 23 Apr 2025 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422464;
	bh=1JDi/9n3Z+ZU7/beSUpQXaTtfSA7eq+UTjVwxrOBWg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geifjLw1MJEBGvUMtzNtu36w6iv3L4Kyl1J9MlGJE/LjCwctzgs50Hs/amvGnPh2P
	 FO0ygNTEkBH4QdowY4oou4r32m6Hygg+IpC8VsLFXOUAUcKKtqwNePBjvWcpeD0+DX
	 glWqldFKn3oKFAEtEnIw40cRnzIdgcz+JdWf72hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 353/393] drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:09 +0200
Message-ID: <20250423142657.920262340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1227,7 +1227,7 @@ int smu_v13_0_set_fan_speed_rpm(struct s
 	uint32_t tach_period;
 	int ret;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	ret = smu_v13_0_auto_fan_control(smu, 0);


