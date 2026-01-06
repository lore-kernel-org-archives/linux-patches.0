Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9C434AB0D;
	Tue,  6 Jan 2026 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719958; cv=none; b=OBEr/VyP12JKMRAN0Dlou/admPhbj31jcXlhPnk4AvuL/rF6sqj5NnaaO2gqfsiaHT4S98YbMKmxpLzdlg7WY38Kei5SuC271/nl6E06oD5t1Tyw628E3/yoLX2RXnA2ANBRhESa8J0GKGqJ7ieRFdfyU+2SGvrc/k239ClIbR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719958; c=relaxed/simple;
	bh=qddo7xiLvlKHRMYDYn8BsG99ILGx4HGEcCX1hmm2Tb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAyr14zSWd2LAkKBhVDOQOgUrG5AX+rOx1LROiUp85TKMFA01m+Ycc7/XZ5tPWfYZucU0am0SC+xT8pATsDTWmi9POgsdAgMpxbm7CPgIH+Tg2FWwfj76VP7m77NkXjbKJtHUnB2Pc+gDiOBkBskU/6a/Y1I/XqjeWigJevtEC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJbPZOyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJbPZOyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1E2C116C6;
	Tue,  6 Jan 2026 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719958;
	bh=qddo7xiLvlKHRMYDYn8BsG99ILGx4HGEcCX1hmm2Tb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJbPZOyimy9d1bqcN0rvFJqHMuTFL3KUMTPNvuITyKwwMD/tMIMjs0X3+cFxZzT1z
	 XWjMMeiqyi3G69G1y2ZG9eb0f535HLD5mGugRvWoSVyG2pZrKvpio7nmTx9ZFx5Q2M
	 7T7plTXUX1IWLNRUCVBoM25sjZ1wcR1xAB7MOcBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/567] drm/xe/oa: Limit num_syncs to prevent oversized allocations
Date: Tue,  6 Jan 2026 17:57:53 +0100
Message-ID: <20260106170454.696751950@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit f8dd66bfb4e184c71bd26418a00546ebe7f5c17a ]

The OA open parameters did not validate num_syncs, allowing
userspace to pass arbitrarily large values, potentially
leading to excessive allocations.

Add check to ensure that num_syncs does not exceed DRM_XE_MAX_SYNCS,
returning -EINVAL when the limit is violated.

v2: use XE_IOCTL_DBG() and drop duplicated check. (Ashutosh)

Fixes: c8507a25cebd ("drm/xe/oa/uapi: Define and parse OA sync properties")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251205234715.2476561-6-shuicheng.lin@intel.com
(cherry picked from commit e057b2d2b8d815df3858a87dffafa2af37e5945b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index d306ed0a0443..5916187cd78f 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1200,6 +1200,9 @@ static int xe_oa_set_no_preempt(struct xe_oa *oa, u64 value,
 static int xe_oa_set_prop_num_syncs(struct xe_oa *oa, u64 value,
 				    struct xe_oa_open_param *param)
 {
+	if (XE_IOCTL_DBG(oa->xe, value > DRM_XE_MAX_SYNCS))
+		return -EINVAL;
+
 	param->num_syncs = value;
 	return 0;
 }
-- 
2.51.0



