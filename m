Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A2622E407;
	Mon, 10 Mar 2025 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628004; cv=none; b=TvCzRnzyFWr3y/7cGpPJavSPrnI6e/x9K1HkXKF06Bh57IRmA/3Or9SFy8HnvRrRUFQgz/OGTZjaXeopO5YZk3W3+hfOetwFR0Vx+Ltnf8RXKqzqEYP+Ua67O/fEDhihqYcJCdVsTe4rt05/BC1mlxmjZ3+MNdBs6XqAhH2Sa1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628004; c=relaxed/simple;
	bh=wmH4FYRzZ88EY57gLgOUSthJDVv+sz1z+3hJB2xssVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjn8t4IO0cLvEtHHxYh7hnsCxSGmWdoeyM0eR1wA6y1nudmcI1ObQWX8rePk2FXDw03FcDyZ/dPWY9Opnz9snjqEq9F9To4d3drJaQXTOBR84mx7mBJL38DU6gWsXaLUA4Uy/MQ4HEAo/xbC5BpiWtGA0xeyx2HXf+EyPjB/MAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xj/8yfZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xj/8yfZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF04C4CEE5;
	Mon, 10 Mar 2025 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628004;
	bh=wmH4FYRzZ88EY57gLgOUSthJDVv+sz1z+3hJB2xssVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xj/8yfZecYDZkkFQDMpEJXwUpFgHdNvkBjiHMdlq2AgX6WbCIV957PoZGgzijQimN
	 bepGDrEACaEiktNVWnRZJoMhoNORECRFXf5t8yYbzamgZddmlthVH4MdHPTjIcnZ/Y
	 I8bp4CJmhw5PRunIWDb0IGI7vakcpUkh059E4R5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 054/145] s390/traps: Fix test_monitor_call() inline assembly
Date: Mon, 10 Mar 2025 18:05:48 +0100
Message-ID: <20250310170436.919114530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -276,10 +276,10 @@ static void __init test_monitor_call(voi
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


