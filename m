Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403C71E48E;
	Thu, 11 Apr 2024 10:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832694; cv=none; b=HYycH5qe9oBgkuMC5k4YC3NxacRdeFnXPmmwFLWlPq43R/hUmLjsg0V4xOZ2opPux92JkBp6RSiKee51VKSNdmf+CDo/t0VlWGaWHl4kSYxFaeg2rOSHe6Agysbnh7WCMxnMelMx6PITRSTwxVM5v3DPrqXdsEpnYDq5Dd9wtck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832694; c=relaxed/simple;
	bh=Czje+nnm0/9EL5mP7VONYf7Jis1PpvIaDcJDu4Wv/Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUHPwdwkt3p83PaJr2uP6UsbgJe8U9xgIyf0la1v6P8ieUma4/KHfEj9tQtSfb1XYzViohBq4oDAmAvp+IZaU4E2FKVO92bbrwMaNWS1F6QDZWF3kDXTglqDJY7bML2+LsWQPLlMRtVFeC6oMSw8aCYJZfV7ezdhu3tM0+yfH5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnZikeUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnZikeUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2EFC433C7;
	Thu, 11 Apr 2024 10:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832694;
	bh=Czje+nnm0/9EL5mP7VONYf7Jis1PpvIaDcJDu4Wv/Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnZikeUvABRQMx03WZuRZLitxltqN48zBGa6q9TpdMD5BLdjilBNlNE3TZVWFbImv
	 CA/SeAufHzlEuZt6XAWX0o1050fqo+DfN+nkspvKdYSrqQVe8luC3InMBd3PmAECsG
	 /j1rA8qyQKkAbNxRkjEUZ7VbaRv1vVaIaKRr7cCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Popov <alex.popov@linux.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 50/57] gcc-plugins/stackleak: Ignore .noinstr.text and .entry.text
Date: Thu, 11 Apr 2024 11:57:58 +0200
Message-ID: <20240411095409.503845298@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit ae978009fc013e3166c9f523f8b17e41a3c0286e upstream.

The .noinstr.text section functions may not have "current()" sanely
available. Similarly true for .entry.text, though such a check is
currently redundant. Add a check for both. In an x86_64 defconfig build,
the following functions no longer receive stackleak instrumentation:

	__do_fast_syscall_32()
	do_int80_syscall_32()
	do_machine_check()
	do_syscall_64()
	exc_general_protection()
	fixup_bad_iret()

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/stackleak_plugin.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -463,6 +463,10 @@ static bool stackleak_gate(void)
 			return false;
 		if (STRING_EQUAL(section, ".meminit.text"))
 			return false;
+		if (STRING_EQUAL(section, ".noinstr.text"))
+			return false;
+		if (STRING_EQUAL(section, ".entry.text"))
+			return false;
 	}
 
 	return track_frame_size >= 0;


