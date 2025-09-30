Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFC3846F;
	Tue, 30 Sep 2025 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245729; cv=none; b=loVtOwfpZjRAESTwuWph80wzKBU668PI5WtgMZvQoEC8bux2jL3AGoPM0lVrsq+yVYdYAOI30kRPd4OfUyINFQ/xI2MOIC2cSyYdvfqWFr4C6xyHAkovhzPOQsm4nRE8cu30rXeRIdP+PgA4DQM8AUIdT9tcWYWE6hEFJqBX9lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245729; c=relaxed/simple;
	bh=tTSH8rvrUUA51JY+CpDHGNd0ZDu0wR7aQkZzi0oHlPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLQBciVrf8mX0hD9UaabB3M2X40raDJFkYSP7ZfbH5M2mBrEFgLuhHQg/QJyBtZ7VZBikgHN3cRslQDsJB9GyZTHi+cNFhqgSgDhiDFZVKwgQLcIiGe0VFZwTlEVjeog0+n1hWO/8M35jUKN8qKfs8nULYZiI8EDLNxpll1G0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TR+eGbnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TR+eGbnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CD1C4CEF0;
	Tue, 30 Sep 2025 15:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245729;
	bh=tTSH8rvrUUA51JY+CpDHGNd0ZDu0wR7aQkZzi0oHlPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TR+eGbndtzEjGREHelPu0G3u3l1pDYbXEGWcoSQvBm2wZ6N+250U2dETn9CB3SPtT
	 EFnesYAnd2YXK0ycdu4ICNZZE4DXxGXge+Bw3MEcxO9XeWaHSpklZX21hJ3lHQ0THP
	 xsSyr5BupLWh9WGB9Wvha0VyHpG4BuUIkdhl2YKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/91] bpf: Reject bpf_timer for PREEMPT_RT
Date: Tue, 30 Sep 2025 16:47:32 +0200
Message-ID: <20250930143822.526166893@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit e25ddfb388c8b7e5f20e3bf38d627fb485003781 ]

When enable CONFIG_PREEMPT_RT, the kernel will warn when run timer
selftests by './test_progs -t timer':

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48

In order to avoid such warning, reject bpf_timer in verifier when
PREEMPT_RT is enabled.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20250910125740.52172-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7d6ee41f4b4f4..a6f825b7fbe6c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7546,6 +7546,10 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 		verbose(env, "verifier bug. Two map pointers in a timer helper\n");
 		return -EFAULT;
 	}
+	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		verbose(env, "bpf_timer cannot be used for PREEMPT_RT.\n");
+		return -EOPNOTSUPP;
+	}
 	meta->map_uid = reg->map_uid;
 	meta->map_ptr = map;
 	return 0;
-- 
2.51.0



