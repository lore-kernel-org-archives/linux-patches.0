Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E9417F3
	for <patches@lists.linux.dev>; Mon, 31 Oct 2022 07:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328F4C433C1;
	Mon, 31 Oct 2022 07:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667199776;
	bh=CG15RPxJvIgf2CezWd4+WIB7U582wLLfRESJnyswIHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIi04GmSZyUfLaa1LAcq79cVKbqUrWWaYt66/RIRhpHWB/aw3a0zuD0EGP5t3krIE
	 Oxc6CorXNoivaXfVoWE1Pss6jaoSPoxwsLSXZYYNEuK0ZkkTeMX4JBxtF+u/0v9H+e
	 ax8uHGJTGJj2qmd5d8NuGSSl1TfzPKzH8ActkhJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 19/34] x86/speculation: Add LFENCE to RSB fill sequence
Date: Mon, 31 Oct 2022 08:02:52 +0100
Message-Id: <20221031070140.564831853@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit ba6e31af2be96c4d0536f2152ed6f7b6c11bca47 upstream.

RSB fill sequence does not have any protection for miss-prediction of
conditional branch at the end of the sequence. CPU can speculatively
execute code immediately after the sequence, while RSB filling hasn't
completed yet.

  #define __FILL_RETURN_BUFFER(reg, nr, sp)       \
          mov     $(nr/2), reg;                   \
  771:                                            \
          ANNOTATE_INTRA_FUNCTION_CALL;           \
          call    772f;                           \
  773:    /* speculation trap */                  \
          UNWIND_HINT_EMPTY;                      \
          pause;                                  \
          lfence;                                 \
          jmp     773b;                           \
  772:                                            \
          ANNOTATE_INTRA_FUNCTION_CALL;           \
          call    774f;                           \
  775:    /* speculation trap */                  \
          UNWIND_HINT_EMPTY;                      \
          pause;                                  \
          lfence;                                 \
          jmp     775b;                           \
  774:                                            \
          add     $(BITS_PER_LONG/8) * 2, sp;     \
          dec     reg;                            \
          jnz     771b;        <----- CPU can miss-predict here.

Before RSB is filled, RETs that come in program order after this macro
can be executed speculatively, making them vulnerable to RSB-based
attacks.

Mitigate it by adding an LFENCE after the conditional branch to prevent
speculation while RSB is being filled.

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -54,7 +54,9 @@
 774:						\
 	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
-	jnz	771b;
+	jnz	771b;				\
+	/* barrier for jnz misprediction */	\
+	lfence;
 
 #ifdef __ASSEMBLY__
 


