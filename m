Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671073B777D;
	Wed, 30 Sep 2026 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793399; cv=none; b=iXUhtXe6YKr1pATkFDcoPX3bVriVfs+dHax6m/NEsUhBG3wr9aZHIlQpo2jS2Btm79+QNe4uj92lhmgMScovf/qpit6AvUZOdOU1O0G3A4sayyoD+qXqe0gn+SYqOOqSPcsQMw3w/ORycgjfMGc6ZE4OkBrSe6NUVf/kkG7Stys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793399; c=relaxed/simple;
	bh=gRjVg7lnTh79kDBAf22rzBFclbqS1MzHBIWC8OMeRW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfSp3Ll0963b6KOF2rkRNy7b6f5K427MRdMieGAAcLjMC5OZoGggx7+rZJK4k5+QS0yTZz882q0swtvXr/6/5k6Ty84KcWp7YlKGLNadkFuAifQeYBY186PSe7yq4Q6GzNlI3YLEiIiLL+iMxZC9zKz/6mPZerGEFB4Jlm0MT/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw1saue/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw1saue/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21C71F000FF;
	Wed, 30 Sep 2026 18:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793398;
	bh=zVgxSLmn+LPMfnINOxIKctCe+W3Crf1IqGOkdorS5Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qw1saue/gKBHBIOsaK/msM9AV1k5rPeR8UZq6Emykem9e/iIjOBMxYZuY5E/aTu+9
	 PN77hoZYvaT+kcsCPJnUgHDqVr63oxSW98JfdJCEkQftRXCwv57cNwpo8eZNCTWQ/4
	 RQVHji5ZXHC0U8dVuESiC84NXFwYePyed1paN+Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 241/395] drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()
Date: Wed, 30 Sep 2026 17:28:23 +0200
Message-ID: <20260930152345.884293417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -11639,8 +11639,10 @@ static int dm_update_crtc_state(struct a
 
 skip_modeset:
 	/* Release extra reference */
-	if (new_stream)
+	if (new_stream) {
 		dc_stream_release(new_stream);
+		new_stream = NULL;
+	}
 	new_stream = NULL;
 
 	/*


