Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1399C4C8A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D1C433C7;
	Mon, 11 Sep 2023 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443692;
	bh=qIu6qL9EVLWUwvT3qxCZucj0qfKtOHli99P4UIdJthE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtvMYzStZsLe0C1cQyOjZGuITfvlwepGkcoJLf3P0Cp7OE2zDV5qcMJrfddVTYzoA
	 XxO6tF8PWlQhuuMT9kPoNJs3vn7jz126BdCvNMivqkaQ4XH8D8ISRe/RNNIVgCxzBE
	 5sNNkb14lJ4L2olSg4R1pMhd6XVR6dxhfjuHaj/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 468/737] powerpc/pseries: Fix hcall tracepoints with JUMP_LABEL=n
Date: Mon, 11 Sep 2023 15:45:27 +0200
Message-ID: <20230911134703.663115035@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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



