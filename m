Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046871;
	b=YT2ELX7Ac//gvxmYMlFNJpUeXrv9Tv1XU+AXF8EyifVC61WfPQsU9k1kMhbf2/MxIaC4
	 1rf5oi5I5P6Dm4nMjiGJSbS6RiF7J19lENYBP0/AFdfQ0mJT7YQIy1nGxZ5pB/9SiXU1P
	 T9guOOBAkA2U4W6A25rqqIlps3m/FmoGPt8PNSnrg09VoFr4SaiJU5zvPbXM83CuAU/AC
	 JGpHy2TKm5oQxEYYUohzF8aIFnojaVtrg7Pt/UwqVLG5UTDbvlvPlpGJ6HZ3+V2hvWmS/
	 HF3m/a1E4kxIuVzFnbLPZoPqz480NSBiNSqrcHiLInL2vcwQ1h8/ZhPhoUF5JP4vRIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4pKl4FNqMqW6RIPlY8PNBeaQNoKoFvS/Q+eRhJ7TSY=;
	b=JrCb9PHL7BfxrLRhFltFq3CjOqXgP8GTknGEcrKWLRqK2e1mY0wq2syTjq76j2oNQIWf
	 vhbjAfXFvDVPMninToUhlRCaipLBoAbgqTrD7bm+qdeExb3TlvWSijoFwavccOttlUb9Y
	 cpddc4WeoLs9H9yXBW7SpE4sjrA35jb7vodt458NrksUGE5EQ/rvUYEK0oES1yZhjSB6A
	 vDimvBZCY1ydq/bzuDS9no62L1hdqozbvyo9h3qbg4r74h4z6FzpQolf2CVXjmEvUOukF
	 KGsN43ByH6v87Cm25CCYT1ipR2fyyj6OVF+IQstGR+LljJnTLThp2PNJhgDtexoA5lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E83yWyJf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1BA606A335;
	Thu, 19 Nov 2026 00:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E83yWyJf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8451F000C5;
	Thu, 19 Nov 2026 00:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046871;
	bh=D4pKl4FNqMqW6RIPlY8PNBeaQNoKoFvS/Q+eRhJ7TSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E83yWyJfXiAD0zJ/1XcGiYHCsWMWMmXJx2ARrsmF7OR7C6bU1Lm/WCR1vVzw2bxij
	 1jslFrm6HLGkbiAqV4T1WSzcyri3CrVn83wXEXn8htMh5UgH1YybtCDYTpnTB1xFqX
	 4QmzdICORp+H+db7LCCmgS8CyOrKm0RIfEWYBhpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Colin Ian King <colin.i.king@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1437/2857] mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118150253.055767728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 23fac055c21176f66ed453394b533bdfc00f7fba ]

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-2-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index f68829f1dabad..b5385068a6ad9 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -240,6 +240,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
-- 
2.53.0



