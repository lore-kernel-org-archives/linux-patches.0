Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC551AB52C;
	Thu, 15 Aug 2024 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731414; cv=none; b=BHmoQqlVd3njsXZASB5YdCvxIShBrV+EG/EBGYW8Bhii9x71FBKgWBk1IHQWgHcGWawW4F7MWwHIcU2mvO+VfRZGzpx3AidagmIfQyyX7mUuirm9NbVmDIweID52Y9UcHHvDQLXukmG9HyAW5c3R+lMTIVv5L2O2eXN0ppEwPmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731414; c=relaxed/simple;
	bh=B0FzT5TIWV6zChQ7KD0IyKjvotn6cb2pkqPBMdaWo3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHR5jh9Ic5OkpDR8tSPHiB5xJ+lAKH6IX0jctfKOKMoUXTATZE6rLQu+71oVqnVWMW9Hn3TNpyQ10IftG1wQdI3m/ZSfjb3xo7BQT3+td1ePUFIaeDuDutPYkLi2wqM7EvD8Z4NbgIRFEANIhye80l9auACsLAI/nMCUMHLjS6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wY8rPt/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wY8rPt/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A2FC4AF0C;
	Thu, 15 Aug 2024 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731413;
	bh=B0FzT5TIWV6zChQ7KD0IyKjvotn6cb2pkqPBMdaWo3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wY8rPt/87LaX+K/PQ6I7ol+7XGCO6Q/ti8oOtCFA5CNVTsx95rda/4RPebcJ2ect4
	 xvzFhRD95JdRUw1KgdG1UcLu3dslMXsj2EohjNi1+oc4/sp+GgBj9XO1eKio4F9wqG
	 8fZaX7n9yIJE4jc0Uw3Gw2Tj7SX/3iRAHte+7LuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 121/259] perf/x86/intel/pt: Fix a topa_entry base address calculation
Date: Thu, 15 Aug 2024 15:24:14 +0200
Message-ID: <20240815131907.469849117@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit ad97196379d0b8cb24ef3d5006978a6554e6467f upstream.

topa_entry->base is a bit-field. Bit-fields are not promoted to a 64-bit
type, even if the underlying type is 64-bit, and so, if necessary, must
be cast to a larger type when calculations are done.

Fix a topa_entry->base address calculation by adding a cast.

Without the cast, the address was limited to 36-bits i.e. 64GiB.

The address calculation is used on systems that do not support Multiple
Entry ToPA (only Broadwell), and affects physical addresses on or above
64GiB. Instead of writing to the correct address, the address comprising
the first 36 bits would be written to.

Intel PT snapshot and sampling modes are not affected.

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624201101.60186-3-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -827,7 +827,7 @@ static void pt_update_head(struct pt *pt
  */
 static void *pt_buffer_region(struct pt_buffer *buf)
 {
-	return phys_to_virt(TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
+	return phys_to_virt((phys_addr_t)TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
 }
 
 /**


