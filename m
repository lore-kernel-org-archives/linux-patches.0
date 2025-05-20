Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7EA2441B4;
	Tue, 20 May 2025 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749588; cv=none; b=Ww9dD9pPms8SZUC/bhoZj7FPtjEBNtf3NLv2OtksROaATmzkq0XF7glWF3ztSa+Jv9wYgojNH7ntuizsLGpBWsbP+WfsB98IzU9G0dOnZhEGGyRqLCToT80fHyIK/cUB1fkVtAJqq32ziTHZ0ySnwbqaHLTmJOBFsb1mJ+cICYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749588; c=relaxed/simple;
	bh=plMkdfk/juW0iDxRF0R6w+EjwUkdNZtmwGAUAtcwb1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sshTfglxyIeUNPA9TxMUMTl9mAJMXPnudqSS35ULZhEXxCQgGZQz80eJIrVnZWIvdB7AO+dzvZnSQEsvuwANGxqU7RdsEmQF9tVIGGgmhg48+2Ck+TmfPMuysL8YbRF/y+VPvCJYqeTfqXwM3lM/CE286PWqM386O8V/f5UE4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5ATylkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5ATylkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D191DC4CEE9;
	Tue, 20 May 2025 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749588;
	bh=plMkdfk/juW0iDxRF0R6w+EjwUkdNZtmwGAUAtcwb1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5ATylknuIwnMFopwt/nysKQyOCTXMURfNbhWXGp3aXl7MEw0nvhYOPwb86sfZoH0
	 CCJOhAfRpV9GyiKhoBlBAnHiqOb2t+IRwzFq9bcRid7wLVkEfMFuIn6LALAkgiUwrc
	 y6D65UFxuxEIWiZ/mUu3ZP8gZ9a8CSBK2Q0GcMtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zhaoyang Li <lizy04@hust.edu.cn>
Subject: [PATCH 6.1 91/97] arm64/sme: Always exit sme_alloc() early with existing storage
Date: Tue, 20 May 2025 15:50:56 +0200
Message-ID: <20250520125804.229184689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit dc7eb8755797ed41a0d1b5c0c39df3c8f401b3d9 upstream.

When sme_alloc() is called with existing storage and we are not flushing we
will always allocate new storage, both leaking the existing storage and
corrupting the state. Fix this by separating the checks for flushing and
for existing storage as we do for SVE.

Callers that reallocate (eg, due to changing the vector length) should
call sme_free() themselves.

Fixes: 5d0a8d2fba50 ("arm64/ptrace: Ensure that SME is set up for target when writing SSVE state")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240115-arm64-sme-flush-v1-1-7472bd3459b7@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Zhaoyang Li <lizy04@hust.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1259,8 +1259,10 @@ void fpsimd_release_task(struct task_str
  */
 void sme_alloc(struct task_struct *task, bool flush)
 {
-	if (task->thread.za_state && flush) {
-		memset(task->thread.za_state, 0, za_state_size(task));
+	if (task->thread.za_state) {
+		if (flush)
+			memset(task->thread.za_state, 0,
+			       za_state_size(task));
 		return;
 	}
 


