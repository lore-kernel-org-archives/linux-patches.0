Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A3E1DDCE;
	Tue, 16 Jul 2024 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145481; cv=none; b=Zd2fhiv0IboCz9EaiyoDkwDalQoZupa1hc9I9pKWZ0nepuLI7cwkXAmAlwjTAHZQssoPyy3YMdG7lA+I27lc41M3y44UkGuR2c/eDwhRDYrd3MUTldTEAfbqetNBDEi4Gr/JklTPYHtkplqVKdOS3TJyzR4gTgNgHbkCJwasjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145481; c=relaxed/simple;
	bh=vCbBIQkak/y9tfc1DFRgQXTW9ppXbM3Vq4FjU9fcaFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyopN2VCtFh0I/rTxqhSdAGpV9o6iDhry2qWRRyZf/YCTHQZASvZIdvrdnpuTedSIYP/jv1GHMgYKn5wuhhm8Zt7VA15ryBQj1F0tbPY99X9Kxn5NPc3VxIbrq+/Fb4X43Ih9hwxv9OY78BQX9EXqsJLzL5wMsyBmmlDwD8ajU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXKYzgD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXKYzgD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2E0C116B1;
	Tue, 16 Jul 2024 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145481;
	bh=vCbBIQkak/y9tfc1DFRgQXTW9ppXbM3Vq4FjU9fcaFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXKYzgD0WqtHTePT40vRzNDIJGPQhjIMysT8RepW0Cqei87teJtHbRWLiDtsf2Abw
	 Ucd8njewh71AUF7oMuTzkhRxrZCSqcmyD/DXiWHzdBAF1fNEEGMIyf28IGW14VrQTL
	 GR1KwlvU28TOTUJAIBbNWmmuM9jjNz4NySvp6Gx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Jim Mattson <jmattson@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 80/96] x86/retpoline: Move a NOENDBR annotation to the SRSO dummy return thunk
Date: Tue, 16 Jul 2024 17:32:31 +0200
Message-ID: <20240716152749.589880661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

The linux-6.1-y backport of commit b377c66ae350 ("x86/retpoline: Add
NOENDBR annotation to the SRSO dummy return thunk") misplaced the new
NOENDBR annotation, repeating the annotation on __x86_return_thunk,
rather than adding the annotation to the !CONFIG_CPU_SRSO version of
srso_alias_untrain_ret, as intended.

Move the annotation to the right place.

Fixes: b377c66ae350 ("x86/retpoline: Add NOENDBR annotation to the SRSO dummy return thunk")
Reported-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -107,6 +107,7 @@ __EXPORT_THUNK(srso_alias_untrain_ret)
 /* dummy definition for alternatives */
 SYM_START(srso_alias_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
 	ANNOTATE_UNRET_SAFE
+	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_FUNC_END(srso_alias_untrain_ret)
@@ -261,7 +262,6 @@ SYM_CODE_START(__x86_return_thunk)
 	UNWIND_HINT_FUNC
 	ANNOTATE_NOENDBR
 	ANNOTATE_UNRET_SAFE
-	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_CODE_END(__x86_return_thunk)


