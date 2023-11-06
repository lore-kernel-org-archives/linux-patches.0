Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00575208CA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNACBt6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD04C433C8;
	Mon,  6 Nov 2023 13:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277147;
	bh=1Xhr71Usd8A9Ft6F4XsSQsoUD5gGInBFZyZDOsS4Q1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNACBt6UGtHKGtpvbnbGYNDNolvKEDmB2n1iaDQP72niQWoLvtR4Dp969bp23Yq+g
	 0oMn12+QxL3D1ev9+ZetE3md6reTN5uIEXZCTQQl3/u/kmfl6DuXWXmq35HBd/Ngkj
	 Ra5TEaKYgsrvDWMyIWMLIG0548HEDd91LlJUTfCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 054/128] sparc32: fix a braino in fault handling in csum_and_copy_..._user()
Date: Mon,  6 Nov 2023 14:03:34 +0100
Message-ID: <20231106130311.564857204@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1f36cd05e0081f2c75769a551d584c4ffb2a5660 upstream.

Fault handler used to make non-trivial calls, so it needed
to set a stack frame up.  Used to be
	save ... - grab a stack frame, old %o... become %i...
	....
	ret	- go back to address originally in %o7, currently %i7
	 restore - switch to previous stack frame, in delay slot
Non-trivial calls had been gone since ab5e8b331244 and that code should
have become
	retl	- go back to address in %o7
	 clr %o0 - have return value set to 0
What it had become instead was
	ret	- go back to address in %i7 - return address of *caller*
	 clr %o0 - have return value set to 0
which is not good, to put it mildly - we forcibly return 0 from
csum_and_copy_{from,to}_iter() (which is what the call of that
thing had been inlined into) and do that without dropping the
stack frame of said csum_and_copy_..._iter().  Confuses the
hell out of the caller of csum_and_copy_..._iter(), obviously...

Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Fixes: ab5e8b331244 "sparc32: propagate the calling conventions change down to __csum_partial_copy_sparc_generic()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/lib/checksum_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/lib/checksum_32.S
+++ b/arch/sparc/lib/checksum_32.S
@@ -453,5 +453,5 @@ ccslow:	cmp	%g1, 0
  * we only bother with faults on loads... */
 
 cc_fault:
-	ret
+	retl
 	 clr	%o0


