Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDB24369A;
	Wed, 25 Feb 2026 01:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982877; cv=none; b=YcBAd687C+fkpDEO9wfta+2LSoboWd9cNqcx3EXman0X0iZ6nYOkGg4KRAUSP/IMCowcQDv0KLM5J/4biscOZBctcGQYfydlAw+eEs6oMes+sfmqqVQUaE7HyZufWqfNeGcenKjXgl6RQ4ONOGdZ6KzeooDIhTLMHRATKJOC9Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982877; c=relaxed/simple;
	bh=CrK5Q5GpE2RS9L6snqFa+NOaS9qpo2g0EiVmBIXZZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBIBiagH/Q4UD/76arEhi9Ru/vH0qxEur2Z9MC9r6NufgkmIx845r9G+gzerMT0pkrlXPdy4uRIoKU7PR6GeQOi5HwFHsLzroR1HBOZuzlnkbnZKzEu4KKNCSwUiBzFrvLn5oQ3vtTPq5LE/evxwq4lequSqahY90Ifbay5GMhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQB24+um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQB24+um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF8C116D0;
	Wed, 25 Feb 2026 01:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982877;
	bh=CrK5Q5GpE2RS9L6snqFa+NOaS9qpo2g0EiVmBIXZZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQB24+umQxJxUFGlBMFIQjcBsnZa8NRnktEHOyqWUSss3meJt3QqGDawgBjl4Zbat
	 nmdSqQECrVGSqn9NXJ0V+ERm6x+bkd8xRwg3A0q5KBQP12P11H7GFwZbt5V+9sp5Y9
	 kdBi9UBL1qOk5JcMt8Mp4ReLF9247CbeY1BABXpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 061/781] arm64/gcs: Fix error handling in arch_set_shadow_stack_status()
Date: Tue, 24 Feb 2026 17:12:50 -0800
Message-ID: <20260225012401.202458583@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 53c998527ffa60f9deda8974a11ad39790684159 ]

alloc_gcs() returns an error-encoded pointer on failure, which comes
from do_mmap(), not NULL.

The current NULL check fails to detect errors, which could lead to using
an invalid GCS address.

Use IS_ERR_VALUE() to properly detect errors, consistent with the
check in gcs_alloc_thread_stack().

Fixes: b57180c75c7e ("arm64/gcs: Implement shadow stack prctl() interface")
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/gcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/gcs.c b/arch/arm64/mm/gcs.c
index 6e93f78de79b1..04a23a497f205 100644
--- a/arch/arm64/mm/gcs.c
+++ b/arch/arm64/mm/gcs.c
@@ -199,8 +199,8 @@ int arch_set_shadow_stack_status(struct task_struct *task, unsigned long arg)
 
 		size = gcs_size(0);
 		gcs = alloc_gcs(0, size);
-		if (!gcs)
-			return -ENOMEM;
+		if (IS_ERR_VALUE(gcs))
+			return gcs;
 
 		task->thread.gcspr_el0 = gcs + size - sizeof(u64);
 		task->thread.gcs_base = gcs;
-- 
2.51.0



