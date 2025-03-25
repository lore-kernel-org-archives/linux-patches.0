Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2816425C6E4;
	Tue, 25 Mar 2025 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906183; cv=none; b=W++wA8LkSCSVt0g9fWO+psmSOGfzok+Z+onxvkSPN+Oa9R1oyqIkNQ+tqMkIje8w19V3rcWtqdfnjhN2toAYw31vEbb/Z0DcQYG/ixSw9qAs+OCZww9puO9otFtyMkxwZm2vSmsHNQR680NJd3uPG0s/Q6Hm5QhsR4bJg1Sc6go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906183; c=relaxed/simple;
	bh=af0Vebt+4hqUQTCeOndgnAFyWs/9KC4BYam/YSnHS9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brs2j7zctQj+9aupTdObFMDLHKe1as3b1PVyMbdotrGZACG83KZrG3YkkDOj5RVquE4gRpL1ImNtfdBJ69fWNlY9rRfebSPBBziuu26tmMKb+HwlOU7gxFpOfGW2UFHdTTkOzWmMAQWSm0MvKEH2rP3ZmbUHMf0at4G03bOENpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeTmtcZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeTmtcZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B7AC4CEE4;
	Tue, 25 Mar 2025 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906183;
	bh=af0Vebt+4hqUQTCeOndgnAFyWs/9KC4BYam/YSnHS9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeTmtcZIINUirp7H8/8At7y49G+9hhbsF1ZHEw2B9ZMhA+1I2EYyqd5dBsCN/p1jq
	 JX/V5lKYPsLSk3iF/Y66SczIpGKic5EPSdG/gAlE9reQ5esplkTq4Jb5q1lp29j+ZB
	 UYaJm20utQQfmRfo90U9bvpG11bVNyIzVLDfz164=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Chen <robin.chen@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Martin Tsai <martin.tsai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 59/77] drm/amd/display: should support dmub hw lock on Replay
Date: Tue, 25 Mar 2025 08:22:54 -0400
Message-ID: <20250325122145.893513385@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tsai <martin.tsai@amd.com>

commit bfeefe6ea5f18cabb8fda55364079573804623f9 upstream.

[Why]
Without acquiring DMCUB hw lock, a race condition is caused with
Panel Replay feature, which will trigger a hang. Indicate that a
lock is necessary to prevent this when replay feature is enabled.

[How]
To allow dmub hw lock on Replay.

Reviewed-by: Robin Chen <robin.chen@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Martin Tsai <martin.tsai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -65,5 +65,9 @@ bool should_use_dmub_lock(struct dc_link
 {
 	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
 		return true;
+
+	if (link->replay_settings.replay_feature_enabled)
+		return true;
+
 	return false;
 }


