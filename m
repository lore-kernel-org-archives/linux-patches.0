Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA7041212
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6eEF3jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D244C433C8;
	Wed, 15 Nov 2023 19:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076758;
	bh=DuC2cYsTmwU2t+qPetEuNe7STmKhJ+pDCR+zykjUT9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6eEF3jGuV+nE/UEgmOgp4iBbP3DCM0f2tf+fM2BnWgLYqoqsiAycgqifn92sY3+f
	 YW9yGomiI8//vjOWFzqAPyDofnwNWc0xoXfo7XlBcH/jc4H8EfGEpq7xeclHL7yiPr
	 f0DT/7KoBFU5BRU08vQkT73PsYttqwXmwDGsoJSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/603] futex: Dont include process MM in futex key on no-MMU
Date: Wed, 15 Nov 2023 14:09:23 -0500
Message-ID: <20231115191614.436202889@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Wolsieffer <ben.wolsieffer@hefring.com>

[ Upstream commit c73801ae4f22b390228ebf471d55668e824198b6 ]

On no-MMU, all futexes are treated as private because there is no need
to map a virtual address to physical to match the futex across
processes. This doesn't quite work though, because private futexes
include the current process's mm_struct as part of their key. This makes
it impossible for one process to wake up a shared futex being waited on
in another process.

Fix this bug by excluding the mm_struct from the key. With
a single address space, the futex address is already a unique key.

Fixes: 784bdf3bb694 ("futex: Assume all mappings are private on !MMU systems")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: André Almeida <andrealmeid@igalia.com>
Link: https://lore.kernel.org/r/20231019204548.1236437-2-ben.wolsieffer@hefring.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index f10587d1d4817..f30a93e50f65e 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -248,7 +248,17 @@ int get_futex_key(u32 __user *uaddr, bool fshared, union futex_key *key,
 	 *        but access_ok() should be faster than find_vma()
 	 */
 	if (!fshared) {
-		key->private.mm = mm;
+		/*
+		 * On no-MMU, shared futexes are treated as private, therefore
+		 * we must not include the current process in the key. Since
+		 * there is only one address space, the address is a unique key
+		 * on its own.
+		 */
+		if (IS_ENABLED(CONFIG_MMU))
+			key->private.mm = mm;
+		else
+			key->private.mm = NULL;
+
 		key->private.address = address;
 		return 0;
 	}
-- 
2.42.0



