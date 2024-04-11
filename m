Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B81422C4;
	Thu, 11 Apr 2024 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829735; cv=none; b=LFxzbjtHhwQ4rmv7P770p03RJlRqGAS36wq0gJCpu9wz9Qzl8BvN1IIaf9pBanU/P+Zid34DeYdLceoPqnsiE1KnwCEuDLgJGe/TeUOJteRGwvpGGbn5Uxhx06etE1yF6/xswbIl9e2ArW2XutQkwuLlXrIWt1W3gWZEChPEVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829735; c=relaxed/simple;
	bh=gr89WBYhHHvUbUM3mx/ft5xF68qlht8GOBGRdrWNrC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAErfrBs9QWMXf2D/9f3MPcp9pk5sgtOd7PL7Y+oONHAVguxrHK+hzwrz2z12HeUypdonKvkthHQ8AuB4d+Q9nGbOleKYLHXwuVv76wR3hF/ihMaj3oiCyhzLZLLhWGh+6RhXgRaTp+ieFTgPa8roPb1V4P1oscYqxpu5yEc1zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W+jwgVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W+jwgVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DF6C433F1;
	Thu, 11 Apr 2024 10:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829734;
	bh=gr89WBYhHHvUbUM3mx/ft5xF68qlht8GOBGRdrWNrC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W+jwgVIvjhG2YvHytgLE3Y0wD0/g0xXJKm/w1HeJEk8F8jm6iTDnwjhEKaAM4Oqy
	 lVuNfx8W9pDgqhPnt4LYtf+odOnYnqclpgCF2LIXtR9wPW/lMBaRBMObGicz7JzSxj
	 zVDlwWBMI9bhyyHTOx2YLKP98RgPpx7yK6OX6dzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH 4.19 080/175] mm/memory-failure: fix an incorrect use of tail pages
Date: Thu, 11 Apr 2024 11:55:03 +0200
Message-ID: <20240411095421.971149662@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Liu Shixin <liushixin2@huawei.com>

When backport commit c79c5a0a00a9 to 4.19-stable, there is a mistake change.
The head page instead of tail page should be passed to try_to_unmap(),
otherwise unmap will failed as follows.

 Memory failure: 0x121c10: failed to unmap page (mapcount=1)
 Memory failure: 0x121c10: recovery action for unmapping failed page: Ignored

Fixes: c6f50413f2aa ("mm/memory-failure: check the mapcount of the precise page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1033,7 +1033,7 @@ static bool hwpoison_user_mappings(struc
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_success = try_to_unmap(p, ttu);
+	unmap_success = try_to_unmap(hpage, ttu);
 	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
 		       pfn, page_mapcount(p));


