Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF51BDC3;
	Mon, 14 Oct 2024 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918445; cv=none; b=oQdVAQw7bSPASJzFdcM7SHhiHzOBC8XpLCPY9fj1LNttVnj1qhArOefIhEfzqXYVMpczXaT0vxY/CIjv5khyTWiYtB4tqFEGuJT4nJBwQx6qt19O5buK0HudaCpNyxTSMAHGmkTYtQf8CN11m3gMts8ADQN/tP+dqOdJlEPloB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918445; c=relaxed/simple;
	bh=83xVxxYox5ffxzOYvSW4dDVETGfbV5X5wExXI+6zL00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA7zgDtedwyd9ddFOSOvJAA2FpjVnE+8diJaZ+DXbu0ChxusyrGqYDf4FODbyEQtlNh8/sPEDmQhl9IlblnEAxlmp5lVhpMvdS52nnFWxKaMFlndmbgu3hwaSs84vLbGxcIYxZr+EV+yxd7lsh/jWv6IrwD4yGEHQXxQq6i1oRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCqIGMe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCqIGMe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D85C4CEC7;
	Mon, 14 Oct 2024 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918445;
	bh=83xVxxYox5ffxzOYvSW4dDVETGfbV5X5wExXI+6zL00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCqIGMe+dpyIEsYZM34GvR6ZkkY/B8sEYRwGlkzv+GMOUhOJQZYQ1jDuaHM0MbMlR
	 cR4Q/9RXdlm9tHFjWDOooa5xYZPLmBy9Gq9EAGJcCoOfH/BwUBH3O9v9BhNnYf1wIv
	 dmcwALI1wlnxxs7PPeOViQIhZNfry4mTuNXOoslU=
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
Subject: [PATCH 6.1 294/798] drm/amd/display: Round calculated vtotal
Date: Mon, 14 Oct 2024 16:14:08 +0200
Message-ID: <20241014141229.492520704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,7 +133,7 @@ unsigned int mod_freesync_calc_v_total_f
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


