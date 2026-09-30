Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF5320A37;
	Wed, 30 Sep 2026 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796987; cv=none; b=PnfbPE20ON4DOFySxeKdqv+wcLSr5eDWr0xrUmpMiMNC6gQX5xc8b7XfD3rrZaMmjSZPM967NeFHOjqgdydXqakWqUijO17m/Uzb4pEgKd0RR3THm/oh45nSxlAPog21HDMaEvbWR9eLQuOz26eGFbeUCSmywEzc7NwfkwFCBEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796987; c=relaxed/simple;
	bh=8W1iAuZq8q2WSNYwqdqSSzj5o63Te4IaDdF0tZqUMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q24gvt/pifBO8XY83MK9mGVb7abownO/aXY+k40oePdI3RWzkUmrwBaRV7zvdvH9wAs6kyTnRTFutnzCZCKy0MlbX8pQUe2Ub0vemZxJ99qaw9zRQO45eb8O03UOMN1lwS7jDpPGh9l9ne7k2aH7QOpPQfRT8yV3ohRWbwgLCKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrVHwSkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrVHwSkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1451F000FF;
	Wed, 30 Sep 2026 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796986;
	bh=XbCbfsoxlLJWFU3x0RyIzd3JUCLJoFCbf6y/hn9ygro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrVHwSkmNFuaQe5fWY98iq4dBfRUR/lkOQdslzfUt/9mEGbJrmINiqTt1ILG83+I/
	 xWCBILZByaEa6ZZ8nMkqAG8u309ds18YBKiTZmrgp/uSmDwHVBNfmXrIoLX4FR8BPX
	 AvzrInhtT7bPGHS6bLYVWbfE6GdyVQ9S5F4JdFQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 1108/1193] drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()
Date: Wed, 30 Sep 2026 17:29:52 +0200
Message-ID: <20260930152458.848592629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9532,8 +9532,10 @@ static int dm_update_crtc_state(struct a
 
 skip_modeset:
 	/* Release extra reference */
-	if (new_stream)
+	if (new_stream) {
 		dc_stream_release(new_stream);
+		new_stream = NULL;
+	}
 	new_stream = NULL;
 
 	/*


