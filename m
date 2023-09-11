Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E83A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867A3C433C8;
	Mon, 11 Sep 2023 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444416;
	bh=2EfkddGdZh5KwATzfyIBvJzRdaVt9a9KKDidRGZVxzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kfim+BUR8NBSE6+Mmh28us/3TuWojkFA7+Et/n4ya63cVEYsG1bigPooIVTpkC453
	 L7daCOoyZWUvTBUg3QJgEk9/0dtmcjxOc7d1VV5IwOva5Ouy8PZAUd6PO6eMEA36AS
	 BzueIeB5zn5nDEpFPQnX1TQ1zKrp+SUMcQ2cVw6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.4 722/737] x86/build: Fix linker fill bytes quirk/incompatibility for ld.lld
Date: Mon, 11 Sep 2023 15:49:41 +0200
Message-ID: <20230911134710.681147959@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

commit 65e710899fd19f435f40268f3a92dfaa11f14470 upstream.

With ":text =0xcccc", ld.lld fills unused text area with 0xcccc0000.
Example objdump -D output:

	ffffffff82b04203:       00 00                   add    %al,(%rax)
	ffffffff82b04205:       cc                      int3
	ffffffff82b04206:       cc                      int3
	ffffffff82b04207:       00 00                   add    %al,(%rax)
	ffffffff82b04209:       cc                      int3
	ffffffff82b0420a:       cc                      int3

Replace it with ":text =0xcccccccc", so we get the following instead:

	ffffffff82b04203:       cc                      int3
	ffffffff82b04204:       cc                      int3
	ffffffff82b04205:       cc                      int3
	ffffffff82b04206:       cc                      int3
	ffffffff82b04207:       cc                      int3
	ffffffff82b04208:       cc                      int3

gcc/ld doesn't seem to have the same issue. The generated code stays the
same for gcc/ld.

Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Fixes: 7705dc855797 ("x86/vmlinux: Use INT3 instead of NOP for linker fill bytes")
Link: https://lore.kernel.org/r/20230906175215.2236033-1-song@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -156,7 +156,7 @@ SECTIONS
 		ALIGN_ENTRY_TEXT_END
 		*(.gnu.warning)
 
-	} :text =0xcccc
+	} :text = 0xcccccccc
 
 	/* End of text section, which should occupy whole number of pages */
 	_etext = .;


