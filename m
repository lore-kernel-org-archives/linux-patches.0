Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438CE44163B;
	Thu, 30 Jul 2026 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422387; cv=none; b=AC0owxoY5+u2GmwhMsB4i1uYQ0oWxsbTN5KviEBlRt1feIRp0ooShubaBO3X2CiNr6boIj5YuEz2bn9c6svxYe+bGOgEJk+wC6FfddcgUEK+/MBe3WyyNYbR8F5ZM/K9GZ+4f3GI97ttUFQ0+Ho2InQHdtoGk/0hGdVPpJYie7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422387; c=relaxed/simple;
	bh=rhbzjrMUvx+hsmEpaPIXu44LrJL6IxmVhsCvko3CDUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAWRNs/ohKI8DElPajkNWmLnHmvOg8cQqdrwECKX1BS3jH/WxZAAH0jeZjoOrA9mXkBPs8QFTxVNpopEp56/JeN2iq4e+MOAU/V5kad8fDBeQ3XFMXCx7vM6J6/QiABmFOUNBNTt973YsKLt0a63WfeOa9z/YbkxY+drBEquHIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boLmBJR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boLmBJR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C521F000E9;
	Thu, 30 Jul 2026 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422386;
	bh=MyJA/eiSuWXyuKumHJr7LdMMkCsQgDJjBHs2Al9WqDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boLmBJR75+sTSzl1rAHxHMBNYEJ5ePB3Z3Rpja/lfbpZ2Dp5k8Ey1Xud+aPHqRX4I
	 oQZwjGYXlZ/M/n9cq6NLpNmAoMpTBw35Yu82Dtm8PScjgHiSS0avvXUOt4gobfc7l/
	 k3w8HXNbnkORdo19sEUK04HkDD0A0wVABMGXpSXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 421/744] drm/amd/display: detect_link_and_local_sink: DP alt mode timeout path leaks prev_sink reference
Date: Thu, 30 Jul 2026 16:11:34 +0200
Message-ID: <20260730141453.244614261@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit a6e14b976be48eebd8769cb5b883a6af7fc5ade1 upstream.

prev_sink is unconditionally retained via dc_sink_retain at function
  entry, but the DP alt mode timeout path inside SIGNAL_TYPE_DISPLAY_PORT
  returns false without releasing prev_sink. All other return paths in the
  function correctly call dc_sink_release(prev_sink), making this the only
  missing cleanup.

Fixes: 54618888d1ea ("drm/amd/display: break down dc_link.c")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260626124555.36910-1-vulab@iscas.ac.cn
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 45510cf662dcf46b5d8926d454f338809f107b9d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_detection.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1069,8 +1069,11 @@ static bool detect_link_and_local_sink(s
 			    link->link_enc->features.flags.bits.DP_IS_USB_C == 1) {
 
 				/* if alt mode times out, return false */
-				if (!wait_for_entering_dp_alt_mode(link))
+				if (!wait_for_entering_dp_alt_mode(link)) {
+					if (prev_sink)
+						dc_sink_release(prev_sink);
 					return false;
+				}
 			}
 
 			if (!detect_dp(link, &sink_caps, reason)) {


