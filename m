Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084A85158B7;
	Wed, 30 Sep 2026 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787592; cv=none; b=jW+BtZxSLQesOfqUr7MXSqiZ+aKExU6BRbM3vSoJan3SLBsrjEphuc6kz70FdlgnMRURdk0Ifl+SOZCEOLTdCwD8rLMKv2cT2BM0E/Lt7AXIn67kFR5Q8yBY0s/vCKMZTPr6CLOpAM9U7VvcA3RFWsFqLY3f+hol3PkOKZqoKxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787592; c=relaxed/simple;
	bh=MUEyUFfbipfApuB+cr/SIrPup+3vv8LQTmNxThH2bPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3yQuWMr9W9jgsl8fWW/W4xhMz0yB0xJWNW/fwDTAHNzgOF2CXJIqbajrteA6GfEjBY3qnV59wUgtKiun3HOHaUaahsw7hRtoh15VbmR9NSJvFbO7d0hIr85i45zxERfWYFFgD3zKHPe6LRqwEOucbTcqnzgqtTC0AiLOLAOL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1g3EVth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1g3EVth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BDB1F00898;
	Wed, 30 Sep 2026 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787590;
	bh=svU9xkh+22J71sN2pncsBKmJwVnCCc6qM9Yaxj2KMIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1g3EVthUTcxsTO76GrQwEFK9mWS4Kok9ZpbMl5bC3yYgHMPF5euMeqdhzfuXgKSk
	 pIWFTFRhhJeFiosOC9Bpc5sEjts7bPI/KUGX1vM/Cqkw84XE9/LVGrGjRNBUMeuOEp
	 jFUalWQdEQeg7H1CuBny+dAurVoDWN8KxU2OGfyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 283/457] drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()
Date: Wed, 30 Sep 2026 17:26:28 +0200
Message-ID: <20260930152352.142202351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit c5fd4eaad50d620c7e09ac2082b2fb55ee54170e upstream.

In dm_update_crtc_state(), when a modeset is required the newly created
stream is stored in dm_new_crtc_state->stream and an extra reference is
taken with dc_stream_retain().  The reference returned by
create_validate_stream_for_sink() is released as an extra reference at
the skip_modeset label, leaving the stream owned by the new CRTC state.

If amdgpu_dm_check_crtc_color_mgmt() fails afterwards, the code jumps
to the fail label which releases new_stream again.  Since the extra
reference was already released at skip_modeset, this drops the
reference owned by dm_new_crtc_state->stream and the stream is
released while the atomic state still points to it, leading to a
premature free of the dc stream.

Set new_stream to NULL after releasing the extra reference at the
skip_modeset label so that a later goto fail cannot release the
reference owned by the new CRTC state.

Fixes: 7cd4b70091a5 ("drm/amd/display: Rework CRTC color management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 102a47065a62dc8f6bbbb47cf082a2934282eb08)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12348,8 +12348,10 @@ static int dm_update_crtc_state(struct a
 
 skip_modeset:
 	/* Release extra reference */
-	if (new_stream)
+	if (new_stream) {
 		dc_stream_release(new_stream);
+		new_stream = NULL;
+	}
 	new_stream = NULL;
 
 	/*


