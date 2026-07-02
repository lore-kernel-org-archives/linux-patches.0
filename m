Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2686331A66;
	Thu,  2 Jul 2026 16:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009343; cv=none; b=lWxjiX79lkaXiAxLDpdvUcxnSco02mJY8QRxrGCeNBxmcit3Rl6o2p27GtvH+PRZEGC/vVEpDWBzQAVSVgz8PVxq3BnabaoWCiikfaXKyaDU02Y+Ii7EctYoBa3xJKcxeSAqEoBHrW8103N1/SsHyOUXvm/BZi8bVxiqXadJ1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009343; c=relaxed/simple;
	bh=5pM5ZBuc20cjvL3aNT+U2Gp5JmGp3xJT+dJJeTZluTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZBdnACReoIup+Xqz/nEVwU9Mtse05pKpHwMuw95vrZTEEKzsaAVjRPM5UVpM1w2+zyF4KfBlsEDsePaGuOmoWQlVuwO+5vrj7XLL4VMjAWzVhaOdxAvvdRYPp0lV4VBEcclLVDvKtJwENK4OGCC/qVIPon//CcMzSszMyDwqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t61tWErh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t61tWErh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EC51F000E9;
	Thu,  2 Jul 2026 16:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009342;
	bh=YVyL2IySaUP9nPRXOObLnt7+vD+c0aIscn3TQ5gZ/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t61tWErh2peTZibmeTQjugHNmvkQH6mTIu+GSNr5gCieFUfHMFaVABH+JI/YsJBUM
	 7/SMNdqgxGTfpN7tLhW1WBr9wcUyLfT1PVe4mDWXJ/MxU9EL8+VRBhA4HQ8kKuztLH
	 x+Yj1DDpTVDWi43v0Ry+Ncd/q4/+3mHsxjx+g/iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/96] drm/amd/display: Use krealloc_array() in dal_vector_reserve()
Date: Thu,  2 Jul 2026 18:19:08 +0200
Message-ID: <20260702155109.328267089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit da48bc4461b8a5ebfb9264c9b191a701d8e99009 ]

[Why & How]
dal_vector_reserve() computes the allocation size as
"capacity * vector->struct_size" using uint32_t arithmetic, which can
silently wrap to a small value on overflow. This would cause krealloc to
return a smaller buffer than expected, leading to heap overflows on
subsequent vector appends.

Replace krealloc() with krealloc_array() which performs an internal
overflow check and returns NULL on wrap, preventing the issue.

Fixes: 2004f45ef83f ("drm/amd/display: Use kernel alloc/free")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 37668568641ccc4cc1dbca4923d0a16609dd5707)
Cc: stable@vger.kernel.org
[ changed `krealloc_array(p, capacity, struct_size)` to `krealloc(p, array_size(capacity, struct_size))` since krealloc_array() is absent in 5.10 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/basics/vector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/basics/vector.c b/drivers/gpu/drm/amd/display/dc/basics/vector.c
index 8f93d25f91ee2b..68c34a4e253ac1 100644
--- a/drivers/gpu/drm/amd/display/dc/basics/vector.c
+++ b/drivers/gpu/drm/amd/display/dc/basics/vector.c
@@ -292,7 +292,7 @@ bool dal_vector_reserve(struct vector *vector, uint32_t capacity)
 		return true;
 
 	new_container = krealloc(vector->container,
-				 capacity * vector->struct_size, GFP_KERNEL);
+				 array_size(capacity, vector->struct_size), GFP_KERNEL);
 
 	if (new_container) {
 		vector->container = new_container;
-- 
2.53.0



