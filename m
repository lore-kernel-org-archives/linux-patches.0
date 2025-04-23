Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F2A28F50A;
	Wed, 23 Apr 2025 15:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422230; cv=none; b=p+IzhZ6RWIYSDVTtyaySUN3VZOxTtRbAKPPHC5Wfh4pGuNIyIbFZn35t4fdoqeInMnOlMR1R5HBaAQIKvNWY4sQAu5BBYZ7dWgcCs/G51lHDEdUV4iR8bMuGSEx5t01DPhVYc18wABTETV1gFTZeG8AK+LhVFVjGBo4TlZAqZHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422230; c=relaxed/simple;
	bh=Kss84yfNbzjeh8Z2CKGhsSRdYXGTCR7WGWYKQS+h33o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgkgEOGSwgZfY1uNp3wPt70SsVz1XKaKTFDsMJzJ5hvp++ss0LMB5DH6MNzK5CyLOX0l97QHzM/xJWR3ErElcKcv6ih28bckDzjzvbiZehUjjq9dJVwqo9Tytm3/J1X2QyWIctqVlkfEqNw3qK9aBuJMHrYiQ9IJUamxIePpsxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrQj9t9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrQj9t9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6D9C4CEE8;
	Wed, 23 Apr 2025 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422230;
	bh=Kss84yfNbzjeh8Z2CKGhsSRdYXGTCR7WGWYKQS+h33o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrQj9t9PJtD5sD++/3CLNNkPG+KhNJCbXq24tnarcVJ20Z+l6PRwPaoPse+9PwIIk
	 en3TYC/9Zuzrc6VlP8SjsvI5Xi/1wkaHRdY1jSpOwfgYS0qjhbtF7MJaP40zhDL/mz
	 4P8XquqFtENe/D1qMy/NXNVYKE8Xr3/IaSJj2v3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 238/291] drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:47 +0200
Message-ID: <20250423142634.141814951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1265,7 +1265,7 @@ int smu_v13_0_set_fan_speed_rpm(struct s
 	uint32_t tach_period;
 	int ret;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	ret = smu_v13_0_auto_fan_control(smu, 0);


