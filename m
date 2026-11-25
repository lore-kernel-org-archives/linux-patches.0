Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619600;
	b=LMzZMuEYZTFR0oxklhFKehOExvguTKiifkmEmtpdhu5Ceyp1/XFWqRdia090YEdauqcT
	 I6cLXj9EsAAA2BBr+B1nwMz9uhMduRLdxs2VbGhjQVqdkW4pwZ5pFdHS9uk8zm5H9T7eI
	 lCirpSceeiprbiJYxy4fgsiSRRjYlUmdYpYwNZeo3mMrUFez2O01/lboXDGuJcDi6GWII
	 qfmFue3b/6ejQbDRr57kP3METAbYLUQW+Y7jwUuNFW1yec/n93G1N/Rcd6S2NBweEBiyv
	 POgtT6A5dlvko47ikdltF7/I1JjosHAM6cd5Fp19FlPJOcOxpXdHsI++Z65ltkI5Saw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CCGvbB8xVyxlJmPqIcsmsD2XLAWBO7ECba/E8nhFOeE=;
	b=QzWPnV6fVbhP5luRVsqYCVAJumbZAEuLjKlL8oPx7L0vRQu4jz9l4CYJa1Iu/IuZZ1op
	 WYQ7nqTpOgq3A6qIqKGFMYhg5Hji1gfZPlb8CKLkdDYHd1wn4ChCA/qMigsbnGuWaSzSQ
	 mzNPREBexhhb4T7gxiVqY1agXjR0fyjkfhqi9Cz4InxhW+/dRIpwb5FUiogLQfUZQbiTu
	 Eaj4KZ66wt+AiCurTvCOOvgng3yf5QgnQvLGxwr56qrXYyafnXTka+hLo9Q99a9B+f7H3
	 fEhT//zaGdaSgVsdqAx9dJzF1LpTGiOi3HX/QvAwaw0AJs0YJHYUFyLfIrYXcFMWACA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G3YZ88W/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A8606A327;
	Wed, 25 Nov 2026 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3YZ88W/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3691F000C0;
	Wed, 25 Nov 2026 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619600;
	bh=CCGvbB8xVyxlJmPqIcsmsD2XLAWBO7ECba/E8nhFOeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3YZ88W/spt+6tZTddmYKA/hGygF5KJAq8o/IU+7J3LTB9lsqXlIBrzWS5vwS15Ga
	 Pr0Wthq3XmQAB611zUD4hpnoHiE9oc9sJtJpVt7NHUy1NOERKiKW2VIRRTt3jbnNp8
	 nmBuQXkSb1gjmACxL2a6t+YlCYs5/RWmUYbeyTms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0604/1005] mm/page_alloc: reset can_retry_reserves when the slowpath restarts
Date: Wed, 25 Nov 2026 15:32:22 +0100
Message-ID: <20261125143835.894504603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

commit b35ce030893929b3670de82bdac2713cb7b20d90 upstream.

Commit 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath()
flow") retries an allocation once with reserve_flags when the caller
becomes eligible for reserves, guarded by can_retry_reserves.

A restart after a cpuset update or a zonelist rebuild retries with
can_retry_reserves already set to false, so a caller that cannot
reclaim (GFP_NOWAIT | __GFP_MEMALLOC), fails without trying reserves.

Reset can_retry_reserves on restart. Only a cpuset or zonelist change
restarts the slowpath, so the retry still runs at most once per change.

With a kprobe helping to make the race deterministic, an allocation
can be made to return NULL. With this patch the allocation will succeed.

Fixes: 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath() flow")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-2-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4806,7 +4806,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
-	bool can_retry_reserves = true;
+	bool can_retry_reserves;
 	unsigned long alloc_start_time = jiffies;
 
 	/*
@@ -4840,6 +4840,7 @@ restart:
 	no_progress_loops = 0;
 	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
+	can_retry_reserves = true;
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
 


