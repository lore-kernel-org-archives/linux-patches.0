Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8DA36A36A;
	Wed, 20 May 2026 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298031; cv=none; b=rm184FrRM8efeIUfn0aYbJbfBISQK2yCSDuKdT8BkMPcrV7/lKjQoSlX0wMKTg4yuMJUJriM200t7s+mJZeuFy8vTGNY1Pme+ETDoLAvZw/Zw/jHSryWkjCwA9dIbOnVZHJCXAc+dI7cjkkXyT+47Ffz3LjBIvfuW4tzMUjxSok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298031; c=relaxed/simple;
	bh=qxHRYBSsM8alJHtak0KtnkwbHAzZyjWYtYJXeH3Pgcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2aT7TdBqK7K1aTb63961wf/FZVisHDZst0kNr0SK8Qi8k2LoBl7YaLOfwgvhNR3ESm/2S7z3kP9I1x2AB/KVicHnwbPXIwFCWXDUFyhsNWuIkJkiG2cbQe80Z16zOwJCzE1ICp85RPXxdOYrOMaRQNUdODF5CSBINYHNRYrE28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xA/ezMGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xA/ezMGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1E91F000E9;
	Wed, 20 May 2026 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298030;
	bh=CX3FcvWLjdTPQ3BCdnFDwDdJ+c/kH9kyqmekbtssWNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xA/ezMGZdMnQPzCbgIToaDzwSRmR8FcQIFBSVw/D9qK3bzmuvGiRKglx30XmtaATL
	 o4fyu9+kTV6nWRjtJp3yA6ojbn8hKdq7Z3iGgCuLREiXdve96/cfMiL3/k/cpfY97s
	 ZSMFYAGflaX/aUsCxq62s0PO+qKCpcaeD2wh9nzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/957] selftests/sched_ext: Add missing error check for exit__load()
Date: Wed, 20 May 2026 18:11:42 +0200
Message-ID: <20260520162139.291211195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 1d02346fec8d13b05e54296ddc6ae29b7e1067df ]

exit__load(skel) was called without checking its return value.
Every other test in the suite wraps the load call with
SCX_FAIL_IF(). Add the missing check to be consistent with the
rest of the test suite.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sched_ext/exit.c b/tools/testing/selftests/sched_ext/exit.c
index ee25824b1cbe6..b987611789d16 100644
--- a/tools/testing/selftests/sched_ext/exit.c
+++ b/tools/testing/selftests/sched_ext/exit.c
@@ -33,7 +33,7 @@ static enum scx_test_status run(void *ctx)
 		skel = exit__open();
 		SCX_ENUM_INIT(skel);
 		skel->rodata->exit_point = tc;
-		exit__load(skel);
+		SCX_FAIL_IF(exit__load(skel), "Failed to load skel");
 		link = bpf_map__attach_struct_ops(skel->maps.exit_ops);
 		if (!link) {
 			SCX_ERR("Failed to attach scheduler");
-- 
2.53.0



