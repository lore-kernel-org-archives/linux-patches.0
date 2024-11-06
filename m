Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B477A1F1300;
	Wed,  6 Nov 2024 13:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898153; cv=none; b=jMrBa8xF2GTbuSCz9MOk3p3YwMTX7i6NVD74tghdjADxXTMda6xnC7eiZGETek6LtXCCKCXNqb1goszH5+BH2Dsx/j5KQOVP5Z1GgZ/aAe9hM7QjTEOqyORplVYK1FDWR77OZNom59jyD2RrkS1Ido+Z7RqAhxwpvkLJdvsRIl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898153; c=relaxed/simple;
	bh=UXzrXOy6i5hXPlcTG0Mi6Ne9YpnWqAjyeXDVfwpyfqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skrw/lb8M3DdYRFGLnSWIDH5qcA0CVQzO6XndTD9/iPQ4M64wIKOHd5ipNf3DRP4tep5ZfgXOjXp3WgnrdsQ6bLPznwiyH95P/Pga4SA9TrEjEyN5auuCFlswF+wJWLQNuZDYlSg0XtlpOgmJPs8+Nd0iQebhftBxJuY+9UauNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X06G5SHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X06G5SHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378BCC4CECD;
	Wed,  6 Nov 2024 13:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898153;
	bh=UXzrXOy6i5hXPlcTG0Mi6Ne9YpnWqAjyeXDVfwpyfqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X06G5SHLXPaqI0o/DSc3v02rv5lSiOqb0YUxZRuyouAEjH4eqOVwEKQXnPaoKuvdJ
	 y+At95YiPY8iagbRoKd7N58++DGBFegVMLAPaZC6BqWB+7+bm1Xe+dPUSsuSl0oUiP
	 mDX5vUZvLxeESC6nRBzkzMGaqUGG4ztIHZoFzk2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.4 141/462] drm/amd/display: Round calculated vtotal
Date: Wed,  6 Nov 2024 13:00:34 +0100
Message-ID: <20241106120334.992802125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Chen <robin.chen@amd.com>

commit c03fca619fc687338a3b6511fdbed94096abdf79 upstream.

[WHY]
The calculated vtotal may has 1 line deviation. To get precisely
vtotal number, round the vtotal result.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -131,7 +131,7 @@ static unsigned int calc_v_total_from_re
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


