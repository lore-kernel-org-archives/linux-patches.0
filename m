Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85281442FA6;
	Thu, 30 Jul 2026 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427341; cv=none; b=U8zx5hNc8FdLSHty0CLft8+RxYEDSspwVR+CK7VfYdPg4rZoZYvX0gzHHUoeLE0Qbd4vuToACzuESEXT4Cq1gJexu+9j734QweZ92jM4EE/hu02Bjx93lQXAodG6yb19+U4VKY6l3ZBCS98ChpFb1Mn0xOTA9fsO+Qe8FdhxxZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427341; c=relaxed/simple;
	bh=jXBqraW9RP/SjXuP3gitfzaaXjEBK7xGsB9r2W1R60k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+GFLiBnNT3SCicaIfSnqEO9isqql/cJ4w4jjrdLADrrcXfYNWQ7gUnZ224DbkdDSvHerf9FtfqkUrzy38quZHUdocn8E6W+cFXv4stDjF4GkOyjQhZsAbg4bP2qJ50SQnn269LW5Us7mOB9SpBtWnhIEwaHsZpPYMAtS68ovpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxSxxa1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxSxxa1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D491D1F000E9;
	Thu, 30 Jul 2026 16:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427340;
	bh=tG91jNezzOBVKf/AW2YFv3+imJ6Z6XNBSXghxf1L6nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxSxxa1usCVupX09o9hvKxsOTsT8qua3O8Mg542Vf7Pb/3ssyKn7gr++lIKGzpK1S
	 wWVzY/Q+8deFr5exYd/XWizi4IeHYsd0z4k8BDAKCV5rNFF1kTwcXCQKfHczAM6esr
	 s3KegPIOkmrEW+6dczI/y4+odGjy9PSDnVhenip8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/484] drm/i915/selftests: Fix GT PM sort comparators
Date: Thu, 30 Jul 2026 16:09:49 +0200
Message-ID: <20260730141425.447082463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emre Cecanpunar <emreleno@gmail.com>

[ Upstream commit 612978b83f45bf7018815209db5395d759db6f26 ]

Compare the sampled clock values instead of their addresses. Comparing
addresses leaves the samples unsorted, preventing the code from discarding
the minimum and maximum samples.

Fixes: 1a5392479207 ("drm/i915/selftests: Measure CS_TIMESTAMP")
Signed-off-by: Emre Cecanpunar <emreleno@gmail.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260714220430.238433-1-emreleno@gmail.com
(cherry picked from commit 682ea2d28d18bb06f9fc663cb5ab7e80dc0e606a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
index 0971241707ce83..d396fbd55b740b 100644
--- a/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
+++ b/drivers/gpu/drm/i915/gt/selftest_gt_pm.c
@@ -16,9 +16,9 @@ static int cmp_u64(const void *A, const void *B)
 {
 	const u64 *a = A, *b = B;
 
-	if (a < b)
+	if (*a < *b)
 		return -1;
-	else if (a > b)
+	else if (*a > *b)
 		return 1;
 	else
 		return 0;
@@ -28,9 +28,9 @@ static int cmp_u32(const void *A, const void *B)
 {
 	const u32 *a = A, *b = B;
 
-	if (a < b)
+	if (*a < *b)
 		return -1;
-	else if (a > b)
+	else if (*a > *b)
 		return 1;
 	else
 		return 0;
-- 
2.53.0



