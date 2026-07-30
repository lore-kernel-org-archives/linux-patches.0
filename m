Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED263769FD;
	Thu, 30 Jul 2026 15:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426079; cv=none; b=Xa8MNaMsQSlxYAstyGBtbw6Pt/fL3OKSRFogoz4E27av6iHDpc3eESGi6oyVNvwrn6rwX/as+UzBWv51hNbhhx4Zia8LblNFaWf3YdlTVGN9pmsZ5gKHeMqfw76qZzCmZfKjEm53KsY0KMrUhcPJcqkzw8FASDoAXGXCvs3jCOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426079; c=relaxed/simple;
	bh=NkaSDm0mgRGG0/0Fd03Tm13s1s56+O2I3A0RBKT8rsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESPioJ4ImlQya3cQnJiKYlK4VKEAvPbi+M25KobO5RKjSzAfFM2In0EYa+BiL8GoKv5Q8EUN2NzjU1ADT20RNEv5y9giz1s+Ex1negeIAaDQI3UdihZbwSYnBdV6ZE+EthObX3bk7OPyGpc/UcpZQXxQ9dRSu55QoQuG9bE6fww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yc94ivJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yc94ivJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FCF1F000E9;
	Thu, 30 Jul 2026 15:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426078;
	bh=Ivz+Xo8zeI0g95s09gVm9wQ1fGD/hbeQNivnL26wPC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yc94ivJ7ca6hTQOPKnWo0flT8jNDo6rrNqRuah8EU+n7h9FjY/fJG2fxpCVyq+q9G
	 H8/opL4ZsEGxfg0lu2krXPp2dPSwBEv+H4/6Cw9QDv576sABdJgDyJAm6Ab2jbJmH3
	 DaZyBXZ1xUL2aigeKkGf3r1fMsQ5UfHcY6/RVAGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andriy Korud <a.korud@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 294/602] drm/amd/display: dce100: skip non-DP stream encoders for DP MST
Date: Thu, 30 Jul 2026 16:11:26 +0200
Message-ID: <20260730141442.149100784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -939,6 +939,11 @@ struct stream_encoder *dce100_find_first
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
@@ -962,7 +967,7 @@ struct stream_encoder *dce100_find_first
 	 * required for non DP connectors.
 	 */
 
-	if (j >= 0 && link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT)
+	if (j >= 0 && dc_is_dp_signal(stream->signal))
 		return pool->stream_enc[j];
 
 	return NULL;


