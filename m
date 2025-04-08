Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B0C267B15;
	Tue,  8 Apr 2025 12:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113911; cv=none; b=h2AwSMG8jAgwx1SueuhFift/nLreFbXYsYgpgpBA+wZw+yF2LJHaAzOguQfE1zHqqvRDedZcXqSJYKev1xAyBWHZOO3tj7C06/P9bdSCdQHOzJVXjRfoO5HnGHw1NoX5Crq826vRmbwI8x8O6vwPTVdBgduskrb1ngCFZyjD92E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113911; c=relaxed/simple;
	bh=ZufdNMqAB0bhcbhG53W4ZAidWXnEWo1nsa89515mUoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl7XFikTCtF5TNmdRN5WHPJarA7RALMfTjgLFFTcSozDj+6iY3UAhXhqA7xO/lBDMy7JiQG9d7lA7kuNGxfRUmVMVGgXPg6X6axS0mzfKUhk52ENP1HpsbKXBWHn4s8XubQ9e+zCW2bUc99dq0xwf/tMDqul8QmLCPgHBO1JeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7yxq+Nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7yxq+Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7AAC4CEE5;
	Tue,  8 Apr 2025 12:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113911;
	bh=ZufdNMqAB0bhcbhG53W4ZAidWXnEWo1nsa89515mUoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7yxq+NhMVrnoj2qDvbvP4zybjgGNCGOlFMjjaQlJEOMb+8hhHqfnAm2uGPq0bey+
	 lupuo7gG3aBJJI4qoB+c8h3mIbDNW50KC1F9ikYpRxGHdlraRVrFAjdkNG0+DKhESf
	 QoWkbpWp0SAEZY3y+2jKSSwZi8JAcXK/VrWXxOmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 065/154] drm/radeon: fix uninitialized size issue in radeon_vce_cs_parse()
Date: Tue,  8 Apr 2025 12:50:06 +0200
Message-ID: <20250408104817.379426289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit dd8689b52a24807c2d5ce0a17cb26dc87f75235c upstream.

On the off chance that command stream passed from userspace via
ioctl() call to radeon_vce_cs_parse() is weirdly crafted and
first command to execute is to encode (case 0x03000001), the function
in question will attempt to call radeon_vce_cs_reloc() with size
argument that has not been properly initialized. Specifically, 'size'
will point to 'tmp' variable before the latter had a chance to be
assigned any value.

Play it safe and init 'tmp' with 0, thus ensuring that
radeon_vce_cs_reloc() will catch an early error in cases like these.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 2fc5703abda2 ("drm/radeon: check VCE relocation buffer range v3")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2d52de55f9ee7aaee0e09ac443f77855989c6b68)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_vce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_vce.c
+++ b/drivers/gpu/drm/radeon/radeon_vce.c
@@ -558,7 +558,7 @@ int radeon_vce_cs_parse(struct radeon_cs
 {
 	int session_idx = -1;
 	bool destroyed = false, created = false, allocated = false;
-	uint32_t tmp, handle = 0;
+	uint32_t tmp = 0, handle = 0;
 	uint32_t *size = &tmp;
 	int i, r = 0;
 


