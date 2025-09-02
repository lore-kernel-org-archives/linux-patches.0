Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FC730DD24;
	Tue,  2 Sep 2025 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819751; cv=none; b=X3fjHXQsNtHF3wHT3eDm4LzB92oDapjHop7k2vRKkci2lbjQX1lbltlw0NG1LFhka5nHF8joBzO/dXkNURJzYDRSJwNhfXV/7tgwHNE/h+Nuj+RnTGQHoqp6eEwtNFlz++1KQQ3c2MQZHGmniURqnXM/5QPxBrNkN6JJTvB663Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819751; c=relaxed/simple;
	bh=qN/rrNOqSixEvnDIv/RopXGcdi0u2IB02ZlkuEViG0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoaUfgmHFXZoMUVoUJUU13LsCwEtAJPlGJjHe0Zxg6fc0mkcWvZ1EF3pmFaFpCkgAb5LLIz7gqihWodo0LHUILMWjVhW6ez+smHCztlpnumr1DpFT+tqIvHmeoKBxnC6rDZ59x6fT5jt/a8f1fA9ejVpgxL6P4Qg6S44ul442Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqLSdVLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqLSdVLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3053C4CEED;
	Tue,  2 Sep 2025 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819751;
	bh=qN/rrNOqSixEvnDIv/RopXGcdi0u2IB02ZlkuEViG0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqLSdVLILWg6M7QXQhSZkC8gvtuNTtfXIhBa/1CWyrU8NEoFlig0V/StvYvCXB2yX
	 EZe2YladDr/sQwMMOVuq5XseZctfJDjxCJcIn9WhKSYPB3qUZAjyEe+jvjU/NHN6Qw
	 a8uIdpHJob/Xa6sAPwtdL/9Aif0VOLtcywsxyxro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.16 127/142] drm/msm/dpu: Initialize crtc_state to NULL in dpu_plane_virtual_atomic_check()
Date: Tue,  2 Sep 2025 15:20:29 +0200
Message-ID: <20250902131953.151355420@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit daab47925c06a04792ca720d8438abd37775e357 upstream.

After a recent change in clang to expose uninitialized warnings from
const variables and pointers [1], there is a warning around crtc_state
in dpu_plane_virtual_atomic_check():

  drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c:1145:6: error: variable 'crtc_state' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   1145 |         if (plane_state->crtc)
        |             ^~~~~~~~~~~~~~~~~
  drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c:1149:58: note: uninitialized use occurs here
   1149 |         ret = dpu_plane_atomic_check_nosspp(plane, plane_state, crtc_state);
        |                                                                 ^~~~~~~~~~
  drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c:1145:2: note: remove the 'if' if its condition is always true
   1145 |         if (plane_state->crtc)
        |         ^~~~~~~~~~~~~~~~~~~~~~
   1146 |                 crtc_state = drm_atomic_get_new_crtc_state(state,
  drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c:1139:35: note: initialize the variable 'crtc_state' to silence this warning
   1139 |         struct drm_crtc_state *crtc_state;
        |                                          ^
        |                                           = NULL

Initialize crtc_state to NULL like other places in the driver do, so
that it is consistently initialized.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2106
Fixes: 774bcfb73176 ("drm/msm/dpu: add support for virtual planes")
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -1136,7 +1136,7 @@ static int dpu_plane_virtual_atomic_chec
 	struct drm_plane_state *old_plane_state =
 		drm_atomic_get_old_plane_state(state, plane);
 	struct dpu_plane_state *pstate = to_dpu_plane_state(plane_state);
-	struct drm_crtc_state *crtc_state;
+	struct drm_crtc_state *crtc_state = NULL;
 	int ret;
 
 	if (IS_ERR(plane_state))


