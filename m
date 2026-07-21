Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D44D90AA;
	Tue, 21 Jul 2026 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649151; cv=none; b=XEDyIZLcTwrAsjZei4wqsgc3G9eG+39adWEyEGdK+gtpS83zwLVAy58AOx0DT1XyrdiOe4+5iqtcYj1CF7tr3A/x6VUXBuc+8Hc2uc/U9/6g8cLgzeaMOZO8bfu5/e53kU9DhMar+yXcpIbhuMUPsSqqI6nv9UYo/j8IzgzRhQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649151; c=relaxed/simple;
	bh=N0uLrepF7ks7D+P1v/bIM94eNd4xjjA51cTI4dpoVmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGlEv7vz4fkMpMYU8O2i28wSM4kIa4fYugWGbCwMxX04j8dt3B2pAp6D0o26oACLWjP9DntMhBCMWHxuKcedgW7aAcvjECW/+hejOXhPuWObwrxqL2icKjTNZadjmdN5F0iH+iuybQIT3k9MjUwvQM1Wyb/TdPBWVwwopO/oSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGxl2LX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGxl2LX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB781F00A3A;
	Tue, 21 Jul 2026 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649150;
	bh=FStwZYTfC0q4YhlU7DstxtfKfBho2hxYaRhRQ+CoNVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGxl2LX4cQ2ha4g4h6H/VUqscRENBcBz5s0qkQkhplQB0VGWVUgqCcM6oQym6epfD
	 hfRyA4g9LsqpZhSYnretywvceF+OVijb193sG/JSbQrzs+0AwFF6Tl//LWEphJ/iJV
	 FGGNJ+96nuCBcZ7FUMrAx8RWmsi9vCpGuzFXx6To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0470/2077] cxl/test: Fix __fortify_panic
Date: Tue, 21 Jul 2026 17:02:23 +0200
Message-ID: <20260721152603.882888322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <djbw@kernel.org>

[ Upstream commit 08326b92c7a414a73b5b308d1daf0e91e0134dfc ]

Fix a runtime assertion in setup_xor_mapping(). Fortify complains that it
is potentially overflowing the xormaps array per __counted_by(nr_maps).
Quiet the false positive by initializing @nr_maps earlier.

 memcpy: detected buffer overflow: 32 byte write of buffer size 0
 WARNING: lib/string_helpers.c:1036 at __fortify_report+0x4d/0xa0, CPU#8: modprobe/2728
 Call Trace:
  __fortify_panic+0xd/0xf
  setup_xor_mapping+0x6c/0xa0 [cxl_translate]

[ dj: Fixed up @nr_entries to @nr_maps in commit log. ]

Fixes: 06377c54a133 ("cxl/test: Add cxl_translate module for address translation testing")
Signed-off-by: Dan Williams <djbw@kernel.org>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260519221204.1517773-3-djbw@kernel.org
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl_translate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl_translate.c b/tools/testing/cxl/test/cxl_translate.c
index 16328b2112b236..25a27e01ac21b4 100644
--- a/tools/testing/cxl/test/cxl_translate.c
+++ b/tools/testing/cxl/test/cxl_translate.c
@@ -236,8 +236,8 @@ static int setup_xor_mapping(void)
 	if (!cximsd)
 		return -ENOMEM;
 
-	memcpy(cximsd->xormaps, xormaps, nr_maps * sizeof(*cximsd->xormaps));
 	cximsd->nr_maps = nr_maps;
+	memcpy(cximsd->xormaps, xormaps, nr_maps * sizeof(*cximsd->xormaps));
 
 	return 0;
 }
-- 
2.53.0



