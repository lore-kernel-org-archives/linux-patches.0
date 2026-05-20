Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F54F364E89;
	Wed, 20 May 2026 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296992; cv=none; b=C2j8684oljcHfEvt9oEUmAqIpOP6XFVJf8nwQXMKEvA/fBEWDOBl+zJBSwHs11zCSkWdIZkbChY7F/nFaDnuvCNzQGFR3zXPTVaFQKeFZxu9PZmKMDPgz11acoQkTfocrTcEoZJXXv4a2WNwWvNrdO+3O8ddvKrCn7QcwjwiurM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296992; c=relaxed/simple;
	bh=62+fWg09E777s9B7Auoszdx+zgeZdXhBuPDmEKLn2uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIxCt0A65xW2SdQslQM6hNGMIn8PrykYd59U3JcLBNQ7K8kNG+ISdyq2t2vGA8hmZyYHfCjRHsAy613ks8JXfAfoglAitLtk/nLFiRM1KXxUBRGxVB0uj1NH821vAgXidPtpFi4HdWS8Vc405tqtpz+t0szG3yTx/VdMu4WgdkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEFWFocb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEFWFocb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BBA1F000E9;
	Wed, 20 May 2026 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296991;
	bh=yZES8JXowZHG4MMcm9smGC2/5Z5BFsPVLoS1xYWgVwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEFWFocbjUjC1WtssQZKJ7SFg9+wXJx8y+EoLAsm4UynK+//4VwsyBgIhXHbcEFph
	 q6ZVSnIUKnlYVvr1tFFzCW0n6TcwBbh5R1LRZnul47uC8X8OypXqSUR3CO7IhWg8cd
	 pIRa4e6Jdz1T7y/dHiFVYdr4NbQMA1Sfu7Ne0MOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Summers <stuart.summers@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1010/1146] drm/xe/debugfs: Correct printing of register whitelist ranges
Date: Wed, 20 May 2026 18:21:00 +0200
Message-ID: <20260520162211.091034232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 1d36c09681aaa..fc4b6f835d4b3 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -218,7 +218,7 @@ void xe_reg_whitelist_print_entry(struct drm_printer *p, unsigned int indent,
 	}
 
 	range_start = reg & REG_GENMASK(25, range_bit);
-	range_end = range_start | REG_GENMASK(range_bit, 0);
+	range_end = range_start | REG_GENMASK(range_bit - 1, 0);
 
 	switch (val & RING_FORCE_TO_NONPRIV_ACCESS_MASK) {
 	case RING_FORCE_TO_NONPRIV_ACCESS_RW:
-- 
2.53.0



