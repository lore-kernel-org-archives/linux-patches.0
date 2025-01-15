Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24990248BD0;
	Wed, 15 Jan 2025 10:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938697; cv=none; b=dgcoMvYko2Dyz4Yg12iNbcGUxSL4R+7pfi0Mt/Np254Z+RXZFkI58yhsQ7mF1itmE8ikRREmdoUjlYBXa6bR8jPQRUr0lq1+Re76eY3aG5/OrXJGkB2RitUc5qSzu4/TXPC4xLJ+IQ6V84AdDRTM2gPBQONIslx1719JVPsjoMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938697; c=relaxed/simple;
	bh=WdHDAmoxph8ZTvuSaALU0mZtqPldoJHaUCmy2B3kbB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MirWqdYgu4penAJS0pz4oXs0HVSg6E59LV91ZF0ecHrae0jN/6GTDS8uSpaKNLg8ep9jJe6heZlwYTtmam0YyCtsjDl8g0OLLsUCJ6FFuDN9lmwfoV7No7GpMxsrY4VP483tiMxwXytEMb81S458ObLeerJRg9eMOTP+MsX+PBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wnh//ker; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wnh//ker"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D077C4CEDF;
	Wed, 15 Jan 2025 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938697;
	bh=WdHDAmoxph8ZTvuSaALU0mZtqPldoJHaUCmy2B3kbB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wnh//kerV5dq3KcwW7nrUVNZ/ScAOPbxpuCYMKTOzHM5//Uz0CU7q7g0r9yJRYKH3
	 rwsgwMThA0ZAbh8hL9g3DKJnP/vFrySEpGLBgI+/r3VU5oVCXrIRr5DufLUjoNq7sG
	 th/rzjX6XnudGGAzhrIHpPLNoEH//Fr+qFJnrZ0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 068/129] drm/amd/display: Add check for granularity in dml ceil/floor helpers
Date: Wed, 15 Jan 2025 11:37:23 +0100
Message-ID: <20250115103557.090880446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Roman Li <Roman.Li@amd.com>

commit 0881fbc4fd62e00a2b8e102725f76d10351b2ea8 upstream.

[Why]
Wrapper functions for dcn_bw_ceil2() and dcn_bw_floor2()
should check for granularity is non zero to avoid assert and
divide-by-zero error in dcn_bw_ functions.

[How]
Add check for granularity 0.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f6e09701c3eb2ccb8cb0518e0b67f1c69742a4ec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h
@@ -66,11 +66,15 @@ static inline double dml_max5(double a,
 
 static inline double dml_ceil(double a, double granularity)
 {
+	if (granularity == 0)
+		return 0;
 	return (double) dcn_bw_ceil2(a, granularity);
 }
 
 static inline double dml_floor(double a, double granularity)
 {
+	if (granularity == 0)
+		return 0;
 	return (double) dcn_bw_floor2(a, granularity);
 }
 
@@ -114,11 +118,15 @@ static inline double dml_ceil_2(double f
 
 static inline double dml_ceil_ex(double x, double granularity)
 {
+	if (granularity == 0)
+		return 0;
 	return (double) dcn_bw_ceil2(x, granularity);
 }
 
 static inline double dml_floor_ex(double x, double granularity)
 {
+	if (granularity == 0)
+		return 0;
 	return (double) dcn_bw_floor2(x, granularity);
 }
 


