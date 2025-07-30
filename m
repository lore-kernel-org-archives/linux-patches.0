Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B09620E6;
	Wed, 30 Jul 2025 09:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868655; cv=none; b=rUlgUPMez9g5s8tIA5Qh8gqs6KX+0F4OHjmznemhRMXihua1fKu3mYEVxanC3KwyPi4NOWAfGyc8VIvrACX3gAt2YSeBL9DMLumAKkrI16KLSiObRbgcjGwOTTlZ0eOnDJK76MM5WaJOWibHjr39lkSvpBRa3VTfsL5EB+CGvCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868655; c=relaxed/simple;
	bh=4QLlQ/ET9CcP6MYxzq9YOfqt7SUpEAIKQSmyeaGYdtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbyfmNmU/90SWGFL3CnqzXPxxBqBeujRcl3McqZNmGTyTsOM5iiJYHz/I3P8mAwhkMzlRT3q5uQZOFzkFdnf+tEWRFcE4KjBEu4IDSB6yklPY4a70jsYBGQP8A8wiSkK9wwySFEIiq9Md4cdhHgs+/pnYhIbab10MgITg0zbCg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYzSQyiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYzSQyiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FD9C4CEE7;
	Wed, 30 Jul 2025 09:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868655;
	bh=4QLlQ/ET9CcP6MYxzq9YOfqt7SUpEAIKQSmyeaGYdtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYzSQyiCGCynvJlbg2r98wjUWww0dxaXu9HsMeTpy1cdyHkLB02Q6ABPkh8jGNeoC
	 M+gN8a2lBlaI4Zw0mSxJexPsyRlqsEHxGb2b0csTcecWclsFrbk9Xxt+iMH1DABTla
	 JRH7FEVw/9v0rsZURiVrW/ptNKM5wmGnSAnNyr50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>,
	xu xin <xu.xin16@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 043/117] mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()
Date: Wed, 30 Jul 2025 11:35:12 +0200
Message-ID: <20250730093235.236389264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 153ad566724fe6f57b14f66e9726d295d22e576d upstream.

After a recent change in clang to expose uninitialized warnings from const
variables [1], there is a false positive warning from the if statement in
advisor_mode_show().

  mm/ksm.c:3687:11: error: variable 'output' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   3687 |         else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
        |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/ksm.c:3690:33: note: uninitialized use occurs here
   3690 |         return sysfs_emit(buf, "%s\n", output);
        |                                        ^~~~~~

Rewrite the if statement to implicitly make KSM_ADVISOR_NONE the else
branch so that it is obvious to the compiler that ksm_advisor can only be
KSM_ADVISOR_NONE or KSM_ADVISOR_SCAN_TIME due to the assignments in
advisor_mode_store().

Link: https://lkml.kernel.org/r/20250715-ksm-fix-clang-21-uninit-warning-v1-1-f443feb4bfc4@kernel.org
Fixes: 66790e9a735b ("mm/ksm: add sysfs knobs for advisor")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2100
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3643,10 +3643,10 @@ static ssize_t advisor_mode_show(struct
 {
 	const char *output;
 
-	if (ksm_advisor == KSM_ADVISOR_NONE)
-		output = "[none] scan-time";
-	else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
+	if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
 		output = "none [scan-time]";
+	else
+		output = "[none] scan-time";
 
 	return sysfs_emit(buf, "%s\n", output);
 }


