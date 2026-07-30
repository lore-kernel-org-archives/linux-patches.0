Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A53E43B3F8;
	Thu, 30 Jul 2026 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422495; cv=none; b=U2hEKOotdJ6BqnFU3VQOkjfQxEPvYxVLvC5M5PKYVLQ+tz9BDp+6KGFwdVxwuG0WaNIvi6md6/S1rt4cGp81vhDVLOTrz/GBBuiynZGCE5K1wVirAviw8mfLx5MctDQ2yhMaPSWP+/PQNJkwRbQJ257mvcUuNK3S8gVNJnN+0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422495; c=relaxed/simple;
	bh=lOlu5bhS0kyQeZ2MPDcSVmX2X6Du7JXHI+doFrRCf9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE+Tk2IatunLjOEHPOFFC758jrhKo+f5EgiQQVRLpY4VPQYLUWBdSOlP4iSxFi48wU05Di2xcOzuQ2ulTRiHpEqLWObJ9Gglnqzvig5qo1SW9C5M8OOTh8TrwotO+g4x14j1HQkT2eM+IOtgWyMYVOhZYVKgTnTuvznwhrw6pVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKRQel89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKRQel89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D374A1F000E9;
	Thu, 30 Jul 2026 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422493;
	bh=kYJMOdmSbUfReY4O0Hv0XC990Zu7ZlgJYZ2wYgdmodU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKRQel890dy9mbtvHPt5dESegl7dSx5CnYF8S5e0bqg28H1+BkKCyOKquSk05iTYw
	 xMOv6Jn3WWZSDL6V6GlYIGJV1aA7VUFTzTdP1Nt2oURtr8sbxB1b0VF/S3OfYnMh5c
	 EHGiUIIyVCw1AkOZpyuYSnqd20FTl/kkDu8jkVmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andriy Korud <a.korud@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 456/744] drm/amd/display: dce100: skip non-DP stream encoders for DP MST
Date: Thu, 30 Jul 2026 16:12:09 +0200
Message-ID: <20260730141453.990681844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andriy Korud <a.korud@gmail.com>

commit d340cba0df4cf327c7e89c7c1a4e79d4771d7dd5 upstream.

On DCE8-class ASICs (e.g. Bonaire), the resource pool contains digital
DIG stream encoders plus one analog DAC encoder. When assigning a stream
encoder for a second DisplayPort MST stream, if the preferred digital
encoder is already acquired, dce100_find_first_free_match_stream_enc_for_link()
falls back to the first free pool entry. That entry may be the analog
encoder, whose funcs table lacks DP hooks such as dp_set_stream_attribute.
The subsequent atomic commit then dereferences NULL function pointers in
link_set_dpms_on() and crashes.

Skip encoders without dp_set_stream_attribute when the stream uses a DP
signal (including MST). Use dc_is_dp_signal(stream->signal) for the MST
fallback path instead of checking only the link connector signal.

Tested on:
- GPU: AMD Radeon R7 260X (Bonaire / DCE8)
- Board: Supermicro C9X299-PG300
- Setup: DP MST daisy chain, hotplug second monitor or have it connected on boot
- Kernel: 7.1.3 (issue observed since 6.19)
- Result: kernel oops without patch; dual monitors stable with patch

Signed-off-by: Andriy Korud <a.korud@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5162
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 28ec64943e3ee4d9b8d30cea61e380f1429953a8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce100/dce100_resource.c
@@ -992,6 +992,11 @@ struct stream_encoder *dce100_find_first
 	for (i = 0; i < pool->stream_enc_count; i++) {
 		if (!res_ctx->is_stream_enc_acquired[i] &&
 				pool->stream_enc[i]) {
+			/* DP/MST needs a digital encoder; skip analog/no-DP encoders */
+			if (dc_is_dp_signal(stream->signal) &&
+			    (!pool->stream_enc[i]->funcs ||
+			     !pool->stream_enc[i]->funcs->dp_set_stream_attribute))
+				continue;
 			/* Store first available for MST second display
 			 * in daisy chain use case
 			 */
@@ -1014,7 +1019,7 @@ struct stream_encoder *dce100_find_first
 	 * required for non DP connectors.
 	 */
 
-	if (j >= 0 && link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT)
+	if (j >= 0 && dc_is_dp_signal(stream->signal))
 		return pool->stream_enc[j];
 
 	return NULL;


