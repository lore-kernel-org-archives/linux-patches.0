Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6264329A9;
	Fri, 15 Nov 2024 06:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653360; cv=none; b=iqeQMGZTB2/xYc90LmT/0rgIc8vvxCuCA1Iyh86WZ2CQfMvWejSzUHI9zxc20cu9CcSlVoYAzV07wwfYlfckuS+3llPz/gIs66gQpFDXYFRuroSl9fUbHMYNJjO9fBzxcGWrKV4yi3lIDq9JcQg07atqlC4jXzwmwyUtCZEp5m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653360; c=relaxed/simple;
	bh=n8HWbi/wLacv5dymCVE8HftwRikYKwTpKuSRxAMxlp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ful9ZUnrGr5MA5ADMYNRQPJdja5kt8Ww/1XpBf6GrERzBN47PpHnaLqrU1mY69HVXcyec6+X5h012+oBN4n1DgwJikLJ+MAVkEq0UykgXHjpU4ABRQaE2lwfYWSsvUYnMVVuKhRLnr3N7nxmz5lJkOtHdtlzSPdY0fcRg0KIW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/UT+FNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/UT+FNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D4AC4CECF;
	Fri, 15 Nov 2024 06:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653360;
	bh=n8HWbi/wLacv5dymCVE8HftwRikYKwTpKuSRxAMxlp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/UT+FNvppPo3qMGvGIaan2d9G6crsREXGuV9pJELRDsELpbOuoDhi2Clbg2kJv8K
	 9XeeZwscMkgaCj1acHhtR3XhoiZa5OmRZ1wYir2dwxZBMKQUfF32b/NPg0O1NEnwwI
	 esrPqrOS/jvCMmeEZieE45h0MwRRBp0SAHPnLiB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Morek <szymon.morek@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 30/63] drm/xe/query: Increase timestamp width
Date: Fri, 15 Nov 2024 07:37:53 +0100
Message-ID: <20241115063727.007442130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 477d665e9b6a1369968383f50c688d56b692a155 ]

Starting with Xe2 the timestamp is a full 64 bit counter, contrary to
the 36 bit that was available before. Although 36 should be sufficient
for any reasonable delta calculation (for Xe2, of about 30min), it's
surprising to userspace to get something truncated. Also if the
timestamp being compared to is coming from the GPU and the application
is not careful enough to apply the width there, a delta calculation
would be wrong.

Extend it to full 64-bits starting with Xe2.

v2: Expand width=64 to media gt, as it's just a wrong tagging in the
spec - empirical tests show it goes beyond 36 bits and match the engines
for the main gt

Bspec: 60411
Cc: Szymon Morek <szymon.morek@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241011035618.1057602-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 9d559cdcb21f42188d4c3ff3b4fe42b240f4af5d)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_query.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_query.c b/drivers/gpu/drm/xe/xe_query.c
index 4e01df6b1b7a1..3a30b12e22521 100644
--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -161,7 +161,11 @@ query_engine_cycles(struct xe_device *xe,
 			  cpu_clock);
 
 	xe_force_wake_put(gt_to_fw(gt), XE_FORCEWAKE_ALL);
-	resp.width = 36;
+
+	if (GRAPHICS_VER(xe) >= 20)
+		resp.width = 64;
+	else
+		resp.width = 36;
 
 	/* Only write to the output fields of user query */
 	if (put_user(resp.cpu_timestamp, &query_ptr->cpu_timestamp))
-- 
2.43.0



