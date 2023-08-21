Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2FC11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5143C433C7;
	Mon, 21 Aug 2023 19:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647906;
	bh=JONYzCju5HF1dHnhi/xWb3GxlTVU8+izOlGDbgqplXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1/2c4px2t1MNOsm5WvEjpOI+0bDjTb0iUFltLPXKAXBZoHEcJUTGUXYAJovnOYAj
	 D2mvTb9XvruFl3Z/marI7tloitotALuXTsnmdXezMa3DF1hxT1EvfSoVI2XDNcS+NU
	 TfFpYhfTO6ZhB8Qs8xoOjzPGUAET7zI+ZwMPnUn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 180/194] x86/srso: Explain the untraining sequences a bit more
Date: Mon, 21 Aug 2023 21:42:39 +0200
Message-ID: <20230821194130.637136055@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 9dbd23e42ff0b10c9b02c9e649c76e5228241a8e upstream.

The goal is to eventually have a proper documentation about all this.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814164447.GFZNpZ/64H4lENIe94@fat_crate.local
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -130,6 +130,25 @@ SYM_CODE_START(srso_alias_return_thunk)
 SYM_CODE_END(srso_alias_return_thunk)
 
 /*
+ * Some generic notes on the untraining sequences:
+ *
+ * They are interchangeable when it comes to flushing potentially wrong
+ * RET predictions from the BTB.
+ *
+ * The SRSO Zen1/2 (MOVABS) untraining sequence is longer than the
+ * Retbleed sequence because the return sequence done there
+ * (srso_safe_ret()) is longer and the return sequence must fully nest
+ * (end before) the untraining sequence. Therefore, the untraining
+ * sequence must fully overlap the return sequence.
+ *
+ * Regarding alignment - the instructions which need to be untrained,
+ * must all start at a cacheline boundary for Zen1/2 generations. That
+ * is, instruction sequences starting at srso_safe_ret() and
+ * the respective instruction sequences at retbleed_return_thunk()
+ * must start at a cacheline boundary.
+ */
+
+/*
  * Safety details here pertain to the AMD Zen{1,2} microarchitecture:
  * 1) The RET at retbleed_return_thunk must be on a 64 byte boundary, for
  *    alignment within the BTB.


