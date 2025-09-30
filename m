Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571031F152D;
	Tue, 30 Sep 2025 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244703; cv=none; b=q0ZXj/EIOks0tF+5dDoFPLK2evlXFf+hqdv+G2iVo3W+PLKi41rUujcFZi1cYskKPeVyXb9iMtSRaZJBmi1vrU3e0QgW3HAtGeFz2wr0og3l+0Wa57Tm5c18caOlLaVp8ga0ReqYWBxJcuFEkyD9uW21crn6UuWNVdq7RKwdu8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244703; c=relaxed/simple;
	bh=37Ckxul7RxvkAfXODyohsqgzIdtW7OuFeSfKa3aWCqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuwZfjAErXTPrCsOiu6xBR4beb8roPA2JYPQ0xDYOcgFIpg/ECJ0hl8+aHOwtjy5i3x2f8PXWDZG7pzmCoQ4Smqiko9pR3vZl6fED62MQ4Dw7zTQYfBhrsnAiN3kWnGy2J/znHO86uII/CMPLO+Frm/yR10+KGXKNu3QcBieiG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftX1vbfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftX1vbfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F2DC4CEF0;
	Tue, 30 Sep 2025 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244702;
	bh=37Ckxul7RxvkAfXODyohsqgzIdtW7OuFeSfKa3aWCqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftX1vbfBe0iljMf/cQchGkYbDhHE4HWk+0L7JR+FYwjJQeAevkc0yRun0PuzIpXmu
	 GYbnvn4Sh0Yow1R36uzGTkltwbde26ghj0+0+y0HkenX0pDs6kk0MIyAwUAR8s82fD
	 LFbLbcLyrUhm2IW0+BSKoSIhiAwUELXwHX0AjSzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 056/143] bpf: Reject bpf_timer for PREEMPT_RT
Date: Tue, 30 Sep 2025 16:46:20 +0200
Message-ID: <20250930143833.464975049@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d6782efd25734..a6338936085ae 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8405,6 +8405,10 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 		verifier_bug(env, "Two map pointers in a timer helper");
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



