Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0AA232787;
	Mon, 10 Mar 2025 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626665; cv=none; b=P/HqPUaJXqHVX8/7q0M4YGmHUw7+haclTIl7KoelVlhtOATytz8RSylsMr4923jbf/6aaSjKr1Ds10TIXJNgi2HDYPebF42J3jEsmBH6P51HeAaAV3tUAuI5JtXAoNKMA2rRL8Udx4EQlq3AaEDrQ4FfwShaB4JjIGYee0ZAGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626665; c=relaxed/simple;
	bh=Nz1c/u0QpDr2Vb1fVHFsJeOkvn164i+7dznHDhMOgwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVdieQSDmPPcTFLrfyka5KJyivE88PvsNWW19V8D+zBrGQJqASa9ztwcla5q1JjW78mECaRIkvV1Z0qmGVx1eUHhszXWtTJQCP62PGGaGYn7dssxxqvtBi+IjUcvYoWkxK1whG5Sg0ApAunwASuX/sWG23PZg1WaClFSXkftCqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOMJCMqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOMJCMqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA49DC4CEEB;
	Mon, 10 Mar 2025 17:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626665;
	bh=Nz1c/u0QpDr2Vb1fVHFsJeOkvn164i+7dznHDhMOgwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOMJCMqYZgKQiqirr46wjfyi8yhx+4KLe9AHGKWBgJGGLPFayg147s0a8R+lGxtbT
	 jLJy/Y3J1CHYW7jpRfl1ZpRGI1znSxmBsoB+wp70+6NlGPJyY9Q3snCtdm0bEv1eRU
	 ZL8SxAAeD9h3ZpLr87KFKvpqUvFE+UJIdN9dvEW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.13 069/207] s390/traps: Fix test_monitor_call() inline assembly
Date: Mon, 10 Mar 2025 18:04:22 +0100
Message-ID: <20250310170450.507869263@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 5623bc23a1cb9f9a9470fa73b3a20321dc4c4870 upstream.

The test_monitor_call() inline assembly uses the xgr instruction, which
also modifies the condition code, to clear a register. However the clobber
list of the inline assembly does not specify that the condition code is
modified, which may lead to incorrect code generation.

Use the lhi instruction instead to clear the register without that the
condition code is modified. Furthermore this limits clearing to the lower
32 bits of val, since its type is int.

Fixes: 17248ea03674 ("s390: fix __EMIT_BUG() macro")
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/traps.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -285,10 +285,10 @@ static void __init test_monitor_call(voi
 		return;
 	asm volatile(
 		"	mc	0,0\n"
-		"0:	xgr	%0,%0\n"
+		"0:	lhi	%[val],0\n"
 		"1:\n"
-		EX_TABLE(0b,1b)
-		: "+d" (val));
+		EX_TABLE(0b, 1b)
+		: [val] "+d" (val));
 	if (!val)
 		panic("Monitor call doesn't work!\n");
 }


