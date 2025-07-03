Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261682F0C6B;
	Thu,  3 Jul 2025 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555403; cv=none; b=bmqP5sS7Pfr4yjKcow45NXucmOh3LNJroXdh6cazjmTNb8OxhkdXF0WuOHLnaQT0LUOrpKDJgH3U05EojHoiVQUDEfWX0pzwa2xiBIkUF7L5ALsc6YvIuMM15sA4rz9dGiVFuBimYTyoxJpZJns8BgR+fpzSUW28QtW4OsIeaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555403; c=relaxed/simple;
	bh=YrxKQ9Mhuv7nUhXy0zqv4+NMFgygRTlb8IzYS6saKWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqS7ErLbSbvia9MqK64F29Jq7ZXkPIMzW1ihoReQ9FP3Z/E2LVu2eI6zt2aoZiMXJbyS4uXQejyo6dlzLXJ5yk+rwXtXTvaPMw6f8ufzrgd9lcVeuZn0+daQlTh0zHXbND3nwett377chrFOT9KgTfe5YxAziFCXH1//TgzFyhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEEh7+47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEEh7+47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA40C4CEEE;
	Thu,  3 Jul 2025 15:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555403;
	bh=YrxKQ9Mhuv7nUhXy0zqv4+NMFgygRTlb8IzYS6saKWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEEh7+47Lxp3vehbSIKNX91ZYkvcywiF+9pFsUmr0qc/b/wXPTjjYI1LEXTg+TGc6
	 6TfL6ha4SVkecB/9+u0IHgQfUZJeY90Mr1byJ9ZxN35gZ8//0pLfH1xhoxF6QMnt3H
	 FJbdZHN8mb9TdxzWxmJiLtcNVfgybqj+sDuycjGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.15 259/263] x86/pkeys: Simplify PKRU update in signal frame
Date: Thu,  3 Jul 2025 16:42:59 +0200
Message-ID: <20250703144014.792323706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chang S. Bae <chang.seok.bae@intel.com>

commit d1e420772cd1eb0afe5858619c73ce36f3e781a1 upstream.

The signal delivery logic was modified to always set the PKRU bit in
xregs_state->header->xfeatures by this commit:

    ae6012d72fa6 ("x86/pkeys: Ensure updated PKRU value is XRSTOR'd")

However, the change derives the bitmask value using XGETBV(1), rather
than simply updating the buffer that already holds the value. Thus, this
approach induces an unnecessary dependency on XGETBV1 for PKRU handling.

Eliminate the dependency by using the established helper function.
Subsequently, remove the now-unused 'mask' argument.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20250416021720.12305-9-chang.seok.bae@intel.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.h |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -85,18 +85,15 @@ static inline int set_xfeature_in_sigfra
 /*
  * Update the value of PKRU register that was already pushed onto the signal frame.
  */
-static inline int update_pkru_in_sigframe(struct xregs_state __user *buf, u64 mask, u32 pkru)
+static inline int update_pkru_in_sigframe(struct xregs_state __user *buf, u32 pkru)
 {
-	u64 xstate_bv;
 	int err;
 
 	if (unlikely(!cpu_feature_enabled(X86_FEATURE_OSPKE)))
 		return 0;
 
 	/* Mark PKRU as in-use so that it is restored correctly. */
-	xstate_bv = (mask & xfeatures_in_use()) | XFEATURE_MASK_PKRU;
-
-	err =  __put_user(xstate_bv, &buf->header.xfeatures);
+	err = set_xfeature_in_sigframe(buf, XFEATURE_MASK_PKRU);
 	if (err)
 		return err;
 
@@ -320,7 +317,7 @@ static inline int xsave_to_user_sigframe
 	clac();
 
 	if (!err)
-		err = update_pkru_in_sigframe(buf, mask, pkru);
+		err = update_pkru_in_sigframe(buf, pkru);
 
 	return err;
 }


