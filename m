Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4875A2F2365;
	Tue, 17 Jun 2025 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176203; cv=none; b=SmBxWY+WFObzIV/O0dS7y+SkLTlVR2TE7vulnWzo8wzyl3tGPOjCVL625Cor9T6SZPXA6WCQJkuO+jhqca/jNr9jd7tz/CCcucRRoxxb1ZnHl/Di/do+WYvX2vFGbCTG0ahPQ6Iy5y78MOrMAB3J4kzZEGzdyaQzpoIhpZA8ZVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176203; c=relaxed/simple;
	bh=vBdJiIMXNdbggv2akM04EVO6NzPFvNdYlS5LMh1OcLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5E4LzDAmL1wyj1FWKfOjmUNEBaf2aBt3ZuspD3mu1fNQfUOcPdlE39gCvw1RSDUJeItCD3KMtuhaw1RTwRWSANnew6s2maJ1rHOTmXEb87qTczEunjdaN90+znisvySUoXIHXoNV6WdUpc1JBGE/VOAZLSih2LdYfNW1QN0nhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVW8m/fS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVW8m/fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5C6C4CEE3;
	Tue, 17 Jun 2025 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176203;
	bh=vBdJiIMXNdbggv2akM04EVO6NzPFvNdYlS5LMh1OcLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVW8m/fSeXODvAR9R9YHQMsNXSWZHfSZyExYXKe4vsO1pMLUbYDl6effti1NZdw1M
	 TwWtEfRlAH5ATorO/RIM6yXhuhbqMdbvYK+XFAh7/DKSjoaIBERkeAQD6p1y6HaSQB
	 ohLGG+aaujHWpGw2LoWiXVIJKVIRGQp9MTjW2HbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John <jw@nuclearfallout.net>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 155/780] xen/x86: fix initial memory balloon target
Date: Tue, 17 Jun 2025 17:17:43 +0200
Message-ID: <20250617152457.809260898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 74287971dbb3fe322bb316afd9e7fb5807e23bee ]

When adding extra memory regions as ballooned pages also adjust the balloon
target, otherwise when the balloon driver is started it will populate
memory to match the target value and consume all the extra memory regions
added.

This made the usage of the Xen `dom0_mem=,max:` command line parameter for
dom0 not work as expected, as the target won't be adjusted and when the
balloon is started it will populate memory straight to the 'max:' value.
It would equally affect domUs that have memory != maxmem.

Kernels built with CONFIG_XEN_UNPOPULATED_ALLOC are not affected, because
the extra memory regions are consumed by the unpopulated allocation driver,
and then balloon_add_regions() becomes a no-op.

Reported-by: John <jw@nuclearfallout.net>
Fixes: 87af633689ce ('x86/xen: fix balloon target initialization for PVH dom0')
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Message-ID: <20250514080427.28129-1-roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/balloon.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 8c852807ba1c1..2de37dcd75566 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -704,15 +704,18 @@ static int __init balloon_add_regions(void)
 
 		/*
 		 * Extra regions are accounted for in the physmap, but need
-		 * decreasing from current_pages to balloon down the initial
-		 * allocation, because they are already accounted for in
-		 * total_pages.
+		 * decreasing from current_pages and target_pages to balloon
+		 * down the initial allocation, because they are already
+		 * accounted for in total_pages.
 		 */
-		if (extra_pfn_end - start_pfn >= balloon_stats.current_pages) {
+		pages = extra_pfn_end - start_pfn;
+		if (pages >= balloon_stats.current_pages ||
+		    pages >= balloon_stats.target_pages) {
 			WARN(1, "Extra pages underflow current target");
 			return -ERANGE;
 		}
-		balloon_stats.current_pages -= extra_pfn_end - start_pfn;
+		balloon_stats.current_pages -= pages;
+		balloon_stats.target_pages -= pages;
 	}
 
 	return 0;
-- 
2.39.5



