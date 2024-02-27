Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D7145356;
	Tue, 27 Feb 2024 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044076; cv=none; b=hzAyR8wwrhuthZuWIqWg5Hys2PxJ/4Cs4I4xen6f3+ObdXcTr3C9K3caoRq4IaST6ZAa4ME4pkcmov4Z9yBhXAAY1+1+4ElrnVgSm917dBQmmM/l2lrd36ncmrCnIOMXeo6cK1k7bVKkHfw/F/GsJ0yqEPe2sfMnxZ4vsFHEwf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044076; c=relaxed/simple;
	bh=YVwBqWLauGOwlq1gWGNcYUuP7a1XHJOE+wftncEfZBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUnzHm88aOEZ2Ut6SccAE2Cipx7NhFVzowTtz6U68M9l8sbHxxsuL9VinilCQMmcz9k1K2A3lvMF3w+QFUWlcafC2VHlgRmj/rgTAnwszQe0lBcLK3zfpHMANm3GjarQLQRfEzvhsHQ1eDMsrK+F5zFyEY3WR8dLND3ZtHwtnQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dn/HGacr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dn/HGacr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549EFC43390;
	Tue, 27 Feb 2024 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044075;
	bh=YVwBqWLauGOwlq1gWGNcYUuP7a1XHJOE+wftncEfZBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dn/HGacri2wtky7+srPbqqFLaqqDAi/OXCDTWV0XMzWlAgkBnXrntv/EuGy0Rvrjj
	 iOJazPjRQt/QGxKXz2xhTxRr3ZbURM5MBEiMAViYrzpA6ysE9Q0xbeVPkuShY4VNfF
	 NWrU6Sm7WALqATl/oDBLDq1I0JKoQm7POQ3LD2Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/122] powerpc/watchpoints: Annotate atomic context in more places
Date: Tue, 27 Feb 2024 14:26:55 +0100
Message-ID: <20240227131600.476671712@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit 27646b2e02b096a6936b3e3b6ba334ae20763eab ]

It can be easy to miss that the notifier mechanism invokes the callbacks
in an atomic context, so add some comments to that effect on the two
handlers we register here.

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230829063457.54157-4-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 49273f67c7498..ca3374c6f3749 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -611,6 +611,11 @@ static void handle_p10dd1_spurious_exception(struct arch_hw_breakpoint **info,
 	}
 }
 
+/*
+ * Handle a DABR or DAWR exception.
+ *
+ * Called in atomic context.
+ */
 int hw_breakpoint_handler(struct die_args *args)
 {
 	bool err = false;
@@ -737,6 +742,8 @@ NOKPROBE_SYMBOL(hw_breakpoint_handler);
 
 /*
  * Handle single-step exceptions following a DABR hit.
+ *
+ * Called in atomic context.
  */
 static int single_step_dabr_instruction(struct die_args *args)
 {
@@ -794,6 +801,8 @@ NOKPROBE_SYMBOL(single_step_dabr_instruction);
 
 /*
  * Handle debug exception notifications.
+ *
+ * Called in atomic context.
  */
 int hw_breakpoint_exceptions_notify(
 		struct notifier_block *unused, unsigned long val, void *data)
-- 
2.43.0



