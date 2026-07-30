Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370CE38B122;
	Thu, 30 Jul 2026 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424340; cv=none; b=CfgwCjIjnyUsEbc1d2fmANft1dBf9t0+JnQc20SCvED6402gfgATBIYYqIHnYBYwC9A9I9TwsdBOwprs8J/qJ0FjpDByr0tnALfZAEZhSD4/cwR5DAI/l7ZTO/v3O0Q9bJNYATjty7hHArAC8Q6PYgRK9EiYc7VAs6RHwRbVI00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424340; c=relaxed/simple;
	bh=Hrj/1VUGYkkr/igTpmTJGIQktKhpPwGEBfhNmF6Pggg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQ1g4dmDpJ/JKVTLH3ZiRFIM0m/NRbRUmYTFibGQByqGfdZUGzCiSr/oNa+o+TLUoSImUmH59UV3ZWfzsh7dcBU9zaWC371EEXcOqOuH6z1JCAq4g2lcuQx/eK4IZp9/B6bMxQu7hBjoLezZ5w3WGnytPMvNp8e+oFIVhO1ibrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGqgkBZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGqgkBZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF601F000E9;
	Thu, 30 Jul 2026 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424339;
	bh=L1IHJYKLbUHMWUaLcISOn9vWb1v5UyHFZ2OMR6XzUwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGqgkBZiKA43zf9VX+FKkThXOeSRv7nDFnAJs82BHvsc0hbUJpbCOn2wDskFgdepQ
	 mk4TzbWE3W9nE1uOh7a29HbF+QytwyvBcJ2nDxscLwULfIrsysMzXvTGtfs2AP0hp1
	 SzQ7B4VTSbcvfsJO7HXYKyB3rdTu6Xk3GXGpAbS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 357/675] drm/amd/display: detect_link_and_local_sink: DP alt mode timeout path leaks prev_sink reference
Date: Thu, 30 Jul 2026 16:11:27 +0200
Message-ID: <20260730141452.720763869@linuxfoundation.org>
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
@@ -979,8 +979,11 @@ static bool detect_link_and_local_sink(s
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


