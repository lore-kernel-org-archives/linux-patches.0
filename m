Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84AF17BEA5;
	Thu, 15 Aug 2024 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729958; cv=none; b=vAcTdVT8s7jQzK8uC37WsSubwJZm3ZwLzZaTp+gXuWA/nwmgd3lFtJ3577EQmpK5vesk1xX0Um1HbJoSQaJS5uMof3PZMnXlTIbf3KdHsfPqdIT5aSltldPmE1SjBQgT0CcwnyZHbM5P4ZmPbimtqsbETw1ASglabAF/rm/9K7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729958; c=relaxed/simple;
	bh=+gKQGZJ+5RluWKO/N9ALyM0oLLj4Tuf5EdwK389XHzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSpta5v3Ms9+acRk/lsFn2oK7n7raKtbDEqHMqGC+SSHH/SAuOd5OF/XHyJIGrUrxNh+xmujq3koZTlcNjJFquEaBe9w1QIOhUTJqZevOInpkXcRsF/UCpHiJulF2ikL50Y4Hx3iwZ2/sy69lGyrc5zcjctGxrGpkejBzJOaqaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pq7FaW71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pq7FaW71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301DFC32786;
	Thu, 15 Aug 2024 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729958;
	bh=+gKQGZJ+5RluWKO/N9ALyM0oLLj4Tuf5EdwK389XHzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pq7FaW71l2Ugx3u+LimIQ+YRIHnYqn5ebgSW+3NWnQvyZuQyEpfrkxX++z+vgBIza
	 Rq0WFgzCSby2y1pQ45BkjZdUHA973eLlrjdgE6ueU2AR81yTCmqtFynFrwH/c4NJHO
	 8sjxiaT1/7SJPUZ+9mqq9v1GgmH1q0vFGLJwXIUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Cavenati <cavenati.marco@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 233/484] perf/x86/intel/pt: Fix topa_entry base length
Date: Thu, 15 Aug 2024 15:21:31 +0200
Message-ID: <20240815131950.405897254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Cavenati <cavenati.marco@gmail.com>

commit 5638bd722a44bbe97c1a7b3fae5b9efddb3e70ff upstream.

topa_entry->base needs to store a pfn.  It obviously needs to be
large enough to store the largest possible x86 pfn which is
MAXPHYADDR-PAGE_SIZE (52-12).  So it is 4 bits too small.

Increase the size of topa_entry->base from 36 bits to 40 bits.

Note, systems where physical addresses can be 256TiB or more are affected.

[ Adrian: Amend commit message as suggested by Dave Hansen ]

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Signed-off-by: Marco Cavenati <cavenati.marco@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624201101.60186-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/pt.h
+++ b/arch/x86/events/intel/pt.h
@@ -33,8 +33,8 @@ struct topa_entry {
 	u64	rsvd2	: 1;
 	u64	size	: 4;
 	u64	rsvd3	: 2;
-	u64	base	: 36;
-	u64	rsvd4	: 16;
+	u64	base	: 40;
+	u64	rsvd4	: 12;
 };
 
 /* TSC to Core Crystal Clock Ratio */


