Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A843911BD;
	Sat, 12 Sep 2026 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203031; cv=none; b=dWhIKD9+Qq93YOjI8eKVYf2rCMeFflePJLr7y3mJ+LuiRh9ngpIS7SauqFI9WthyujgcBRbcgsSPRC30ZHRlOR0/mnoIwa6Q/Lh42D3XxxPmsGwYqp1Bb7H+ZWMdh8e0GKKfiQrzIwQWi8ieJUpZ43pkGRQaUVIme5C3+HcBon8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203031; c=relaxed/simple;
	bh=FA1gQbr7LykTqWP6ntYNI08zqk5vLZ3V/Y/W1eD9X6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofgJflUyxd+dMnakxDo0wX9npUV24lD9U5dI+xVVh0EzN/ww9bWqTNtVAHNSFPxxSNRTlQknWwt3P/TsCSXfAFSEUIHHB9B3w7JeREL5Px8lrnN8/OUTpZeeAqv/RqqUQJ4hVRngQWIB+yW4uyQlrzzK1e4q0zMmTOPQ6/xya3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzFuLOAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzFuLOAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5981F000FF;
	Sat, 12 Sep 2026 08:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203029;
	bh=15gKVlmBgi1HF0xqUmjYSwoYLa7Hl/jgxBStaAA3Zv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzFuLOAwSfV5YW0ZnUlqfJ3t2Q7QmAh8Ns4VZAwW0pKEjc/gQK0reQ7r8Nm32EFJn
	 SI/aheF5c8fijbkdNpHbpd8uLu5ZUJ4twBWfq5YiMz9BtgNvDadj+mCvL2d+e8r1R/
	 RM03Dzoz+PJbMVBDLNciwWFJMa7W3xPud9uxEXlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1323/1815] selftests/sched_ext: Check skeleton open failure in exit test
Date: Sat, 12 Sep 2026 08:51:13 +0200
Message-ID: <20260912065720.084011949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit 4dc310b41aba43e9d8dfafe46dce86f8b55c0354 ]

exit.c does not check the return value of exit__open(). If it returns
NULL, which happens when the skeleton wrapper fails to allocate the
object or open the BPF ELF, the very next line dereferences it via
SCX_ENUM_INIT(). That macro expands to SCX_ENUM_SET(), which accesses
skel->rodata, causing a NULL pointer dereference.

Every other selftest guards this with SCX_FAIL_IF(!skel, ...); exit.c
is the only one missing it.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/sched_ext/exit.c b/tools/testing/selftests/sched_ext/exit.c
index b987611789d16..01b17092d5c8f 100644
--- a/tools/testing/selftests/sched_ext/exit.c
+++ b/tools/testing/selftests/sched_ext/exit.c
@@ -31,6 +31,7 @@ static enum scx_test_status run(void *ctx)
 			continue;
 
 		skel = exit__open();
+		SCX_FAIL_IF(!skel, "Failed to open");
 		SCX_ENUM_INIT(skel);
 		skel->rodata->exit_point = tc;
 		SCX_FAIL_IF(exit__load(skel), "Failed to load skel");
-- 
2.53.0



