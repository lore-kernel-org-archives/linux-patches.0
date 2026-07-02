Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24E431AAAF;
	Thu,  2 Jul 2026 16:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010370; cv=none; b=I0HwMAstgmI9/7xhVy/C6sikZFgtc5kjvL6A6pGafxZtOsxicoFBXst/viVHR6q7D3TfGqiH0L9e2WtLfkcEMEn2QTXI1CGyaHlJHahhXKItD3uUilu+08RUGeXLl2MrSuZrppgICa6cTJ++OzKB1dQLRMGCj3MWkal9FJUSnfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010370; c=relaxed/simple;
	bh=Q/xJ1PGYkGQC0R4pMiaWO3nlSwOd/t+bI8ddXyvCddM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSNAN6mPCE684qwinLdqXBUxlb7H6IE/ICNyvKHgcVIHYKtJpZ9em+G01IAozphD1Qh7by6YCM2nnB+ze+pwSoOW7CoJ8AjtENwOMAgLLerbOHc/3o03Bm8r2XYW+NuqLbECQqySdCWx2SouJibYu2pLuh5mvmo4uOyiePRkrs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kmKrRS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kmKrRS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0B21F000E9;
	Thu,  2 Jul 2026 16:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010368;
	bh=JvwRHV8jbvDRfNEqm387K6nTHhOD8B/ypYnyGLkHrYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kmKrRS8CU2iOLCGEAZ3jtZ6I8nsTntuUwOCRF4Rfre9Ot5NU0FecjMmzYRDWvR+/
	 tAxU1gCXDwpM8evojw/z5oSZFPzSYEWY6jbvUR7CvC0tqvVWUT9DU55Dd6C82fNVNn
	 tVW+BR9lclX+W/b6PIOm4GXK8qBUUgeF8/fLQkXU=
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
Subject: [PATCH 6.12 083/204] scripts/sorttable: Fix endianness handling in build-time mcount sort
Date: Thu,  2 Jul 2026 18:19:00 +0200
Message-ID: <20260702155120.404616730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


