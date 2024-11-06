Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FBA1DFE1E;
	Wed,  6 Nov 2024 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896531; cv=none; b=X+pvFYIdQQ5pel1Z6H9GFIZ8p1az+DoBPmurB+mAKLr82h78IuDXGaP+19wDsqPvKp1vyT/MFMBXUa0xVtD/kBsVVohEoEbPJ484i9+YAfJLU7jw9Y1Tojv/KJLqjw/wDe++e7VS+prAcp64Dd0P+C53S/1393ViWw0QwQFaej4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896531; c=relaxed/simple;
	bh=v8jlWVLf+NCtEWP7PPeWvuexaXydaTJ3kCpDHHhLPQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIxksOMM2AA9TAVJMOKwEjI7c0cbFFLJSG7HHngeZWXM8qbvgFuADpHyTuqFcYvb4vA0K5w6ZqiNVIvhBHxgOr6qmEJY85lQKeg/X8j/TrhFAOtcYgJXThH2Kl2RppzT/TpLIEUSKkOLSXk0G4HnZ8jATDZWHggG7OVhwHiZKFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBwb5Erk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBwb5Erk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD414C4CED4;
	Wed,  6 Nov 2024 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896531;
	bh=v8jlWVLf+NCtEWP7PPeWvuexaXydaTJ3kCpDHHhLPQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBwb5Erkn7POzVudFp/h4Nw8o06EQf/f3MM5ShnWPVO3OYrHDLWUxHLTm+ASf59F8
	 grwUcq4G94Ik0o0SgI5oR3A3EvCH6coMPa/AI1UqvlWZomxMUL8kopPgyEOTPq2/Ld
	 akDIT46KLd67c5HO8x3+SY0cxbtgdPUQ0dnfwEiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 232/245] drm/i915/psr: Prevent Panel Replay if CRC calculation is enabled
Date: Wed,  6 Nov 2024 13:04:45 +0100
Message-ID: <20241106120324.975968538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit a8efd8ce280996fe29f2564f705e96e18da3fa62 upstream.

Similarly as for PSR2 CRC calculation seems to timeout when Panel Replay is
enabled. Fix this by falling back to PSR if CRC calculation is enabled.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2266
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240819092549.1298233-1-jouni.hogander@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1605,6 +1605,12 @@ _panel_replay_compute_config(struct inte
 	if (!alpm_config_valid(intel_dp, crtc_state, true))
 		return false;
 
+	if (crtc_state->crc_enabled) {
+		drm_dbg_kms(&i915->drm,
+			    "Panel Replay not enabled because it would inhibit pipe CRC calculation\n");
+		return false;
+	}
+
 	return true;
 }
 


