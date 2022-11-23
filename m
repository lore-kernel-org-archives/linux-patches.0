Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED95E1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4ABC433D7;
	Wed, 23 Nov 2022 09:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197076;
	bh=Dxw+JxFyB9dso11235OTLMOl7ze509DMwUFuMvzxTw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL4rorxuYZI/En9auCMV8zjXYgHPCjfQ5D7ou3epHbLHJKKxTPcedhBEpn930yvY3
	 KX5By+2ShUQ+e+27Uk5+6jPU1Olbq62mdiEsLUtbigdm9/TJ10MgJ2eemn00HrNueT
	 TIdk26eOceqgeu8I9XB7lK2Ad3roDpUH3Uk0Vu0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 191/314] s390: avoid using global register for current_stack_pointer
Date: Wed, 23 Nov 2022 09:50:36 +0100
Message-Id: <20221123084634.212088267@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit e3c11025bcd2142a61abe5806b2f86a0e78118df ]

Commit 30de14b1884b ("s390: current_stack_pointer shouldn't be a
function") made current_stack_pointer a global register variable like
on many other architectures. Unfortunately on s390 it uncovers old
gcc bug which is fixed only since gcc-9.1 [gcc commit 3ad7fed1cc87
("S/390: Fix PR89775. Stackpointer save/restore instructions removed")]
and backported to gcc-8.4 and later. Due to this bug gcc versions prior
to 8.4 generate broken code which leads to stack corruptions.

Current minimal gcc version required to build the kernel is declared
as 5.1. It is not possible to fix all old gcc versions, so work
around this problem by avoiding using global register variable for
current_stack_pointer.

Fixes: 30de14b1884b ("s390: current_stack_pointer shouldn't be a function")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index bd66f8e34949..00f45d8f1efa 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -202,7 +202,16 @@ unsigned long __get_wchan(struct task_struct *p);
 /* Has task runtime instrumentation enabled ? */
 #define is_ri_task(tsk) (!!(tsk)->thread.ri_cb)
 
-register unsigned long current_stack_pointer asm("r15");
+/* avoid using global register due to gcc bug in versions < 8.4 */
+#define current_stack_pointer (__current_stack_pointer())
+
+static __always_inline unsigned long __current_stack_pointer(void)
+{
+	unsigned long sp;
+
+	asm volatile("lgr %0,15" : "=d" (sp));
+	return sp;
+}
 
 static __always_inline unsigned short stap(void)
 {
-- 
2.35.1



