Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBDC1E25F8;
	Wed, 19 Feb 2025 08:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953980; cv=none; b=odZNe9t4J9CM13tU26wVPCM561/k446E2GGkAFovMQS3ieunJLbu4mFkaSncDA8UvMvk0BBuc7vzorKp0aaCDMZ0vwkN4oP9e4n1Ql6kMAF2nIb2qVfzL4w0ZZuQmSyQoWvqEr4HM5VDFv8iglqniypCYJ4aFHMZnZL1k2SH2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953980; c=relaxed/simple;
	bh=naJH5m+N2286qhjaywTPLvZh3KlYTbevl7jTglniVvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibAcdTJ6uLFRLocmMImtKynvOE4MiyBfLknJKYO7Dj9l/VKlt69JxARJK76NoXSO03k/Y2l+gSqVtk44902wYgODLbvdNmtgqnApdMCB1JANhHgJLsiTOYkHBL5xg4bHflLr6grWr5v+eNisyAErn/7Mfmpso7D3rnyk3y9YGSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jkgv9mxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jkgv9mxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233FEC4CEE8;
	Wed, 19 Feb 2025 08:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953979;
	bh=naJH5m+N2286qhjaywTPLvZh3KlYTbevl7jTglniVvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jkgv9mxVjAo+7AKzZDhd/jcRYlT1dkDwG7ETgsL3Q+NwkwXpVxEOn0xVmly+RNrkd
	 eZE2KuUBLcuZuOOvz3yMkJSHm3uBe8cZxYXy4Ii7LEMwleKdBlVLksTa28O7kQC5XM
	 rO7RHeEE+/4VAe/K2ddb+5elMUYR/By6xt6gIoiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Washburn <development@efficientek.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 057/274] um: fix execve stub execution on old host OSs
Date: Wed, 19 Feb 2025 09:25:11 +0100
Message-ID: <20250219082611.860512003@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit f82a9e7b9fa922bb9cccb00aae684a27b79e6df7 ]

The stub execution uses the somewhat new close_range and execveat
syscalls. Of these two, the execveat call is essential, but the
close_range call is more about stub process hygiene rather than safety
(and its result is ignored).

Replace both calls with a raw syscall as older machines might not have a
recent enough kernel for close_range (with CLOSE_RANGE_CLOEXEC) or a
libc that does not yet expose both of the syscalls.

Fixes: 32e8eaf263d9 ("um: use execveat to create userspace MMs")
Reported-by: Glenn Washburn <development@efficientek.com>
Closes: https://lore.kernel.org/20250108022404.05e0de1e@crass-HP-ZBook-15-G2
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20250113094107.674738-1-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/skas/process.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index f683cfc9e51a5..e2f8f156402f5 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -181,6 +181,10 @@ extern char __syscall_stub_start[];
 
 static int stub_exe_fd;
 
+#ifndef CLOSE_RANGE_CLOEXEC
+#define CLOSE_RANGE_CLOEXEC	(1U << 2)
+#endif
+
 static int userspace_tramp(void *stack)
 {
 	char *const argv[] = { "uml-userspace", NULL };
@@ -202,8 +206,12 @@ static int userspace_tramp(void *stack)
 	init_data.stub_data_fd = phys_mapping(uml_to_phys(stack), &offset);
 	init_data.stub_data_offset = MMAP_OFFSET(offset);
 
-	/* Set CLOEXEC on all FDs and then unset on all memory related FDs */
-	close_range(0, ~0U, CLOSE_RANGE_CLOEXEC);
+	/*
+	 * Avoid leaking unneeded FDs to the stub by setting CLOEXEC on all FDs
+	 * and then unsetting it on all memory related FDs.
+	 * This is not strictly necessary from a safety perspective.
+	 */
+	syscall(__NR_close_range, 0, ~0U, CLOSE_RANGE_CLOEXEC);
 
 	fcntl(init_data.stub_data_fd, F_SETFD, 0);
 	for (iomem = iomem_regions; iomem; iomem = iomem->next)
@@ -224,7 +232,9 @@ static int userspace_tramp(void *stack)
 	if (ret != sizeof(init_data))
 		exit(4);
 
-	execveat(stub_exe_fd, "", argv, NULL, AT_EMPTY_PATH);
+	/* Raw execveat for compatibility with older libc versions */
+	syscall(__NR_execveat, stub_exe_fd, (unsigned long)"",
+		(unsigned long)argv, NULL, AT_EMPTY_PATH);
 
 	exit(5);
 }
-- 
2.39.5



