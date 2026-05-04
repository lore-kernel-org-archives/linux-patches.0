Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6FE34753C;
	Mon,  4 May 2026 13:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903051; cv=none; b=RYwmb3RaIi9xZVLIfoKS+4B1L2MydeMpkAjVQ4LYUdEycI986IZLjLefZ0UraD+8FwiOAWzL2o7DLqXLvdQM/z5sbtpoRcQZUebfs0TRg1DPgByneOSWJkWV1tgNPPGmA1ghnGQcYRVahlO+hbwzMr1cinairUgkwjGaRxSTQSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903051; c=relaxed/simple;
	bh=PyZIlFbA8N0G5I2p7AE0845N1fJ0DR5FKl7Se7Mwtsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLpz+PnBSwiuCaNYRGap8qLWK8IyP9o5U7byw8lED8JRa8wdYYFcw2oFmYVZu6+nyqfsvFz/hXgWSoJbVbfe7XYZjK6INcGKn5w6etNlLzlNWkBaqu+CJwMU6XAtMfH6rXlQBUds+EfiVjBYzo68hj1CpRBgtPu4luNW3DPOFdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyLs8hC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyLs8hC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9345C2BCB8;
	Mon,  4 May 2026 13:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903051;
	bh=PyZIlFbA8N0G5I2p7AE0845N1fJ0DR5FKl7Se7Mwtsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyLs8hC/rzwndkQxp8cBVhAWaEHCFDXKqWHK0l8rOGGXnPO3krFm7BBtN6btD8qCk
	 K3BtUJJMWhvQFShqv28n2HTto1sGo6/CjOQ6lHZa2boKyY54qxTEUFcon5d5d2JRcE
	 gEvKDKMnxRlAnjXCbk9lWZAZx3t52U2I/mRLV/oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 084/307] mm/hugetlb: fix early boot crash on parameters without = separator
Date: Mon,  4 May 2026 15:49:29 +0200
Message-ID: <20260504135145.973740554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit c45b354911d01565156e38d7f6bc07edb51fc34c upstream.

If hugepages, hugepagesz, or default_hugepagesz are specified on the
kernel command line without the '=' separator, early parameter parsing
passes NULL to hugetlb_add_param(), which dereferences it in strlen() and
can crash the system during early boot.

Reject NULL values in hugetlb_add_param() and return -EINVAL instead.

Link: https://lore.kernel.org/20260409105437.108686-4-thorsten.blum@linux.dev
Fixes: 5b47c02967ab ("mm/hugetlb: convert cmdline parameters from setup to early")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4252,6 +4252,9 @@ static __init int hugetlb_add_param(char
 	size_t len;
 	char *p;
 
+	if (!s)
+		return -EINVAL;
+
 	if (hugetlb_param_index >= HUGE_MAX_CMDLINE_ARGS)
 		return -EINVAL;
 


