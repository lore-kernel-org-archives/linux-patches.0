Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC8A1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363E2C433D7;
	Wed, 23 Nov 2022 09:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197529;
	bh=RPG5qSX8gxOwT9HLzoJMVEcJ0jf9kOO4VChFLrKV11o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7eTVjAPJUbng/MzAKMUFTTWQ6u6ngUcVUnDMkg0aO+x20lPuJqrfgqRSdgfTQ/+f
	 kS+KOeVVtvl8hbtTm918G1KIvVD/uSAEtlQ5y7RzaLa/Iz1AjLpOBh6er9xJCRxk17
	 5RwCAJ6vQv6tkd/IXjzvCWMFj03hSZM+p8GjyRw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.0 308/314] rseq: Use pr_warn_once() when deprecated/unknown ABI flags are encountered
Date: Wed, 23 Nov 2022 09:52:33 +0100
Message-Id: <20221123084639.525039336@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 448dca8c88755b768552e19bd1618be34ef6d1ff upstream.

These commits use WARN_ON_ONCE() and kill the offending processes when
deprecated and unknown flags are encountered:

commit c17a6ff93213 ("rseq: Kill process when unknown flags are encountered in ABI structures")
commit 0190e4198e47 ("rseq: Deprecate RSEQ_CS_FLAG_NO_RESTART_ON_* flags")

The WARN_ON_ONCE() triggered by userspace input prevents use of
Syzkaller to fuzz the rseq system call.

Replace this WARN_ON_ONCE() by pr_warn_once() messages which contain
actually useful information.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lkml.kernel.org/r/20221102130635.7379-1-mathieu.desnoyers@efficios.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rseq.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -171,12 +171,27 @@ static int rseq_get_rseq_cs(struct task_
 	return 0;
 }
 
+static bool rseq_warn_flags(const char *str, u32 flags)
+{
+	u32 test_flags;
+
+	if (!flags)
+		return false;
+	test_flags = flags & RSEQ_CS_NO_RESTART_FLAGS;
+	if (test_flags)
+		pr_warn_once("Deprecated flags (%u) in %s ABI structure", test_flags, str);
+	test_flags = flags & ~RSEQ_CS_NO_RESTART_FLAGS;
+	if (test_flags)
+		pr_warn_once("Unknown flags (%u) in %s ABI structure", test_flags, str);
+	return true;
+}
+
 static int rseq_need_restart(struct task_struct *t, u32 cs_flags)
 {
 	u32 flags, event_mask;
 	int ret;
 
-	if (WARN_ON_ONCE(cs_flags & RSEQ_CS_NO_RESTART_FLAGS) || cs_flags)
+	if (rseq_warn_flags("rseq_cs", cs_flags))
 		return -EINVAL;
 
 	/* Get thread flags. */
@@ -184,7 +199,7 @@ static int rseq_need_restart(struct task
 	if (ret)
 		return ret;
 
-	if (WARN_ON_ONCE(flags & RSEQ_CS_NO_RESTART_FLAGS) || flags)
+	if (rseq_warn_flags("rseq", flags))
 		return -EINVAL;
 
 	/*


