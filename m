Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139461A76DD;
	Tue, 30 Jul 2024 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360531; cv=none; b=OPGUwS436Fgj/6+qZLxH3RKlfIT+axiFh5qbehC76Keq+I63MbUgAF7lQwo1jcDs1F5VRxFTyze0LpmL7onZGSlH971Ui5cUl2ny8th27CoZMY2i8/dL5ACP1UhwVQd6r9tyjRvZaMBWOzGvjZVsUH3iKLj4D1x3QGKYL1DcE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360531; c=relaxed/simple;
	bh=OPbOpTt3i08z1MNUUACmNTjn423ZvuuaRXnJE6LalwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssL7EEvtY9A0f0hM0zspo78rXxBNtUCEvQQUwiKRt9w5yQI6VmG1Bf7Z/tIsbFO3T4ZYw1X9ZY8i4UiMuT8ILONg3JIOqbWq85pF3eoVwObRW205v74cXqSUKtJuLk58PIttVT3X1J3GsLi0aHVzbiY3QVVO6saUKjOa5AXwFAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7Vk/ZBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7Vk/ZBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78204C32782;
	Tue, 30 Jul 2024 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360531;
	bh=OPbOpTt3i08z1MNUUACmNTjn423ZvuuaRXnJE6LalwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7Vk/ZBqdEm5eEAt+Y2LYBBU1w/DmIz+3baeampaYk0eqZJYQZTwFWo4mo4HiTdYL
	 zpxxxXgb2TGzG+PF+3pwingG/0CFW1ku+MRNwXECWWiBrp6X6AAq7kYUtXoWtPgtsw
	 kyDzKcnTExQlJMVTBx1VkTOJRh47qCwEquXn0P7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 697/809] perf/x86/intel/pt: Fix a topa_entry base address calculation
Date: Tue, 30 Jul 2024 17:49:33 +0200
Message-ID: <20240730151752.449915332@linuxfoundation.org>
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
@@ -878,7 +878,7 @@ static void pt_update_head(struct pt *pt
  */
 static void *pt_buffer_region(struct pt_buffer *buf)
 {
-	return phys_to_virt(TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
+	return phys_to_virt((phys_addr_t)TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
 }
 
 /**


