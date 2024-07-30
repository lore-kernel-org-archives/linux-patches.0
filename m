Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768761A6166;
	Tue, 30 Jul 2024 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358094; cv=none; b=oWoMeuqiYAq1+jyYnAFXMo4V+AFhOYQ5HwBGUrtVY70FiArHytBmM2vZESGcGJgxzoRiXnn5qqYjgTVLRJT8ZZgMU8Kp6d88naFNZJcYaDOJQ+arlRDnY9fQUApwectwBRDKLervHmvyR0ZESV3nTMaPo5M3Ch3jMWdVttqKWXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358094; c=relaxed/simple;
	bh=aKiUUYOTTnHh+3MvsF1DhfTEUqZ2SDVNwOCbBscWo2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4RD9HDA//f3GqrsEUbX9Q/YoP3UJZpuJYUKTpGQj0lMLHwOBlULpoOhBOfN0hadhPaZbgAxwJ3tlaHggBrBx68182wN+kCR0b4wzvOpKAkquXzqQUUIG1TGDIWeAsBwmmX1rFbZ0zcvNDEJ7/qscmztVCDbN+sU7/yjnv4LTLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQVFNHmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQVFNHmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB89C32782;
	Tue, 30 Jul 2024 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358094;
	bh=aKiUUYOTTnHh+3MvsF1DhfTEUqZ2SDVNwOCbBscWo2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQVFNHmrQqteqfILDOCsScnRQeYbzcpM0llt42K0x3xLFJTXPZ9X3aFZInsoA3gq1
	 dwi6M250+hEPxHLBBr1qo7sTevTRyyzI/+niae2sYqkVd0QIJQVOSs23Mw8tPHgEFQ
	 AXB6QdKzRiX0/tVjpjPmo3b9B9DgAfEYLCI7hTAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Cavenati <cavenati.marco@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 356/440] perf/x86/intel/pt: Fix topa_entry base length
Date: Tue, 30 Jul 2024 17:49:49 +0200
Message-ID: <20240730151629.721515068@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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


