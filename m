Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF2C38945D;
	Tue, 10 Mar 2026 11:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142188; cv=none; b=eNKYn2a0u/O6Jo3GqL9ccq8h7WgtxrSEL7NZ3NbJOTok9CbkOMc4dc0cdiCg+eo4AUws8M/8Yf+hUbe8jjxAFXQdnPB54zr5Gl1dUwFq5EVKpngBX3q4+hvazofG3h7HQZBrGgCx5avFWnA22jPrbcWTpUcKUugpS7fFS9ju5TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142188; c=relaxed/simple;
	bh=8GckiOyDdlmhJNJgYX2RsOU70YtQ+wonOfOC3VfCH0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkf6V8dYM5+EX/KlvSERC8KIRAPmdzMjrh4v3vsTdVs6iTIPS1uU/xMhqHlXjVgV4YhUUjspGE48NUCs6jMG72NqVM1o/Lh69HL0wyRxaHeVf2EBpRoCaTY9CR4Z1KNEs7+MDxXt6ESMB8pNBjAr+UfPv82Pako0j+XVpLFu7sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/e83xIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/e83xIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0218AC19423;
	Tue, 10 Mar 2026 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142188;
	bh=8GckiOyDdlmhJNJgYX2RsOU70YtQ+wonOfOC3VfCH0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/e83xIiNJLAGM5pDoXUt/YXs8TBnYFGnNJxVLyieiTVAlj5EV3p3D4sYamRZOmWm
	 VbRW02dW/kXaY3Er2ny/PLol0zEJxDO8LqX+6uDyTOFiddBus7wWGqtlw1oULVe7Ly
	 27JeocUo5DAbd/alPVQYP/MxSkn4tQWv+qnRy3wqK7HXu7PUb8M+l8AMUE8qYSUFH8
	 hfxZiCRmZXhlI2PaULI/8pjN8UElsDk2WmOshEhprMwUS1QkFyknuQBiuzNHLF3VRx
	 zg6Tm/yZwqB4drX2Mybhycx/kv8hdGKKuQ7utWhtvjEtoCMKjMdvLdlxasBqe0kSrj
	 Sly79k7KNs5wg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miroslav Lichvar <mlichvar@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/314] timekeeping: Fix timex status validation for auxiliary clocks
Date: Tue, 10 Mar 2026 07:18:56 -0400
Message-ID: <f3ffeaa335b33efeab8d671f1f07292041b2c0f3.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit e48a869957a70cc39b4090cd27c36a86f8db9b92 ]

The timekeeping_validate_timex() function validates the timex status
of an auxiliary system clock even when the status is not to be changed,
which causes unexpected errors for applications that make read-only
clock_adjtime() calls, or set some other timex fields, but without
clearing the status field.

Do the AUX-specific status validation only when the modes field contains
ADJ_STATUS, i.e. the application is actually trying to change the
status. This makes the AUX-specific clock_adjtime() behavior consistent
with CLOCK_REALTIME.

Fixes: 4eca49d0b621 ("timekeeping: Prepare do_adtimex() for auxiliary clocks")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260225085231.276751-1-mlichvar@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 340fef20bdcd0..c7dcccc5f3d6b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2639,7 +2639,8 @@ static int timekeeping_validate_timex(const struct __kernel_timex *txc, bool aux
 
 	if (aux_clock) {
 		/* Auxiliary clocks are similar to TAI and do not have leap seconds */
-		if (txc->status & (STA_INS | STA_DEL))
+		if (txc->modes & ADJ_STATUS &&
+		    txc->status & (STA_INS | STA_DEL))
 			return -EINVAL;
 
 		/* No TAI offset setting */
@@ -2647,7 +2648,8 @@ static int timekeeping_validate_timex(const struct __kernel_timex *txc, bool aux
 			return -EINVAL;
 
 		/* No PPS support either */
-		if (txc->status & (STA_PPSFREQ | STA_PPSTIME))
+		if (txc->modes & ADJ_STATUS &&
+		    txc->status & (STA_PPSFREQ | STA_PPSTIME))
 			return -EINVAL;
 	}
 
-- 
2.51.0

