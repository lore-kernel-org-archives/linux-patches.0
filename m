Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72D733A9FC;
	Tue, 21 Jul 2026 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660643; cv=none; b=UYaxAtMKzLDgiLf7kadQ99k/3dkA1tmPVLwbU1bMkjUYoVEbH2H+fvZrSRQoTJttn2kqo06iQn2klcTshLRA/tP4s0yFUnWqy6X0gd3RT74Ew0fu01LLpWpk+3ULUnLQXS3S38aA9j9Xw8qTuWqWHzGVyND56h9Bk4C+foFelhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660643; c=relaxed/simple;
	bh=pO84SVFX/jGzbUYzdcXDaNjJ/WjvOtI9tCmOgph7KdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEphZFiS4vpFnjreCod+UYGzB7rNt+qtpDI5AZ6omtI5xyebdauQA+cSFxioChDKqB/uluY5L6EsgqQpAHNnI/8mzcYf3LrCUXCF3W1SmBLNYzOf+Sh8yvhZID841554UR/Bw/6AtBWEVn34lOF1+B5UR5CkvIz3T203BtDknsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PswZsd7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PswZsd7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF151F00A3A;
	Tue, 21 Jul 2026 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660642;
	bh=1efg7+NzmtyHobJdH5bN2iwYB1Sc4QgAUuLsAh3lhQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PswZsd7LZq4fdggp0r1oE+cYIsYmhUvRRUCzjRS4WthiyqFTCDQdFo83ly5b9ay+C
	 kerEv62vTEUwkg6q4Pk+zxSyUtaS8H5M9gt5uqVC4KJfuWmtsiGBhUV8aN5MwvuEaP
	 a608jAJJ7W7teIjWVP3RgkOQQxdDNSinR3JUihug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduardo Vasconcelos <eduardo@eduardovasconcelos.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1055/2077] apparmor: Fix inverted comparison in cache_hold_inc()
Date: Tue, 21 Jul 2026 17:12:08 +0200
Message-ID: <20260721152617.704296571@linuxfoundation.org>
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

From: Eduardo Vasconcelos <eduardo@eduardovasconcelos.com>

[ Upstream commit 5112ed5258b8d5e0769ae7d2bf9c9dea14c59703 ]

cache_hold_inc() prevents the per-CPU cache hold counter from
rising above MAX_HOLD_COUNT, but the comparison is inverted
(> MAX_HOLD_COUNT instead of <), so the counter never rises
above 0.

This breaks the cache mechanism because since the hold counter
is always 0, the global pool is always attempted first before
falling back to the local cache. The decrement also never occurs,
thus the hold counter is effectively dead.

Fix by changing > to < in cache_hold_inc().

Fixes: 0b6a6b72b329 ("apparmor: document the buffer hold, add an overflow guard")
Signed-off-by: Eduardo Vasconcelos <eduardo@eduardovasconcelos.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index e01efdf50efa2f..1f2bbc3175d201 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -2143,7 +2143,7 @@ static int param_set_mode(const char *val, const struct kernel_param *kp)
  */
 static void cache_hold_inc(unsigned int *hold)
 {
-	if (*hold > MAX_HOLD_COUNT)
+	if (*hold < MAX_HOLD_COUNT)
 		(*hold)++;
 }
 
-- 
2.53.0



