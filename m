Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA30013AEF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0fL80hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BDCC433C9;
	Tue, 31 Oct 2023 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771966;
	bh=jsX/ObPlGrK2V2Ky/Csh5rxWI4UPZcCvmtkp/A5uoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0fL80hDqA2jfprATYvGD4SA6w2cyWtCQopJJbxQfQysJ2LBzFzNLt+EARWKBGlEW
	 DztrdDxHm5Msr+XJIb7y8EqZz5wDZwKLhbnw7EH2aOnkIXrDHqmAkKXffukL/D82NZ
	 Y4CaPL8M+jzV+HXpVHyOmKL9QCkthA/9a7b2+Ivw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 80/86] sparc32: fix a braino in fault handling in csum_and_copy_..._user()
Date: Tue, 31 Oct 2023 18:01:45 +0100
Message-ID: <20231031165921.025716451@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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


