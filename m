Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8EC2F6167;
	Tue, 30 Sep 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245268; cv=none; b=nmUH+9qkQHulp2MlCG/P5+Lv873evTkZvroUZvwocizGKPpDvQLbj+H79Rtm1TGpHSKHmlvpDt0lIX7ULFYPBeIxbPrQyUJN3cLLpgUNOFLyD+xMqmtjkCSphbogXWy3VpKzjKc5fKeWDeNU5IBvWV8ZGcnoMjcYtH9D2/1ADSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245268; c=relaxed/simple;
	bh=a456hYY0xl7NYpwZNS5UMyHykqmZlK8FW9XHD0Tk3nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKMLbUB6Wl9zwzAuzrAOaUNS/vQe9OF+zT3CWgsj3Wfqh1xVjqkY7FQosyntxQqihgVGGKdqsqqj5Wy78U8d1LI6hhgutss/IZY6DLnLAth2mq5FnZt4Oq95aPmXqvdikVFk6/xE1QMxo2grYCqosuq3Hq66uHRrSj6LSszkh9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsSc+RbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsSc+RbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB81FC4CEF0;
	Tue, 30 Sep 2025 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245268;
	bh=a456hYY0xl7NYpwZNS5UMyHykqmZlK8FW9XHD0Tk3nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsSc+RbKlOpH9BFVf+JB0/4bNKOJqY8eJ3iomlJnwzZVKSiE5eWnUs+SbDkuYka59
	 Qm+Qr6zzVnp5V2/zCa6sRPSootP564yIu51o2bGWsShERfJ2TRuvB3zauC3MMujOzV
	 TCXrPzStN+5wJM6J231GVhm+XcCIP55OaTQfjsNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/151] bpf: Reject bpf_timer for PREEMPT_RT
Date: Tue, 30 Sep 2025 16:47:26 +0200
Message-ID: <20250930143832.228868098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 89b4fa815a9ba..4b7c9a60a7352 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5071,6 +5071,10 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
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



