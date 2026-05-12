Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C7349AF5;
	Tue, 12 May 2026 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609208; cv=none; b=nzFjLRRwHkmNgq9nAtPUMLDoZDNpc2s2Dl9j2IpWOZzBDKrYaezMFaZOmTYxMW8bzVpxgKxmuil6u1god21p/8YV3sQ0XCeqkk5aP43c3JJuI0skzYeCakJHAxZ0Gnjm0CyI6+DD2C0Fc1VwxsKVRaQ0x3U1T79O8sJaAz3rmmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609208; c=relaxed/simple;
	bh=/xihcwAI/RtSSKAXPS+vx8gYONKqnnVHIVEg89Ah6pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca9l5cc/P6zCQ8Bc0wzU4AL98hKU30JfDOziWCSHwYFYVAr3rPxXt30NH7n7HVUnh1mAOvfFErh1ukUz7l9lddK7nqCFzCFoU0GYbuO/p5UQUFJ4PooLv6juSgCtbh/ECbY/mA4vC0wVp3YOanh9sBx9DueX/rE+ziQrxp0jjo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbkevLRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbkevLRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845E5C2BCB0;
	Tue, 12 May 2026 18:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609207;
	bh=/xihcwAI/RtSSKAXPS+vx8gYONKqnnVHIVEg89Ah6pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbkevLRjQMQAmZUDTe7P0zLSkX7gIV8TRdeZlktZ7xL2QX1PSeKE44primdrGZaqY
	 jnaACIes+h1bCEtJZK1UcZxOuXpAtRip47J080KfSHWjmj8e5AF9yYVSA/0k9ywVni
	 aF7d7Ef1XUtlZ5rb9jzGoih5hsgrsNR/PyNw2H80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH 7.0 105/307] rseq: Dont advertise time slice extensions if disabled
Date: Tue, 12 May 2026 19:38:20 +0200
Message-ID: <20260512173942.341931512@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

commit 010b7723c0a3b9ad58f50b715dbe2e7781d29400 upstream.

If time slice extensions have been disabled on the kernel command line,
then advertising them in RSEQ flags is wrong.

Adjust the conditionals to reflect reality, fixup the misleading comments
about the gap of these flags and the rseq::flags field.

Fixes: d6200245c75e ("rseq: Allow registering RSEQ with slice extension")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://patch.msgid.link/20260428224427.437059375%40kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rseq.h |    5 ++++-
 kernel/rseq.c             |    9 +++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -28,7 +28,7 @@ enum rseq_cs_flags_bit {
 	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT	= 0,
 	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT	= 1,
 	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT	= 2,
-	/* (3) Intentional gap to put new bits into a separate byte */
+	/* (3) Intentional gap to keep new bits separate */
 
 	/* User read only feature flags */
 	RSEQ_CS_FLAG_SLICE_EXT_AVAILABLE_BIT	= 4,
@@ -161,6 +161,9 @@ struct rseq {
 	 *	- RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
 	 *	- RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
 	 *	- RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+	 *
+	 * It is now used for feature status advertisement by the kernel.
+	 * See: enum rseq_cs_flags_bit for further information.
 	 */
 	__u32 flags;
 
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -462,10 +462,11 @@ SYSCALL_DEFINE4(rseq, struct rseq __user
 		return -EFAULT;
 
 	if (IS_ENABLED(CONFIG_RSEQ_SLICE_EXTENSION)) {
-		rseqfl |= RSEQ_CS_FLAG_SLICE_EXT_AVAILABLE;
-		if (rseq_slice_extension_enabled() &&
-		    (flags & RSEQ_FLAG_SLICE_EXT_DEFAULT_ON))
-			rseqfl |= RSEQ_CS_FLAG_SLICE_EXT_ENABLED;
+		if (rseq_slice_extension_enabled()) {
+			rseqfl |= RSEQ_CS_FLAG_SLICE_EXT_AVAILABLE;
+			if (flags & RSEQ_FLAG_SLICE_EXT_DEFAULT_ON)
+				rseqfl |= RSEQ_CS_FLAG_SLICE_EXT_ENABLED;
+		}
 	}
 
 	scoped_user_write_access(rseq, efault) {


