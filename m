Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3230383998;
	Tue, 25 Aug 2026 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664561; cv=none; b=WHihOpT+FtIfuvF2LlBUyKlYbzaVwWYMjNVpYBvKlzS7Muhc9SJ/geU9ZaAt2239vMuvD1Hjyl3sHu8Kepiwuoo98e5vg7zhwCRlSpbUBUMkN2oIitxFCgttFILKOoifGx3wIwIHoGtRaD52X78dgANtUFCCcyEvmehkieB6qPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664561; c=relaxed/simple;
	bh=AkixRHQ4h85QISgmdQQhI3uP9Gwas0fWlEvQROuhLvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa3uKW48J9FMrt1/JxP6DncEOGsJvjkspUx7gqLyo0+YoS66QF4WQSp/rf8BuEgS0MA1/DUGS/L24Le1vR2ClkkpHUa2/yR6SZwkoigcAh1HDDVmpIeJI0epiVhU1Gz3s64fCQIeZGFcobvqlJNyK3V4XnEat/0BpXxcVTcx084=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwbzOsj6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwbzOsj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F04D1F000E9;
	Tue, 25 Aug 2026 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664559;
	bh=poIt6euI8QyEY7DIORmV1229KxncP5oQZtHUulxr/n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwbzOsj6dZVdICyYEV4fgQAU+Tsyt8T1kiHMT5SlIO4X3tihCLl8L77sdgg0MSuF9
	 N7mr1Uj/dWtFOUB1gg5Grv4v0qwaaOhRNABEsEzv2KsqcdLXyHR2JK97K/MXmORStD
	 x0fe3j5gLp0GOsTy/Y408UkbPZlSpFRwf9Tb0u3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.2 12/82] futex: Avoid private hash use-after-free on final put
Date: Tue, 25 Aug 2026 15:24:59 +0200
Message-ID: <20260825132542.010975254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Hoffmann <f3lix.dev@gmx.de>

commit 1c7efabfbaf796f11000a46094a69955a01ec6cc upstream.

futex_private_hash_put() drops the reference to fph before evaluating
fph->mm for wake_up_var(). futex_ref_put() enables preemption again before
returning. If that put drops the final reference and the task is preempted,
another task can pivot to the replacement hash and free the old hash after
an RCU grace period. The first task then reads fph->mm from the freed
allocation when it resumes.

KASAN reports a slab-use-after-free in futex_private_hash_put(), with the
read at offset 24 in a freed kmalloc-512 allocation. The allocation and
free stacks point to futex_hash_allocate() and the RCU free path,
respectively.

Load the mm pointer while the fph reference is still held and pass the
saved value to wake_up_var(). wake_up_var() uses the pointer as a waitqueue
key and does not dereference the mm through it.

Fixes: bd54df5ea7ca ("futex: Allow to resize the private local hash")
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260731155024.1150011-1-f3lix.dev@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -143,8 +143,14 @@ static bool futex_private_hash_get(struc
 
 void futex_private_hash_put(struct futex_private_hash *fph)
 {
-	if (fph && futex_ref_put(fph))
-		wake_up_var(fph->mm);
+	struct mm_struct *mm;
+
+	if (!fph)
+		return;
+
+	mm = fph->mm;
+	if (futex_ref_put(fph))
+		wake_up_var(mm);
 }
 
 static struct futex_hash_bucket *


