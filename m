Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FD243E490;
	Tue, 16 Jun 2026 16:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626316; cv=none; b=ocO1d4s+CQ029TL9jCOXiS+QXpTQ64w2K/pzg34xq1kd7spbpdlhjnxlJNW6gMDUaubZfXBoHrbc8Jibl0jx9A9/EcDVay4kyBF/JGO21snYN2q/yCM5BAzzcoq0H1G96813r1aadg11vTl1YL7DH+tZQlPzMKf1Aiadn46BTcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626316; c=relaxed/simple;
	bh=SsqvLyeAYBvtgDIItkHqF4YjVu9t6J0eyVi70F77CXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXrOpeENIJY4/nNNofM9IPyCecnnSKaLD9oWa+k0E6EMMfqJiAuBYNu+YH7mGZod0qpnOq7tkCoN5z/eOYabvlDXEY+oHWugP3i0SwbwY8ABs4qna0rSw2wjnRBKZErUKuoITDYf5rZHgxwt2bjt/O3U8zTomm4fe6SXj3+HnpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ABMUCmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ABMUCmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ACC1F000E9;
	Tue, 16 Jun 2026 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626315;
	bh=k11RfGcs79kRJvKUKd6UoznGzVWLAkaTbvLKjEG/aYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ABMUCmtlXwORBVqL8+C81oHlYi9mtTfZMIs+DpzwmD5EkDCTfkaRRxcdMxcwE1z2
	 b2Px98y+NI7Ga+g5uIuoYgGqM57qobllOpMzHYB13wXdwaElWqAtbb7ngiycWIbyaD
	 mQV8mBl06M1fYe2Pr7GqlXJMgG9nBxBxh8a5ImUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 301/325] drm/amd/display: Fix NULL deref and buffer over-read in SDP debugfs
Date: Tue, 16 Jun 2026 20:31:37 +0530
Message-ID: <20260616145113.934494034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit adf67034b1f61f7119295208085bfd43f85f56af upstream.

[Why & How]
dp_sdp_message_debugfs_write() dereferences connector->base.state->crtc
without checking for NULL. A connector can be connected but not bound to
any CRTC (e.g. after hot-plug before the next atomic commit), causing a
kernel crash when writing to the sdp_message debugfs node.

The function also ignores the user-provided size argument and always
passes 36 bytes to copy_from_user(), reading past the user buffer when
size < 36.

Fix both issues by:
- Returning -ENODEV when connector->base.state or state->crtc is NULL
- Clamping write_size to min(size, sizeof(data))

Fixes: c7ba3653e977 ("drm/amd/display: Generic SDP message access in amdgpu")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6ab4c36a522842ff70474a1c0af2e40e50fc8300)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1339,8 +1339,13 @@ static ssize_t dp_sdp_message_debugfs_wr
 	if (size == 0)
 		return 0;
 
+	if (!connector->base.state || !connector->base.state->crtc)
+		return -ENODEV;
+
 	acrtc_state = to_dm_crtc_state(connector->base.state->crtc->state);
 
+	write_size = min_t(size_t, size, sizeof(data));
+
 	r = copy_from_user(data, buf, write_size);
 
 	write_size -= r;


