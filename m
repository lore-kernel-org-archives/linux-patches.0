Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A254EDCBF;
	Thu, 17 Sep 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664182; cv=none; b=NqIow5ebP9oUg69lqV9CPFM/C3SW1Wf0o2yB4wvDRhuFZWzKxQ0vIhKyEqyidbQS6x2lyWif+DlUUupS3lNheaBkyKvOF8P0PAe9XyNRBHXFFtlBeh8/CpOw3lY1AcDbpTJKJT9GCRa81bTv/Len6wNCBQth4tr5IVRabbfISIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664182; c=relaxed/simple;
	bh=zaGtU+Uw42P43XhPTVsz4JQ/2ZwaW73zoKGcwPnLJk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2hTcKEUBb6kvGzPp8ALUBsF21t+JgQ+EcoKVGtF7tNGNl0a0je9vHYgh06CrDyUk9z/4Rs0xV1hltabrlUgsdMboe0XR95wniZTtzZo84os+Fia60wQkoKZ68nMggyjO9varmYQICN1grcAPYh6fZ9HXBA3CCSTydXoXYnDk0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGAaLcXE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGAaLcXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADDB1F000FF;
	Thu, 17 Sep 2026 16:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664181;
	bh=t3bQ0RytJe4CZCGU9qlNgdfbL4hl8DtpYrLSmIYirS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGAaLcXE+P3CHXwIwZo8JKlzoq2bs1T1ZjW0R9XV6N6zH7fVVX8Xh3Wq0ShrEQglk
	 qj50sPy63YjkhlfTDDbD4eqEotg/WsP8uMOH7IPpIwZFPOvgC7EgmiG8iSjbDJMrMU
	 M4dr3xcuUVcxqwUiHbfSlcGilZIEmPsb9KUvPWTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirisha G <shirisha@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Shivang Upadhyay <shivangu@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0285/1250] ppc/fadump: invoke kmsg_dump in fadump panic path
Date: Thu, 17 Sep 2026 16:01:20 +0100
Message-ID: <20260917151559.857969425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivang Upadhyay <shivangu@linux.ibm.com>

[ Upstream commit 6ed8332639853b77329594a241eb99fc36d591a2 ]

fadump is registered in panic_notifier_list and gets triggered before
kmsg_dump_desc() in the panic path. As a result, kmsg_dumpers such as
pstore are not executed during fadump crashes.

This is problematic because pstore provides a critical fallback mechanism
for crash analysis. When fadump fails to successfully reboot the system
or capture a dump, pstore logs may be the only available information from
the crashed kernel. Without invoking kmsg_dump_desc() in the fadump path,
we lose this valuable diagnostic data.

Invoke kmsg_dump_desc() from the fadump panic handler, but only when
fadump is actually registered (checked via should_fadump_crash()). This
ensures kmsg_dumpers are called without duplicating the call that occurs
later in panic() when fadump is not active.

The call is placed before crash_fadump() to ensure logs are captured
before the system attempts to trigger the firmware-assisted dump.

Reported-by: Shirisha G <shirisha@linux.ibm.com>
Suggested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Shivang Upadhyay <shivangu@linux.ibm.com>
Tested-by: Shirisha G <shirisha@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260412113057.46090-1-shivangu@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup-common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 68d47c53876c6..28186f9ec8da0 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -68,6 +68,7 @@
 #include <asm/kasan.h>
 #include <asm/mce.h>
 #include <asm/systemcfg.h>
+#include <linux/kmsg_dump.h>
 
 #include "setup.h"
 
@@ -744,6 +745,13 @@ static int ppc_panic_fadump_handler(struct notifier_block *this,
 	 */
 	hard_irq_disable();
 
+	/*
+	 * Invoke kmsg_dump (e.g., pstore) before crash_fadump() as fadump
+	 * runs before panic()'s kmsg_dump_desc() call.
+	 */
+	if (should_fadump_crash())
+		kmsg_dump_desc(KMSG_DUMP_PANIC, (char *)ptr);
+
 	/*
 	 * If firmware-assisted dump has been registered then trigger
 	 * its callback and let the firmware handles everything else.
-- 
2.53.0



