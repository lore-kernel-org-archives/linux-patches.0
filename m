Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6971C14600A;
	Thu, 11 Apr 2024 10:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830765; cv=none; b=cQGTxddNj5fS4D/RFugmteVQRkjHh0b1KGuYAzDRHoBXERTK/LV5Q4Gw9ID6xR9I9lUVEEfcHxvxk9/J9HXC/PFz0igrbhm1jBWTBtSXJNMNldMHdcF/lOHjVG1tdKc2+oZWUPrprz5d/hBxSSQVoK54Ly3fKhtOXlVQZBpX/eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830765; c=relaxed/simple;
	bh=RswvHXKk+HFQ3rZ3gcaD2M85KOwby7Oxi2LlgZxnSVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbHCnIUf79zWvzQx71tP+oVAiLplUaNIaOZpct5fjWwv6MBJusMOJF+Id8p+4si0kXHv9tntl2yRpAQPjRTZdPh0bO1emp/qpsE7Tq4AP0wdRGDi9P8mf1Rofl7so5qLtD4m+tqEZY7qG7iLyLkDoYdskdW3qLtYTYOBJKAkZ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crU1IfWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crU1IfWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A6DC433C7;
	Thu, 11 Apr 2024 10:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830765;
	bh=RswvHXKk+HFQ3rZ3gcaD2M85KOwby7Oxi2LlgZxnSVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crU1IfWpQf/U8+KYWbuUoVY3Sq7IcOtrJ0J2flqJbAvmnvAdAhYfSmhjJDfwXtbNW
	 MNUBKcvataxa3xpFlmt2cCTOnmFnb/zdWeP3+b0LmSHeatpTPen6wn+agIBvjdsHr+
	 1mNOjLB4e2XwADUjMXzDXabJJkIo7o6TEav7xAqg=
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
Subject: [PATCH 5.4 072/215] memtest: use {READ,WRITE}_ONCE in memory scanning
Date: Thu, 11 Apr 2024 11:54:41 +0200
Message-ID: <20240411095427.063092445@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f53ace709ccd8..d407373f225b4 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -46,10 +46,10 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
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



