Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6EA1EB5FD;
	Sat, 12 Sep 2026 07:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197799; cv=none; b=h5TLWKLdynDkF4J7tcLTuHAPnLGME11qU5n0r4AFuuV+2tWYN3kqanhu906pkfEJVV0F6JbbDWp/H14RP06Cc9Uk7ykvjiSyaqCF6kuB3D8U3wblZbt2v1ZUn9XlGBMEsBW2plOWEkTOI1n4i2bglzEuCpvOZya++BAQ0Qov9fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197799; c=relaxed/simple;
	bh=Ww6UeixRK51UlE4/S2qMgy28zOAzCQior7sTDKexf4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzQYUHZaNkaoAxeUA8Y/NVkIWAUlqPFo/fHWlF4nloAP5WfFSidCoVOprqnGFBgpg4S2ZPoJ/rWvugRm3ev/nFus+dCILYDlsC4+860v3rIWFYU0l1XvTchwHAZuTOTHvWkTFadBIXfHa3BXljfLEpAvKRVVoVxPqri75gHDvlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQt71PE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQt71PE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C541F000FF;
	Sat, 12 Sep 2026 07:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197798;
	bh=A6rUYvSbwoniwWIT7M0AzhqruTPU2l6OypdhHUCBuL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQt71PE8bPaUgImI7CLx9eZV1QT4gUMr8Ksag7pUoG6/SjdF7eLthGxIbgIhlik3o
	 nsp5DkHvuFyV1C44UupPUNxI/+VNxfcMCW0YSpsCtTi8VgSiq8g7bC+7oQ29wPgpBu
	 oGNsAo41kek37G2p9+8MXSRWK7QtzlIife7Yfvt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0249/1815] timers/migration: Fix memory leak in tmigr_setup_groups() error path
Date: Sat, 12 Sep 2026 08:33:19 +0200
Message-ID: <20260912065654.830739909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit eddfded4196542deda7cb2da3d7ebef83f7ccfa4 ]

When the WARN_ON_ONCE(i >= tmigr_hierarchy_levels) assertion triggers,
the function returns -EINVAL without freeing the 'stack' memory allocated
via kzalloc_objs() at the beginning of the function.

Add kfree(stack) before returning to prevent the memory leak.

Fixes: 6c181b5667ee ("timers/migration: Convert "while" loops to use "for"")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260704085533.87098-1-malayarout91@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_migration.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 806c23cf71fc9..059d43355e650 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1847,8 +1847,10 @@ static int tmigr_setup_groups(struct tmigr_hierarchy *hier, unsigned int cpu,
 	}
 
 	/* Assert single root without parent */
-	if (WARN_ON_ONCE(i >= tmigr_hierarchy_levels))
+	if (WARN_ON_ONCE(i >= tmigr_hierarchy_levels)) {
+		kfree(stack);
 		return -EINVAL;
+	}
 
 	for (; i >= start_lvl; i--) {
 		group = stack[i];
-- 
2.53.0



