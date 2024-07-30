Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007D01A76C1;
	Tue, 30 Jul 2024 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360528; cv=none; b=OLXNFdUSFqsb8Cy+g9R8SsLSwgP5BeFvNP1BMwsgVI5GwW0FQRSsJxzuUYwWZ4GxS5EyPBtVdhQmtGuVroVnDlQ2fjk6dsBo17r7XaLKqEj1wdpZJKK/GDPhFC0XNyfPrMQ6AcaTiIE/S9hS2KcmQTnCl/46rmXPaYxcjT1iPbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360528; c=relaxed/simple;
	bh=oGxSXs/A2kA4Q6HyZu8Sxlqlj7wYqeNYLV+gQebJwYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZqvVOnLFPiQJ2RvbjBJ1tt0KCHre0k8k3BW5IVtz/gDZQ+NW3oc6H5TmDnlvDC5ekSmovXXXxOV+OvArHxanHsW5EKxvQ+wv3cdAdcnAWTVMK6ImE4UjPT3kgUrFPrHMNuIx1N/OQvJfYlffwexRpRyP6BfC78fK2PDCNDFlLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+rJFoCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+rJFoCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A340C32782;
	Tue, 30 Jul 2024 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360527;
	bh=oGxSXs/A2kA4Q6HyZu8Sxlqlj7wYqeNYLV+gQebJwYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+rJFoCjC85JvR6e1WsFiWOIPou153Usky3kT4EWiLSb3oR9OezDZnmCN4LWRXKtH
	 guy+OcRJl7x4LSJxbOJL0IXSfmhELsQ3fOcIBfDb71NgS9G26osjwiuOBLsTAlH6wQ
	 SMV43AfSFLDR/znNdJKXuUaiQWHs8AUtFpLGIX6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Cavenati <cavenati.marco@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 696/809] perf/x86/intel/pt: Fix topa_entry base length
Date: Tue, 30 Jul 2024 17:49:32 +0200
Message-ID: <20240730151752.409996921@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


