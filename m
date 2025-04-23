Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6A728D858;
	Wed, 23 Apr 2025 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420772; cv=none; b=nznSNASTiLNWmuIyDnC8D/I9h5UXGVWtPahuzxumsw3OP5x7+3OGxYKvsDtFkKoiVpVfh9m2Kj4IT8UEpjjMafpzvLaJmF3Xm3ZLuOXI6zeIlM8ioauDgeUiTAEDMA9LL8rTHxJsNHuwTiohvdLxxZ1YY3nu0WjHuZMTGzMH5CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420772; c=relaxed/simple;
	bh=vYTh7ccb9P5jX+LqRC2OsxJ36p2ik6lSp4l0zh221xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHqO6S/26wflWBcdxlzacl7WlZOCoLtXNw/BP4ECQOh5QzkWtYMLPs96n6hSJajq4VzorsJJMvcDrFxksDgOOVhPsczxU/51JTiyMjhvxqq+Y2K35kHP7wz7m8E6v/BqAh8VdijmDdJxKOCk5kYLNlVKL+RQOW/W0zfVYwWnRUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZgVsuWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZgVsuWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8899C4CEE2;
	Wed, 23 Apr 2025 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420772;
	bh=vYTh7ccb9P5jX+LqRC2OsxJ36p2ik6lSp4l0zh221xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZgVsuWQPaLPT1GWWP4T/yGsQmpcoj5PVIZwmUMzgA+n1JiEZAxYhLi3YimFsDoTO
	 6Limj/0W89edgmuZqSshBXILm1vy1a9D/qkjUIyZNdCyQAkvMHQJ2594Ovij8Okuzb
	 21G3RYxIcUW95n6SliwlKQbtHHIcQrzURLz2eKBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 161/223] drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:53 +0200
Message-ID: <20250423142623.727742543@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
@@ -1228,7 +1228,7 @@ int smu_v13_0_set_fan_speed_rpm(struct s
 	uint32_t tach_period;
 	int ret;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	ret = smu_v13_0_auto_fan_control(smu, 0);


