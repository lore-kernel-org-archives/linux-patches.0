Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E793C244665;
	Tue, 30 Sep 2025 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246153; cv=none; b=BTpoPw88sDi5P6K7HLreG7/FpkSvR79maPzZAM6aeXFs3LS1TxzKMdkA0lKVBf+wsX5H3mbf0mh9Mgj/JjoT8AMiWmqj5rUdi0BEyPbkDFCwCIRoE5ieOsiADcQkotV9ARsmTMu6qHL0QTrNFHZPS9c61UmU+0Sl8+rZkhFY3UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246153; c=relaxed/simple;
	bh=6rRD3/bP41ILDxcV3CnZqgrQNgQqep+HHYQGPBTYm0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfVpcOrzLfF+XP7aoqG8EZHE8ghj0HYumeNRbdufMvowRiWT2+cdW57Rpey96tGMA4XWKVVyAKoRXPbApGEjEk9Ff/JT9CzmhRZ3atrtMZms297HSmfGDt6rzLGqR+A/ZioTF1vpeC2ZGlSuDaVVbjPng3xH7nLyO42+oPVbkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxiadkz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxiadkz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726EFC4CEF0;
	Tue, 30 Sep 2025 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246152;
	bh=6rRD3/bP41ILDxcV3CnZqgrQNgQqep+HHYQGPBTYm0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxiadkz30Pe+g97UaWjwAgfWdwEb8jThSPPXGUF+KBJlBbXmvjFW8n/G8ZNHA8ZMv
	 IG81RfDQ3RRdubPrpHZoTzxKz7HWdF4xisTLSbl+i6V8AA0dlHS8iulqkFVUIazDLm
	 N4cD7r7/weQKYhBTFFYUUVSBnQUiB1Sc1Tb3KWZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 38/89] bpf: Reject bpf_timer for PREEMPT_RT
Date: Tue, 30 Sep 2025 16:47:52 +0200
Message-ID: <20250930143823.500330298@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e22abf3326b6..1829f62a74a9e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7799,6 +7799,10 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
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



