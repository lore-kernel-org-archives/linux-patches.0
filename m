Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4484B1F8697;
	Tue, 17 Dec 2024 17:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455677; cv=none; b=p5LKo//Ujv8XskT3mjqEBw+DQ/9C5paLLf2mMlWnLi7B2tGKkoej3AbxpKQeY0t5NnqTIHBaQMsJnmSM5epIdOf5G2aGbXnyZzvn3pz+dQoj+jpOkmarLlFceYNCm9cl3XF/6ydNSNkSdC3mRUI4bQh7chsBLiO9USYnJdvGv0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455677; c=relaxed/simple;
	bh=2alwl0enGVeAxGAUHXZit2ups6wxEPw3vBHfmWT9fao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW7zKIce09kQX4E8+Gr3NKky2B6Oe2E1DH73iaKXP5p0OEi3/pGdXnYzYGXQtlvTESJGJsqtpIIK/PC1M5vUov0613UNeLpE5UyWHslVENE8P5p9Xr2YuA3ZkELG1DOIGBsrpIGnKl1+Z5kLSBsfwi9iJNIGCtPpf4FxVeFcBi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CMfr7hQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CMfr7hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FCCC4CED3;
	Tue, 17 Dec 2024 17:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455677;
	bh=2alwl0enGVeAxGAUHXZit2ups6wxEPw3vBHfmWT9fao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CMfr7hQ7HRqkmTHRIfbnOipkFaCwNqA8G1JnBmWwHJxI8iuYWZeP4GzmToMis6z9
	 l08cHklmlVRNJqCrfLIu7nq7YRNrYLjTVwWmdN6Gn1QwQOSlGQS9tCsitmIvFttx0D
	 UH6OrwtO7G7m3ETygALD5jj+JyMW2lPMRN2daF4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.15 45/51] objtool/x86: allow syscall instruction
Date: Tue, 17 Dec 2024 18:07:38 +0100
Message-ID: <20241217170522.324410396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit dda014ba59331dee4f3b773a020e109932f4bd24 upstream.

The syscall instruction is used in Xen PV mode for doing hypercalls.
Allow syscall to be used in the kernel in case it is tagged with an
unwind hint for objtool.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3206,10 +3206,13 @@ static int validate_branch(struct objtoo
 			break;
 
 		case INSN_CONTEXT_SWITCH:
-			if (func && (!next_insn || !next_insn->hint)) {
-				WARN_FUNC("unsupported instruction in callable function",
-					  sec, insn->offset);
-				return 1;
+			if (func) {
+				if (!next_insn || !next_insn->hint) {
+					WARN_FUNC("unsupported instruction in callable function",
+						  sec, insn->offset);
+					return 1;
+				}
+				break;
 			}
 			return 0;
 


