Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47F924E4C3;
	Thu,  2 Jul 2026 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010874; cv=none; b=cmjr4DsV51DZmgx1FCgld8I9TWK5u7rGmXziUFzARMz6s6VSoZ5GwUIjM9vzWehLg8P1U/Totm8NM9W3JHvDBkgWgwkx4hcCxO7oMdJFI4Fb61M1l8EDpZuhlntsHSysosYlaJwoEUD1pWgPr1uQCUuTOYio+ArQGnfxU4Ka1KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010874; c=relaxed/simple;
	bh=PnnarlvcfnlU0NrDXpGE6QU+hnGm8vIceTQh0YphhSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlABy/TtcgrB39LjrC43jPQfTXT4cbG1FgUGq7BicVKbi35zCqLV2LPdxRF/OFJTwFT2vaXV9yT6SZFy5rmo8s3o/tECmiJokvZhnDZR3u+sig24gDqpl0pQEh7lsxjenMoDr4b//FJnZEo/TyVLVWeyDRxDSEze8vx/TA192wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+JVQl3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+JVQl3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFE61F000E9;
	Thu,  2 Jul 2026 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010873;
	bh=WTE9htJNoN8FI/ZDcNSxV3+9whoIZgsRzeh3Alkp/UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+JVQl3/AuEaIfjvNkC/jNuC3BbYK1ca/zP9A+oP9jV+cYTA5wgCPKTRP5AbextcW
	 B8gSuuZhAFH1OK44KCA8fXno6SOFaoVz8943tFGgAaQFYufIZcemDB1zgGtTwLIzPN
	 D/5vxGFJrMQHTVgedYUZtNtUk2lHRlqqpWPY5EmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 070/175] scripts/sorttable: Fix endianness handling in build-time mcount sort
Date: Thu,  2 Jul 2026 18:19:31 +0200
Message-ID: <20260702155117.265629829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 023f124a64174c47e18340ded7e2a39b96eb9523 ]

Kernel cross-compilation with BUILDTIME_MCOUNT_SORT produces zeroed
mcount values if the build-host endianness does not match the ELF
file endianness.

The mcount values array is converted from ELF file
endianness to build-host endianness during initialization in
fill_relocs()/fill_addrs(). Avoid extra conversion of these values during
weak-function zeroing; otherwise, they do not match nm-parsed addresses
and all mcount values are zeroed out.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/patch.git-dca31444b0f1.your-ad-here.call-01743554658-ext-8692@work.hours
Fixes: ef378c3b8233 ("scripts/sorttable: Zero out weak functions in mcount_loc table")
Reported-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Closes: https://lore.kernel.org/all/your-ad-here.call-01743522822-ext-4975@work.hours/
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -857,7 +857,7 @@ static void *sort_mcount_loc(void *arg)
 		for (void *ptr = vals; ptr < vals + size; ptr += long_size) {
 			uint64_t key;
 
-			key = long_size == 4 ? r((uint32_t *)ptr) : r8((uint64_t *)ptr);
+			key = long_size == 4 ? *(uint32_t *)ptr : *(uint64_t *)ptr;
 			if (!find_func(key)) {
 				if (long_size == 4)
 					*(uint32_t *)ptr = 0;


