Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7951C1E6DCF;
	Thu, 30 Jan 2025 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246928; cv=none; b=VBgeu9ulbL3YY3AIskayR7sybFHo3hyJSE7Iw+i9lbocQ0phk3vALdEepADN4IYcOuNVX4pIEQ0YfQPftfwutIEza4qJXqiJH5W7t2HgPhJ3UMDRivEJbi5ADrqIM9Jvk1fqtfGw0LgvpWQVpoaSDvh/K7ORxhTR+wnu9MdbfDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246928; c=relaxed/simple;
	bh=CPsP28ZWB8vUQwNXrgISl0t/BHIt3SSfpwCOT5Bfh/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKA6r3MDZRgV8h/2g72Um6fD/qhZT7HYjL8nH5zDRSPf4IfTK3DoT1c5ORK1wCzsP2XJiYmwUs0AiExJSwsTHKoybV8HeLQvS1nmrbbiI/mh4zFCfL8an8nnscZfMMdPYvhwWk+x/gsxVc/dkpSBHcQQeKE8qw8GAiKL0aYwkDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BF8nBTld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BF8nBTld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C66C4CED2;
	Thu, 30 Jan 2025 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246928;
	bh=CPsP28ZWB8vUQwNXrgISl0t/BHIt3SSfpwCOT5Bfh/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BF8nBTldG+QatX3Sz+hZ4olo9OfCSQrlIaJagKBQr1AvlMoHfc3w/oArW/XLmbUPr
	 90xWn2orJ+Zi9zqXK5B3klOcVM5xc/h9Ypm7p83si2lA/sSarm3N+PDD/qgSKJ1wTu
	 5JyuBIl51ClVE8yjN2w28wDkc0w/EKv0BSMEbhag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 023/133] drm/amd/display: Add check for granularity in dml ceil/floor helpers
Date: Thu, 30 Jan 2025 15:00:12 +0100
Message-ID: <20250130140143.445389091@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -119,11 +123,15 @@ static inline double dml_ceil_2(double f
 
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
 


