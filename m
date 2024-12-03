Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E71F940B;
	Tue,  3 Dec 2024 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239891; cv=none; b=r4TUpZyDtFvcwfvjR6o3l24vhE8BcMjF1JeZsCse8UCeBKDsBPnFrnJH3mTA7qmexv5QbKVzqTy3/KVAmA2X/2J7vQFgAkEflluwHzZ1xUxmsU6WwGgz/dU5pf6gGaatwmusgvhKUMJ9PHWNcAlY7aZ+7wXRjkmdp+Czt0q+usI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239891; c=relaxed/simple;
	bh=HSiOOEA2cgAmeeH/1yOzgMG8k0WLQj7ehZWKL3qYies=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOKKMDOEde1YPUUtf0M6pEhgQMSgDrpXearvpuf0Y8E1UbVmjt4xyTqEkEMj8h8ExfUdJZ0ac4bfD/9Sq1PlHdhUAKk+XkQ/xSUCBBeikQfcx20A2nc/II5eXlZ44iOWUm2/liBM51sxAeoWDVGZbctzVw6CZq+Uux3evT96+C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duT3qn+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duT3qn+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9049C4CECF;
	Tue,  3 Dec 2024 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239891;
	bh=HSiOOEA2cgAmeeH/1yOzgMG8k0WLQj7ehZWKL3qYies=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duT3qn+6eCH/2aUA5Qm5rFpGwcmXAyj+ADyL2s7kw87Fo1QfG8Y3SVQPSI3LFsjpH
	 wPJkQxHwkYCj5kewV862qxFn7W9LzKEr9anUN2IrtbDeVyuAj9zCR7hTegHiLu3HhA
	 yhYvnLzvkHS6J/ClJT3MnGzfJpcyercLRW/6MiwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 769/817] um: Always dump trace for specified task in show_stack
Date: Tue,  3 Dec 2024 15:45:41 +0100
Message-ID: <20241203144026.030594183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 0f659ff362eac69777c4c191b7e5ccb19d76c67d ]

Currently, show_stack() always dumps the trace of the current task.
However, it should dump the trace of the specified task if one is
provided. Otherwise, things like running "echo t > sysrq-trigger"
won't work as expected.

Fixes: 970e51feaddb ("um: Add support for CONFIG_STACKTRACE")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241106103933.1132365-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 746715379f12a..7e897e44a03da 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -53,5 +53,5 @@ void show_stack(struct task_struct *task, unsigned long *stack,
 	}
 
 	printk("%sCall Trace:\n", loglvl);
-	dump_trace(current, &stackops, (void *)loglvl);
+	dump_trace(task ?: current, &stackops, (void *)loglvl);
 }
-- 
2.43.0



