Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CD122EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQ2cSH81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BFDC433C9;
	Mon,  6 Nov 2023 13:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277272;
	bh=smHaHhu46AnZJLQ/igQDKc/CZwYO0DGMPlIFNYr62s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQ2cSH810XpyrY9am0Nvp7/w1FbcsHyWngHa8QA5kjhONatb2lHMl3c88X5kTFIXX
	 5LUlHU98bjqbwYUDuLXt4H/jnueFLo6a0U64dfjbtvH/2ix3//OCjh6xAEKFA16Lvg
	 CeMkJ9h+/Um+Hho4ovE+YzopZNHL3bFVWAhSnH9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>
Subject: [PATCH 5.15 067/128] objtool/x86: add missing embedded_insn check
Date: Mon,  6 Nov 2023 14:03:47 +0100
Message-ID: <20231106130312.152968628@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Sperbeck <jsperbeck@google.com>

When dbf460087755 ("objtool/x86: Fixup frame-pointer vs rethunk")
was backported to some stable branches, the check for dest->embedded_insn
in is_special_call() was missed.  The result is that the warning it
was intended to suppress still appears.  For example on 6.1 (on kernels
before 6.1, the '-s' argument would instead be 'check'):

$ tools/objtool/objtool -s arch/x86/lib/retpoline.o
arch/x86/lib/retpoline.o: warning: objtool: srso_untrain_ret+0xd:
    call without frame pointer save/setup

With this patch, the warning is correctly suppressed, and the
kernel still passes the normal Google kernel developer tests.

Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2202,7 +2202,7 @@ static bool is_special_call(struct instr
 		if (!dest)
 			return false;
 
-		if (dest->fentry)
+		if (dest->fentry || dest->embedded_insn)
 			return true;
 	}
 


