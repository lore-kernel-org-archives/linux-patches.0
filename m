Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DFD248BBD;
	Wed, 15 Jan 2025 10:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938171; cv=none; b=qEqjKkZExUvaIptYyVxLMbyJg8RjlpRTShma1g0rjXtTG9nVrWG1kSd42irRVGEqTXBSirUPjX2KKycP63Iqkx+D0zChxi4htKgWu35yrUMe1L0VzX2FXvFHMuLdz6dChYz6UQIjhYFwF4ZeuwPUTmnOYC6GzKKTHm/oaVY8Lz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938171; c=relaxed/simple;
	bh=ZF73ekGUNIrhWwwSW8PBWhhGdiEeN46ogbDjjYa6hAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xyy00TJdGc0b2BTXyCYv7yy0zybYs3wQC6PjDpmp7mC2WINnNY1xQoy+2UdxjvW1yqW3+RFjPnh652vnv5eZr4hLY6dtat5pVaXJMmyFqKNssrSwu0AGGrjsQVVyjz6r3Oj4wMv42qUp1MgqMajFtB6P/F17ZSksxfZLy3oKD2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzfuKMGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzfuKMGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C23AC4CEDF;
	Wed, 15 Jan 2025 10:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938171;
	bh=ZF73ekGUNIrhWwwSW8PBWhhGdiEeN46ogbDjjYa6hAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzfuKMGx+A8hI7xRxYfaASCQPM9F8vRfObDG6vXyX3ebUpL2Redf057Ufp8fJ8osE
	 YbjoHhnqYXuJAnWHMeY/2zDQr1GqFtSLY4TinDhtF81iNkL0RnD8TNhvoajPcpZOvk
	 6889FxtqDEh7WPmfrrxOo0Dt8iZDaGSCUJrLRVEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 105/189] drm/amd/display: Add check for granularity in dml ceil/floor helpers
Date: Wed, 15 Jan 2025 11:36:41 +0100
Message-ID: <20250115103610.646174495@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


