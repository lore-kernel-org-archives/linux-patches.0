Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A809019DF5F;
	Thu, 15 Aug 2024 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731410; cv=none; b=kes+uhYWcD99+sOe3VpO7eIPKVcLOlstEMcbRqfVhgGspcLDDBTBInnrozo28m6xSoCUJwYpD+5RR29mTlOm0fPz+u721Twi+lmO3290U5fDbcfj1tqNwoqr48LIj9RMYE71rFmNhh2+hihe/r6o5zjp32q7GIYp4bnijdirpf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731410; c=relaxed/simple;
	bh=pZfu+gwLIHyL5DMSEJnCDUCYiuz6deqxWiM63hLT6xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXsoR+ORfIfqlv9f3NGn2kNr+mmkUW2ef+drrzQh6TItNbWceAD4riu9Z5OurM3o0UeZjin/Po5zEaXCUXMI+1U46I1G1DHzNuP+T5sv3jzUxdEVlXK+J7QOdnw2O0+ps7rzo5gT2qzsj5VPrtQqnSiGbljUYBBrxC3Dy1zQNa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYRja2wQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYRja2wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298B5C32786;
	Thu, 15 Aug 2024 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731410;
	bh=pZfu+gwLIHyL5DMSEJnCDUCYiuz6deqxWiM63hLT6xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYRja2wQ9r2JItX4vpgar64ITLE7ndLbDLyHyUohFNpsMfiAEEo0lGq7EWJw4NDWl
	 e2604lUURQKCEAOCeZjZfIeMNT2evvM4s3gzZJxgNuyeb+OYOrCpd1VsWtWFTErdIL
	 YttzHq/2sAADSGgd8Og8xPZekmc9i0cYAwdx0YEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Cavenati <cavenati.marco@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 120/259] perf/x86/intel/pt: Fix topa_entry base length
Date: Thu, 15 Aug 2024 15:24:13 +0200
Message-ID: <20240815131907.432362234@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Marco Cavenati <cavenati.marco@gmail.com>

commit 5638bd722a44bbe97c1a7b3fae5b9efddb3e70ff upstream.

topa_entry->base needs to store a pfn.  It obviously needs to be
large enough to store the largest possible x86 pfn which is
MAXPHYADDR-PAGE_SIZE (52-12).  So it is 4 bits too small.

Increase the size of topa_entry->base from 36 bits to 40 bits.

Note, systems where physical addresses can be 256TiB or more are affected.

[ Adrian: Amend commit message as suggested by Dave Hansen ]

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Signed-off-by: Marco Cavenati <cavenati.marco@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624201101.60186-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/pt.h
+++ b/arch/x86/events/intel/pt.h
@@ -33,8 +33,8 @@ struct topa_entry {
 	u64	rsvd2	: 1;
 	u64	size	: 4;
 	u64	rsvd3	: 2;
-	u64	base	: 36;
-	u64	rsvd4	: 16;
+	u64	base	: 40;
+	u64	rsvd4	: 12;
 };
 
 /* TSC to Core Crystal Clock Ratio */


