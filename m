Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A98319ADAD;
	Tue, 16 Jul 2024 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144757; cv=none; b=o3WU1h8Mdbaq8M7oJXeErjVjcetF1Dd2ejWK2TgKLyE2WFFUo8bFTXEYEogPtu5lvms1OkeF/FdWhOwm9hnB3u1IxOLzbokFA96VgBEU269/MOpArylC+rQNs7tsKtslCvHBw2DyV0FzcUTPF5XVXwOecduvTnjJdd3U6TLsa9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144757; c=relaxed/simple;
	bh=HH9TFpHhfi0msQj/aHnAzzqx71XyB7h0z4R49oqsaVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUotKD49GcxBrWCqcrk9IDvYUY1YiWFkAc1pA0TNm2om2RnRzxEcZ5QzL+UqZBP6IZrdXrWmSM4zozeelrrlOGtkZwqA72eGnCtN8AnQ0Hd6VT8ix2Snugm77kiriUwNWdHNfJJZm1/6IerOKkheWnh4x7c39dmfJWpGhrYveUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdZTjNH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdZTjNH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1EDC116B1;
	Tue, 16 Jul 2024 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144757;
	bh=HH9TFpHhfi0msQj/aHnAzzqx71XyB7h0z4R49oqsaVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdZTjNH9o8tNOA8TxqYo3T4exg6/fsqxDkPjF6+qdffjkwu/6DPYjyafLYCMaTaRC
	 1vViLrmv81mgpsrwOnZWbl7ecAz4wVi0gGR8uV4vArWocfEvLDEwz0XPFdx6eYdi30
	 c3p1B/BdZEFckev55Xl60QS3NMKewhCTxS753q7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Jim Mattson <jmattson@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 094/108] x86/retpoline: Move a NOENDBR annotation to the SRSO dummy return thunk
Date: Tue, 16 Jul 2024 17:31:49 +0200
Message-ID: <20240716152749.599032663@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

The linux-5.10-y backport of commit b377c66ae350 ("x86/retpoline: Add
NOENDBR annotation to the SRSO dummy return thunk") misplaced the new
NOENDBR annotation, repeating the annotation on __x86_return_thunk,
rather than adding the annotation to the !CONFIG_CPU_SRSO version of
srso_alias_untrain_ret, as intended.

Move the annotation to the right place.

Fixes: 0bdc64e9e716 ("x86/retpoline: Add NOENDBR annotation to the SRSO dummy return thunk")
Reported-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -105,6 +105,7 @@ __EXPORT_THUNK(srso_alias_untrain_ret)
 /* dummy definition for alternatives */
 SYM_START(srso_alias_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
 	ANNOTATE_UNRET_SAFE
+	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_FUNC_END(srso_alias_untrain_ret)
@@ -258,7 +259,6 @@ SYM_CODE_START(__x86_return_thunk)
 	UNWIND_HINT_FUNC
 	ANNOTATE_NOENDBR
 	ANNOTATE_UNRET_SAFE
-	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_CODE_END(__x86_return_thunk)


