Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D76037CD59;
	Thu, 30 Jul 2026 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426039; cv=none; b=sUAJVIyf43j7YTPj5oXc1qrYmoSFsbgMUk/i6EILpX3gS3DcXw/Y7QutKI2EmESWXmoQgPoQ5QAI6ybzkkqMiim3292tiU+9p57puhoLK0Ww9u8XTlc+NQmXaMGyIj2H1ZV7gBMeS5l5DlBzQ7VyemZw//Cy4G7/Akt9ezkfCsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426039; c=relaxed/simple;
	bh=s7lgS1fzVvb0dnO1mPaB4Qz22tEs4Ct7OPvpZqpodeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqdfKU1eyA8gh4k2jRy1GTu6YA3NWBfk0LNkyfwLyM3FPUpSQnck0OHmjKPPllJWlWOX1xBcHq605T1nbcIlDaHFN0XOCRV4SqS/thznFFJFmnt7AqIlmhDJcxTn3YznPivccXwTZy1Z83GkstA4j8HkvsOrGncYy5CqamVPXJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs6pqQDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs6pqQDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC3E1F000E9;
	Thu, 30 Jul 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426038;
	bh=KQGvBkdnsaq9Rz7IA/tnY8XW+vyUe3J7yVxVK+42qdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vs6pqQDCRI+2iOSjRWIkLR9zcmzIDJ4oCJ27U+qS2+sOQYJ6+1s2/KFSzPnHEXBQn
	 tmi2sVVWp94s5qnr9Sx5VaeSci5acy3uRBopKgMbsf/v3GWOIp9fRkJ9Y5vx50ipx5
	 BUsrru3p+iwjveISUJZIaBxa7FXhemNRBNOjfid0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 277/602] drm/amd/display: detect_link_and_local_sink: DP alt mode timeout path leaks prev_sink reference
Date: Thu, 30 Jul 2026 16:11:09 +0200
Message-ID: <20260730141441.793198640@linuxfoundation.org>
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
@@ -961,8 +961,11 @@ static bool detect_link_and_local_sink(s
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


