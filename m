Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0DB27CCC7;
	Wed, 23 Apr 2025 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421371; cv=none; b=RYYkGDNDZbRBjm5PcOZsvKvv4Jw/4Lr/D4DIDN1oBbr8+1ZM642y6DUQwgKRqGl2tnz8SOEv6SsO8GmPs4foEhObn1cnUo0z4Z+MNcPqSfn73uOY9cmyiUqm994b+ExrGqeo4H1ZAMBobx6dQXjitB8p7ZQGWtSJPsUsKMkgnRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421371; c=relaxed/simple;
	bh=jQGy5XqqgR5kJ98nfRBBt1ikX/FqaC4eVup2J2MHTy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz3vG/oK33MaJfXIPIotGxJk7QeG+Hrh1FMsY9KSzONfvhh8v7EOHLpUin3ekN2Yc24tUZBUwK7SgfRGNAZLwIKZvla03QYHqTLokxeWEtTfBT5zBxPh3zZ+LM33aKRLMKQKvGNz927TMfx1Ds4uFb0dRb5yedXgR7jv0kvKTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWH89Ivx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWH89Ivx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D54C4CEE2;
	Wed, 23 Apr 2025 15:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421370;
	bh=jQGy5XqqgR5kJ98nfRBBt1ikX/FqaC4eVup2J2MHTy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWH89Ivxfmd1CA5qgyQmgY/VXdWGE6XkKtpTwHIxhft9TGScU2FSIL71LzBFH2+j5
	 +7sPgdXB11AGlwSl5g2gOyK9kVC8BHBYrQX0yElBVFsx/IftzXiuD10fjlC4D4VW0R
	 nUqn2yK5RvVOk5Pd7cRW/w03MLZcnkNB1F8H4QQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 179/241] drm/amd/display: Actually do immediate vblank disable
Date: Wed, 23 Apr 2025 16:44:03 +0200
Message-ID: <20250423142627.836661811@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit 704bc361e3a4ead1c0eb40acc255b636b788dc89 upstream.

[Why]

The `vblank_config.offdelay` field follows the same semantics as the
`drm_vblank_offdelay` parameter. Setting it to 0 will never disable
vblank.

[How]

Set `offdelay` to a positive number.

Fixes: e45b6716de4b ("drm/amd/display: use a more lax vblank enable policy for DCN35+")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8592,6 +8592,8 @@ static void manage_dm_interrupts(struct
 
 			config.offdelay_ms = offdelay ?: 30;
 		} else {
+			/* offdelay_ms = 0 will never disable vblank */
+			config.offdelay_ms = 1;
 			config.disable_immediate = true;
 		}
 


