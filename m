Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8B03FC5B7;
	Wed, 20 May 2026 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301503; cv=none; b=DPEo6HaqO/BtjAI0mr2+MmpMqx1nRB8gvQOJBU93uX5fH4SkDYUqbuEB4w/1s7w0W6N8zBEP9WfZqeWOI+QF67zLcxo8S1Olm+HxQGD0D2y2LbFQnTjDvhnok56UtnNedxARL9VMwCGOF82yHSKnsj0Xtt4bmjbY2YRq16GUTYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301503; c=relaxed/simple;
	bh=9amsdpHr+P1B2iSdu1ywJIHaOyOLtbhcrDMC+xpvohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JK4BA6k5w8VgYCz/myCKpYD4IWiyyO+Ab4yMO4slGFb/x4AQ3kY8MIVfWkvtn1QIDBJ6Z9AUKHbxlR+N6u2d0/e43PwMoWOjm9uM4hjseqnXMHw8Nnlq5RbhvG1eke8D2YxrxmdcAmOtU6cBfqpEHRv2zgAXSIFqOiDocrvFjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXb29ZtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXb29ZtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781731F000E9;
	Wed, 20 May 2026 18:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301502;
	bh=tiBkif7hUeOD6DLLpmdHjo33NA/ywX9/V85s5zZuATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXb29ZtD1AdjDodRGKBOY39BDN+CWyHGwpu2usah/91fvMdO+1dTUxJXlBESds1wL
	 OZSxpR/CDbMSkTqIwUbifSeNqkLgIYL6OFsChffTrYoXoe51/kE1Dl+uCwU0Tvk7vd
	 7BoZfUO5vW1Zu/0jV4sEpZCousift0Pc5OswUeY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Summers <stuart.summers@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 580/666] drm/xe/debugfs: Correct printing of register whitelist ranges
Date: Wed, 20 May 2026 18:23:11 +0200
Message-ID: <20260520162123.839779200@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 03f2499c51dffce611b065b2894406beb9f2ebe0 ]

The register-save-restore debugfs prints whitelist entries as offset
ranges.  E.g.,

        REG[0x39319c-0x39319f]: allow read access

for a single dword-sized register.  However the GENMASK value used to
set the lower bits to '1' for the upper bound of the whitelist range
incorrectly included one more bit than it should have, causing the
whitelist ranges to sometimes appear twice as large as they really were.
For example,

        REG[0x6210-0x6217]: allow rw access

was also intended to be a single dword-sized register whitelist (with a
range 0x6210-0x6213) but was printed incorrectly as a qword-sized range
because one too many bits was flipped on.  Similar 'off by one' logic
was applied when printing 4-dword register ranges and 64-dword register
ranges as well.

Correct the GENMASK logic to print these ranges in debugfs correctly.
No impact outside of correcting the misleading debugfs output.

Fixes: d855d2246ea6 ("drm/xe: Print whitelist while applying")
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20260408-regsr_wl_range-v1-1-e9a28c8b4264@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 1a2a722ff96749734a5585dfe7f0bea7719caa8b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index 3996934974fa0..3de0a867149da 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -137,7 +137,7 @@ void xe_reg_whitelist_print_entry(struct drm_printer *p, unsigned int indent,
 	}
 
 	range_start = reg & REG_GENMASK(25, range_bit);
-	range_end = range_start | REG_GENMASK(range_bit, 0);
+	range_end = range_start | REG_GENMASK(range_bit - 1, 0);
 
 	switch (val & RING_FORCE_TO_NONPRIV_ACCESS_MASK) {
 	case RING_FORCE_TO_NONPRIV_ACCESS_RW:
-- 
2.53.0



