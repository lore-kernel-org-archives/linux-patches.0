Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB281170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E45C433C8;
	Mon, 11 Sep 2023 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441595;
	bh=AbwiWjaYMsJfe0YQua/ztPzpdSU4H0GAbpUqpa21mlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFt+nnJE6XwT8FuSm8XY/VjKfNEPkCB/qv7jjHTZz+aUS5GbouaiiELPstTj2Srwq
	 DZRQoyvqw+lCEF+ebnsmqZ1RfBS0Mzyj7Ky/pno/fEqXYtDXCimkmRflKXK7RbUT4O
	 zbyz/u1+XXXVfS8UFZaKrbLQN/ASFQFcbJQKbocM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 437/739] powerpc/pseries: Fix hcall tracepoints with JUMP_LABEL=n
Date: Mon, 11 Sep 2023 15:43:56 +0200
Message-ID: <20230911134703.376877620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 750bd41aeaeb1f0e0128aa4f8fcd6dd759713641 ]

With JUMP_LABEL=n, hcall_tracepoint_refcount's address is being tested
instead of its value. This results in the tracing slowpath always being
taken unnecessarily.

Fixes: 9a10ccb29c0a2 ("powerpc/pseries: move hcall_tracepoint_refcount out of .toc")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230509091600.70994-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hvCall.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index 35254ac7af5ee..ca0674b0b683e 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -91,6 +91,7 @@ BEGIN_FTR_SECTION;						\
 	b	1f;						\
 END_FTR_SECTION(0, 1);						\
 	LOAD_REG_ADDR(r12, hcall_tracepoint_refcount) ;		\
+	ld	r12,0(r12);					\
 	std	r12,32(r1);					\
 	cmpdi	r12,0;						\
 	bne-	LABEL;						\
-- 
2.40.1



