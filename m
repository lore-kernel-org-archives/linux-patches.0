Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1961A01CF;
	Thu, 15 Aug 2024 13:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728814; cv=none; b=kBH1NE9JP567iX9YGI+8o7HeWLbv4MBFpk1qamXhsG84qDUmzaFyCRRb1HHRypnrioDxmiTbHl2fgSpUx9nD1G0cEr3Z+C3mNr+bZl7JHBFJJdsXiDrH0gE1ATyMGueIqSGRapA1n444353YqR2XlH+s5ClSVqCHkI7IchIsyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728814; c=relaxed/simple;
	bh=aLdJYWjibBb7ha/BllVT7P2lT+Q4NcvGoDqcgOSBwLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGGPRpIbQTvdUZvmyhTad6OFIQxHqEAIx+ia/MPXf+CZKJWSF1jn016GQeb6teuV5dzh1cNrvf4hSM/nEW/Xg31cVvoOx8IfjWo1pYTe+65a0ME3HlCfSi69T3ps8NtFomFYS5b4ELlZkEnxss9xKUpk0qHUb0dPWAteSLOih1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg5IEaUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg5IEaUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A86FC32786;
	Thu, 15 Aug 2024 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728814;
	bh=aLdJYWjibBb7ha/BllVT7P2lT+Q4NcvGoDqcgOSBwLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg5IEaUjdnIiRTXTLMR3vMF/hIDLWCyTFhw/ZaH9VQGkT+k+/IYYhuZo/yAShZPaW
	 tVf3caKk7Y/i7TaLwBrMtOaFVPleRrYLvNVQC0SW3Sw13p4Dl5BqnxT5kCWQ3djwvC
	 am5ObfUs4e0nO9Rz9ntWwCmU+Vwh8piGjewR2o5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/196] perf/x86/intel/pt: Fix a topa_entry base address calculation
Date: Thu, 15 Aug 2024 15:23:56 +0200
Message-ID: <20240815131856.630396570@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ad97196379d0b8cb24ef3d5006978a6554e6467f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 1fe74019ee3c8..87cca56228856 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -816,7 +816,7 @@ static void pt_update_head(struct pt *pt)
  */
 static void *pt_buffer_region(struct pt_buffer *buf)
 {
-	return phys_to_virt(TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
+	return phys_to_virt((phys_addr_t)TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
 }
 
 /**
-- 
2.43.0



