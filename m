Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDEC168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF17C433D2;
	Mon,  8 May 2023 11:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545110;
	bh=Jc8Mdawx3aHNq1LRGryHP7p+OBu3CO0SNO7/bQfcUPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiiY26XMZg+m23mYtEKPP6caBG8nskflvKhrMnAGY//0OPSOHQzOhEAVXZELcj4W2
	 rJd2q0Zuvo6qqMTn3Y0eZkb9UM8XGG2Foq77oZ/SRZQsO7LV8ysQDD0bhUtJgVlSRm
	 5sicG7lixizeLqe/1XElUHPUMm+XFlIWaYta0oV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 628/694] openrisc: Properly store r31 to pt_regs on unhandled exceptions
Date: Mon,  8 May 2023 11:47:43 +0200
Message-Id: <20230508094455.975725269@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 812489ac4dd91144a74ce65ecf232252a2e406fb ]

In commit 91993c8c2ed5 ("openrisc: use shadow registers to save regs on
exception") the unhandled exception path was changed to do an early
store of r30 instead of r31.  The entry code was not updated and r31 is
not getting stored to pt_regs.

This patch updates the entry handler to store r31 instead of r30.  We
also remove some misleading commented out store r30 and r31
instructrions.

I noticed this while working on adding floating point exception
handling,  This issue probably would never impact anything since we kill
the process or Oops right away on unhandled exceptions.

Fixes: 91993c8c2ed5 ("openrisc: use shadow registers to save regs on exception")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/entry.S | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index 54a87bba35caa..a130c4dac48d3 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -173,7 +173,6 @@ handler:							;\
 	l.sw    PT_GPR28(r1),r28					;\
 	l.sw    PT_GPR29(r1),r29					;\
 	/* r30 already save */					;\
-/*        l.sw    PT_GPR30(r1),r30*/					;\
 	l.sw    PT_GPR31(r1),r31					;\
 	TRACE_IRQS_OFF_ENTRY						;\
 	/* Store -1 in orig_gpr11 for non-syscall exceptions */	;\
@@ -211,9 +210,8 @@ handler:							;\
 	l.sw    PT_GPR27(r1),r27					;\
 	l.sw    PT_GPR28(r1),r28					;\
 	l.sw    PT_GPR29(r1),r29					;\
-	/* r31 already saved */					;\
-	l.sw    PT_GPR30(r1),r30					;\
-/*        l.sw    PT_GPR31(r1),r31	*/				;\
+	/* r30 already saved */						;\
+	l.sw    PT_GPR31(r1),r31					;\
 	/* Store -1 in orig_gpr11 for non-syscall exceptions */	;\
 	l.addi	r30,r0,-1					;\
 	l.sw	PT_ORIG_GPR11(r1),r30				;\
-- 
2.39.2



