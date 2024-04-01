Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBE481D1;
	Mon,  1 Apr 2024 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989870; cv=none; b=BTIqv6t4x2bUpJdU5Qg/eUXeT8u+OCJACwZ9UR1DQ+JyfbA0GHCcnzsA9sApJ98NfefYzSurtkBNLWLJ1xKSEOllS4nBv4z+L5CrOxX0dlrHKYPrtAj/axreA6BAGx77+Jw71zHy0b/8yrVxijqGP3NFFOdC7NVjv59EbZhT2Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989870; c=relaxed/simple;
	bh=VZAzM+K0xXEju8eXJ1Rzstc/mFstNdkOTz7zopzJ18w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQE4BuIoHt+GIYyZefQ/8Kj+ayhwTRW7g/uI8bFkhInw/uDrbqbTfm3kLcZIo2dJ6D7cuNKQ2B795eUj9561OOUZywXOUpppRV56xnlfRWMHu9BILgYIznMOhDmhZW/acdO8BpSqmG8z2O5jS16MWnJktqJMpEiagsbPM1sfZIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDGCigcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDGCigcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7167BC433C7;
	Mon,  1 Apr 2024 16:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989869;
	bh=VZAzM+K0xXEju8eXJ1Rzstc/mFstNdkOTz7zopzJ18w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDGCigcdk3NF7YagRIBPKYIaWkamANJLNcUKjgs7LAxbZ9WLdWikdxeyELXZyYCh7
	 iKWdWYSPt57S9nCq5VGbfLDodHTCvbBo6Ki4lzNoWnXOuAJwFUCItXmb4QeIH+Lc83
	 4U9/6W6slScW2VwT1RKTC1h93L00Azs69zFnoVuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <qiang4.zhang@intel.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/396] memtest: use {READ,WRITE}_ONCE in memory scanning
Date: Mon,  1 Apr 2024 17:43:19 +0200
Message-ID: <20240401152552.417309733@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Zhang <qiang4.zhang@intel.com>

[ Upstream commit 82634d7e24271698e50a3ec811e5f50de790a65f ]

memtest failed to find bad memory when compiled with clang.  So use
{WRITE,READ}_ONCE to access memory to avoid compiler over optimization.

Link: https://lkml.kernel.org/r/20240312080422.691222-1-qiang4.zhang@intel.com
Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memtest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memtest.c b/mm/memtest.c
index 32f3e9dda8370..c2c609c391199 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -51,10 +51,10 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
 	last_bad = 0;
 
 	for (p = start; p < end; p++)
-		*p = pattern;
+		WRITE_ONCE(*p, pattern);
 
 	for (p = start; p < end; p++, start_phys_aligned += incr) {
-		if (*p == pattern)
+		if (READ_ONCE(*p) == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
-- 
2.43.0



