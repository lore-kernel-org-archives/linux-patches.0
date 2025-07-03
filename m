Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A8E2EF672;
	Thu,  3 Jul 2025 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554412; cv=none; b=guFQy3gZqHwNWpCYLZNPCT5v4NUtF4HAuwas61nktpcTYm2wdQ94MKkm6fOAGU6YvkVw4/8VO9pZy7lIct1JG7ilcyQq2CTiIoIrkkeHN7Ew7rPC1tP52OQx0Vy091I4/1FPWL/S13CqZ9xFW1tJq7pjvF0/0bhts3Yk3lkuJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554412; c=relaxed/simple;
	bh=qM5SEuJqLgRzw5uI1Lq2hnBeRryy70oRgSETfad44Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jloxu1RRg33JtB9H7GKJs3RCLqGMFIL61akv4owDGakgiX13vp8OphhmTMbwgM4YTzK3LqH6Yu/ZQLUz9majW9teOX2guxMEJnqni8zarjrSqAIpXCviwGex+ouVe5grDUDcyIhQ79ZnjZ/xFqjtV22HKNx3NnRSbIdy/1BIm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcryNDaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcryNDaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2D7C4CEE3;
	Thu,  3 Jul 2025 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554412;
	bh=qM5SEuJqLgRzw5uI1Lq2hnBeRryy70oRgSETfad44Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcryNDaA4vGNPmPvVOlHDYoTz3lcbXP45VxMlpQx9bXH25An/4cn9i/f0/NBISXNY
	 JOkO6HTsj2GkWFSBIhCvgSaitlC2hZnqSYqSYrUjdivM+1aiSURDeXPG91ryaOXJOE
	 eTUhdIlKnqUCXaDNsA6jWB1izwVy/6qZCUlNd7Gw=
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
Subject: [PATCH 6.12 179/218] x86/pkeys: Simplify PKRU update in signal frame
Date: Thu,  3 Jul 2025 16:42:07 +0200
Message-ID: <20250703144003.331961227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -317,7 +314,7 @@ static inline int xsave_to_user_sigframe
 	clac();
 
 	if (!err)
-		err = update_pkru_in_sigframe(buf, mask, pkru);
+		err = update_pkru_in_sigframe(buf, pkru);
 
 	return err;
 }


