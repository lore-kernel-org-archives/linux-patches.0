Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6943F391836;
	Thu, 30 Jul 2026 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424405; cv=none; b=EU4/stut0aLumY0Q7t6Mze7ToGgdfo8N/BGkfuToPWsqHQ2kTQyY9PxqFpBFJqVVq6G/jmS65xOTxsEbVFVSW0McPYcH+G8YmBInUdK1RquAv64bpTlLbPqihs4NM2/m5uZd+4V9i/sWLKw62YyNQmtBOFH0SeIUgqcJQHiDN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424405; c=relaxed/simple;
	bh=iLoJ9A70DCWc/OIBNmOk56nkQLHVWIND2Uh9HVCoNso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUi1sm5p7A8uzvTCQLqd7PQKVSC4NIN1aEHiWDfg1zYyq/rv2x83qe4DQsx1qhQpzgK2T2/WpNv5Qs2Lc81bZHTAwe51BWFqHNStrxgNVZ5I90LvMcFkcbD/Ibrjz0/JmEuaG87qXPUDKq/LGYOM0Dn17tCI+kt0j7kvwepQ1Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eda+Mzl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eda+Mzl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44A61F000E9;
	Thu, 30 Jul 2026 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424404;
	bh=56I32+CKDA/xHJbuaelRlX1/yTT9sqPOb9toF+KNX+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eda+Mzl/qrscViFu7Ot2/3GmU+aewYlV7gAKOLg8WVYXZpe5MwynBnG+bYN9QOB+b
	 Oa6xxTxjhuoSd4s+hwjrlJmnTKzYafG4G9s5OKtrtBdpsfOHFPvN7bi5hXKrsxIi7P
	 nW4JTQyyy8E0YCOlO5rBzjO0gqbYNDKDy/9ZTBC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andriy Korud <a.korud@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 382/675] drm/amd/display: dce100: skip non-DP stream encoders for DP MST
Date: Thu, 30 Jul 2026 16:11:52 +0200
Message-ID: <20260730141453.254439659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -957,6 +957,11 @@ struct stream_encoder *dce100_find_first
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
@@ -980,7 +985,7 @@ struct stream_encoder *dce100_find_first
 	 * required for non DP connectors.
 	 */
 
-	if (j >= 0 && link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT)
+	if (j >= 0 && dc_is_dp_signal(stream->signal))
 		return pool->stream_enc[j];
 
 	return NULL;


