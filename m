Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686FB233149;
	Mon, 10 Mar 2025 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627442; cv=none; b=I8o8COk2ccOwckx5GlbgJ2Wt3k9KbGJxKaQyjoFE/4ELMEuI73+a2YmP+xXurPG7oDfZGopyIJTcIHvZMUuZwHuTel8QCWfm6ZVmlA4bcHHGEvjV+CXaBtgg4JQG9iYhe5wOJwEWgYyVB2b/86Wwl691LPTxwCuau691Ab756cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627442; c=relaxed/simple;
	bh=koPw3EbEcyxUkGx2lzzLr8dxLYv3JlB9mLH5UxoSUkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYzsq6wVuHEN+xxo9Iv0DQ50cCMhnyI5M1+Wqs2Ct+olTzdJ7s1KDO7g3OOKE6uoTj8NycWP8kOX+NNmxUBICd4GhazgBQHRV6x1Sy+UXBdqe9/NC88suV9Two5Y5u0zQl/5Gl+pBhUkZ8ycXIw9M0R3zLwbYEcIPRoRdIwkRDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rT3/0N7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rT3/0N7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DFAC4CEE5;
	Mon, 10 Mar 2025 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627442;
	bh=koPw3EbEcyxUkGx2lzzLr8dxLYv3JlB9mLH5UxoSUkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rT3/0N7lNLd0RGh3ruYLbn4cMfYs0rMNcEgTgM/I86qh2Xdh8ik6oIZ6RLJFWPC7t
	 DB9gXOYbALZDBHjX7xnMxVV0MmHUcD6LwGRy0X3lNTHukpgY94CSBl9Q+AKCZ1rKQe
	 e0zcyyM6aXCtQ1/89qNHuc9bSXUjTwUEIYWyAJBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 130/269] s390/traps: Fix test_monitor_call() inline assembly
Date: Mon, 10 Mar 2025 18:04:43 +0100
Message-ID: <20250310170502.903419287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -284,10 +284,10 @@ static void __init test_monitor_call(voi
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


