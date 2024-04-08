Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB484A34;
	Mon,  8 Apr 2024 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582428; cv=none; b=aqcAXhF9rNUb6E4wSsYmv3TGV4LXr54aBWzgHkdAPWqvw9getSABotpFleYkxZNF6aSC1kr5T4nFQAkK2FFZIFJD7lTOCIKult5PL+0gGrFSy4xGq2pBX1B5SbeC1ZI0NyFqs13NpqEG3/KpkbUxklrjbbdwJAxGx0V6P3y9PqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582428; c=relaxed/simple;
	bh=gR8eFvqp3wTxLqkL3LFEEsZTQz2Le+ETIQv/FYZ6umE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVs7V7bYlUdPAJl2T7ra65rDO3oTwk9a1ePwzn0ftiWwa6Rn6d7IENwMDahlC+ebUmrZJBL5jsMHmdBZTZi3Sfcks/fEHhn+NXfJAttKNobvm3TGcG/01Srayt3YDDr9IM7jWsMXk3YAqX2S083g7ryZYcM7RZYzJwfa9i2uhjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9+Ih+hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9+Ih+hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4116EC433B1;
	Mon,  8 Apr 2024 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582427;
	bh=gR8eFvqp3wTxLqkL3LFEEsZTQz2Le+ETIQv/FYZ6umE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9+Ih+hbgPDeNWYugAJ1tZAE33bPD8NOJNWSxS8urhh6Q0yvWX2xHjzrLo6CMLo9T
	 Uzfx46pZEpiVtBte4Nn7vd6WkhMuUGfoCTRF1A4eUY53LqQV/Al1EV1LgMSsFFxmED
	 LQ+4+4n89Io+Cf1luvJdDILsbSQJWZexrJd7IbW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/138] s390/pai: initialize event count once at initialization
Date: Mon,  8 Apr 2024 14:58:38 +0200
Message-ID: <20240408125259.465523082@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit b286997e83dcf7b498329a66a8a22fc8a5bf50f0 ]

Event count value is initialized and set to zero in function
paicrypt_start().  This function is called once per CPU when an
event is started on that CPU. This leads to event count value
being set to zero as many times as there are online CPUs.
This is not necessary. The event count value is bound to the event
and it is sufficient to initialize the event counter once at
event creation time. This is done when the event structure
is dynamicly allocated with __GFP_ZERO flag. This sets
member count to zero.

Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 1 -
 arch/s390/kernel/perf_pai_ext.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index a7e815563f411..7eb138b07e7be 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -250,7 +250,6 @@ static void paicrypt_start(struct perf_event *event, int flags)
 	if (!event->hw.last_tag) {
 		event->hw.last_tag = 1;
 		sum = paicrypt_getall(event);		/* Get current value */
-		local64_set(&event->count, 0);
 		local64_set(&event->hw.prev_count, sum);
 	}
 }
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index d6bc919530143..663cd37f8b293 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -333,7 +333,6 @@ static void paiext_start(struct perf_event *event, int flags)
 	event->hw.last_tag = 1;
 	sum = paiext_getall(event);		/* Get current value */
 	local64_set(&event->hw.prev_count, sum);
-	local64_set(&event->count, 0);
 }
 
 static int paiext_add(struct perf_event *event, int flags)
-- 
2.43.0



