Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062302;
	b=opwA/Wh2TcrjXz8QXkT2OwzHr8C09hNydFw8B0NcGlvEwUC2VglLxJh1YH3Fdhkz7PnG
	 38V41UH4OawgdAWeFGv4EqaEnW8PzbMqJej4q/GwAQJ0Xj/78iNp70gXluumt12MQ+oBs
	 IIeThizO0Vp3AVWt5jo5uVH/w7t3AEN2RggYoiZo1bAyttGd6Ib1chkiPB1AxyHRZ0/h0
	 Bje8qPWa0WPoFGhYkG2ndetnwEdt3CMwJvZWILlQDydeMXhhQPkT8V/t9o/o06aWOUNOq
	 lghgFUbWRCWqln7jtG8zD8m9Tp/HBh2T+uAaGgxJSlRNsVKmjY5z6lt5V8O6+5ca1fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t6/8ZA8MrsHd+knJNL2ycpQudSIH6DtQFb/xcdw9h4g=;
	b=MFxYx7mucm4tuUwoowqWw4DNwPCGxLU8PF6SA0w3L2HYtRpOydz6ndsHjEsw07ybfLTa
	 C86mcfNDzRDlkvN+iFWDeGcy/15E+d6G2CvRxdDR30JI7LgVAICjrGtFfT6EBddEdExQL
	 Yskt3oq7JlTKSNpzaoo39+cro+BZsy3InAfhbUAbaB0T5RfhbRY1pFRd6khuS/KJcrwcI
	 IUDMrzvniIqtcN1KBl7sQy1w5s/nn7H5wKZrYJ9cqrTmOhwH0jWkCQeDD1TRyvvWdSsTJ
	 YyRb2a5YDwdDPPkaB4ygE4mLsqAa2HLe5qMDoZYSLXH/A+bCr4snumVwaGEerZjn9zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rT/1lv7C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C6160A3839;
	Sat,  7 Nov 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rT/1lv7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0988F1F0089F;
	Sat,  7 Nov 2026 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062302;
	bh=t6/8ZA8MrsHd+knJNL2ycpQudSIH6DtQFb/xcdw9h4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rT/1lv7CJGxLa9Ag4Z0XHsCia5thqfwqcPQ0xHsVgd48coyzbm81kcX8/KSMIPtEv
	 IdJxjxM3lsGe1+Ryzons1AXBkQFRKfqSjnIAn92KdzXKu6S1FvLDO9Xjgc1NLkRk8k
	 mnJtOx+LdLvhJopmGdnJ5kRBNyEcTvDG647HLI1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasios Papagiannis <tasos.papagiannnis@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Hajime Tazaki <thehajime@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1200/1536] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Sat,  7 Nov 2026 08:53:36 -0500
Message-ID: <20261107135031.455388062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

[ Upstream commit 51a8de81fd2edbf87d8046e352060329bb216fad ]

The NOMMU implementation of access_process_vm() rejects address ranges
whose end wraps around, but access_remote_vm() bypasses this check even
though both functions delegate to __access_remote_vm().

Move the wraparound check into __access_remote_vm() so it applies to both
entry points.

This is originally reported in [1].

Link: https://lore.kernel.org/20260909064231.18693-1-tasos.papagiannnis@gmail.com
Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/ [1]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Hajime Tazaki <thehajime@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/nommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 9cb6e99215e2b..b1f118235dd5e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1634,6 +1634,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1687,9 +1690,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 {
 	struct mm_struct *mm;
 
-	if (addr + len < addr)
-		return 0;
-
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
-- 
2.53.0



