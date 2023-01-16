Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B5F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1BAC433EF;
	Mon, 16 Jan 2023 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888347;
	bh=W7u8GZa7OfTlYAGo0SatZ9b/KYQBk1H6c/gk+ULVFrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRfSDL82aRjvbwJuIJxSEZ3DFtkJPhGQMb8EKFIFwuzhuD2KLAIuJdhJuMB7/UPla
	 k16xmML4vqMMkvrF6hlX6TBpEgQZFIi2BqOgxh5yEhykLrvQ/3M6my4gMznlUq0ORr
	 2E3i2TmUubHgNBjL7UVL2SvsoBT2fyQJB1m4NIiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Branco <bsdaemon@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 454/521] x86/bugs: Flush IBP in ib_prctl_set()
Date: Mon, 16 Jan 2023 16:51:56 +0100
Message-Id: <20230116154907.420353861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Branco <bsdaemon@google.com>

commit a664ec9158eeddd75121d39c9a0758016097fa96 upstream.

We missed the window between the TIF flag update and the next reschedule.

Signed-off-by: Rodrigo Branco <bsdaemon@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1778,6 +1778,8 @@ static int ib_prctl_set(struct task_stru
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
+		if (task == current)
+			indirect_branch_prediction_barrier();
 		break;
 	default:
 		return -ERANGE;


