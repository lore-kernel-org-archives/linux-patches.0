Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50944374EA;
	Mon, 10 Mar 2025 18:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630827; cv=none; b=JymkNc+4GGkOLUy2Fq2X32LyPap4aIAFvJZICHhauCc4UTxV5A0D2D3ejsaJ/PSAPrXbzCFCUwhcrTQ1Do5mkr35HXD1ff8cVF0UsjyxIZ15lMfZNKD2DiqG7re0zDpK1PcHbLNsDIpKwTELZSL0Oz1/ajviCU8YyDV7wS6Yocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630827; c=relaxed/simple;
	bh=SCZpNYYkQfFQRwEqFQlK6I4HWLUFjqrx6tlbJwCiGQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9YLkgFH2WedW7M2t3xYre0FPsZOyP2aTe+sl7k651KeKUp8Mt82Q5Juy/TTwwI2ZjrscOzZ8xZYUbaXN+BkgdQf42zrBfVdldWU5pb3mvyq9r1FlY5tfGWQqFyXNiUpfpOlrj+QLoBF2KtXdeXUdz3VahI6UOS+ahB1FbY3ujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mULaoJka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mULaoJka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED46C4AF0B;
	Mon, 10 Mar 2025 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630827;
	bh=SCZpNYYkQfFQRwEqFQlK6I4HWLUFjqrx6tlbJwCiGQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mULaoJkav0Hd0QlUDtJkqSNJkzLoE8a2IYst2aJzx8f+MG4rBVXaWzMmsDfBvghi0
	 FQ2LCjtzwxqvx1KkK4gywOrQOYiegJUqZMSNOtWgC79Fz8aOSYxAG1IzYwsRD32UNM
	 DrwBzfNhkdXP9q5I9mBz3yb4UT1APWbAkXyYJe/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 548/620] s390/traps: Fix test_monitor_call() inline assembly
Date: Mon, 10 Mar 2025 18:06:34 +0100
Message-ID: <20250310170607.176803736@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -281,10 +281,10 @@ static void __init test_monitor_call(voi
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


