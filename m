Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D66230BC2;
	Mon, 23 Jun 2025 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685354; cv=none; b=ERbAJJkYbrfSsYRbNCiTmNps20VFDDQbGsXwRLyEQA6BNkYBKjZ1gFnRqvBLufiWFgJ9SDVYsk1fo5WHwGUcuVg302AA/tPGQh4wHBpKAjiQqj9l0c4HNdKFJUeKR9Tt/w1wv6o8oWmt/ZUNNLxixpeBZEcqD5/NOGp+wEXtfDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685354; c=relaxed/simple;
	bh=16vKVzcFmBpTDdzGUUSgTUF0M4//L2fR8ZPWlKp3GnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YU2D9AWepGf3zvDEv1KELzGG88QrWK7nFztsK7zEw0jp6H+dCrrlkvNc25+oOitSBdU9gsFzqy/PBk8ChkAxFdge1Vhx9puEDc9p/yhoYzi1gqFbxPQl6cPgqDL/Y9oJRqg0LTNj+dpmkKalYaZvp94hpdrbfI+w/9JDofaTZCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4QBovl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4QBovl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE420C4CEEA;
	Mon, 23 Jun 2025 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685354;
	bh=16vKVzcFmBpTDdzGUUSgTUF0M4//L2fR8ZPWlKp3GnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4QBovl6Oq5n2DLiCy0n4NGmMatyjrBbdbopPi7DCvxSm5MqpOeuCndfOS977nfZ7
	 gbm7JSHMuohuqSpyT9eWHBXI6reqvOl7sp3BwA06ALKFDw7X7ELIsM5J+kQucBu5OY
	 EbJ/b2hM3rxylFEaM/DidkBa3j0P7ij22BnUDCv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 088/222] MIPS: Move -Wa,-msoft-float check from as-option to cc-option
Date: Mon, 23 Jun 2025 15:07:03 +0200
Message-ID: <20250623130614.747988012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-6.1.y and earlier, it has no direct mainline
equivalent.

In order to backport commit d5c8d6e0fa61 ("kbuild: Update assembler
calls to use proper flags and language target") to resolve a separate
issue regarding PowerPC, the problem noticed and fixed by
commit 80a20d2f8288 ("MIPS: Always use -Wa,-msoft-float and eliminate
GAS_HAS_SET_HARDFLOAT") needs to be addressed. Unfortunately, 6.1 and
earlier do not contain commit e4412739472b ("Documentation: raise
minimum supported version of binutils to 2.25"), so it cannot be assumed
that all supported versions of GNU as have support for -msoft-float.

In order to switch from KBUILD_CFLAGS to KBUILD_AFLAGS in as-option
without consequence, move the '-Wa,-msoft-float' check to cc-option,
including '$(cflags-y)' directly to avoid the issue mentioned in
commit 80a20d2f8288 ("MIPS: Always use -Wa,-msoft-float and eliminate
GAS_HAS_SET_HARDFLOAT").

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -107,7 +107,7 @@ endif
 # (specifically newer than 2.24.51.20140728) we then also need to explicitly
 # set ".set hardfloat" in all files which manipulate floating point registers.
 #
-ifneq ($(call as-option,-Wa$(comma)-msoft-float,),)
+ifneq ($(call cc-option,$(cflags-y) -Wa$(comma)-msoft-float,),)
 	cflags-y		+= -DGAS_HAS_SET_HARDFLOAT -Wa,-msoft-float
 endif
 


