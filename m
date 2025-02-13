Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7463FB3B;
	Thu, 13 Feb 2025 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459945; cv=none; b=fw30UaCRlay/lErfi0RzdiKCadtOhXdC8st6yO6EaRwR3d75Dl60Usw4qgqIDITpM/n36ig2IreBzDXEn+qjIi48Dio/4QIWAQ3w+YxwyO4Jzg2cZqay4zZIIbNRQVNOUsWl1VJ0OkIESJhBOl676qiz/OebNRtebnCMt/plkQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459945; c=relaxed/simple;
	bh=t8j9CFioDK5fFFQQ6qX1kBskGDE5DTzxyxIHNVu8WcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc6peHH5D1opWVWI+QRspEpaJgKvOasS50ORHAC0xzJeNi49DkEHs4F/cymSKvWMk0KkKvaZ5i61iTqVwMYDGZUmRiHnrmDFBvUryT+KKh3LmFlDhhD0H39IKFyBWmIRXH++Cp3zN0JfbkPwlMAaINXa9jRtbwKiEDuGRwd3GN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ0x/krV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ0x/krV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BB6C4CEE4;
	Thu, 13 Feb 2025 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459945;
	bh=t8j9CFioDK5fFFQQ6qX1kBskGDE5DTzxyxIHNVu8WcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJ0x/krVLNzXQuo3J7ElO0MJqXi9vH9WGi+g0d68fpMPFFYa7m3YGT8yq94o3kx82
	 veEsD63rY0Ss6wXeq2sL0l6BF8JE7zvVKuwny44HEz4gOLGUYdX6hmhzKL7Qb+Kh/g
	 tS8m8Yh6hEMsH1EBOXmhhEJ++7ysQLjz+GL0MWV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 379/443] mm/vmscan: accumulate nr_demoted for accurate demotion statistics
Date: Thu, 13 Feb 2025 15:29:04 +0100
Message-ID: <20250213142455.231935229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

commit a479b078fddb0ad7f9e3c6da22d9cf8f2b5c7799 upstream.

In shrink_folio_list(), demote_folio_list() can be called 2 times.
Currently stat->nr_demoted will only store the last nr_demoted( the later
nr_demoted is always zero, the former nr_demoted will get lost), as a
result number of demoted pages is not accurate.

Accumulate the nr_demoted count across multiple calls to
demote_folio_list(), ensuring accurate reporting of demotion statistics.

[lizhijian@fujitsu.com: introduce local nr_demoted to fix nr_reclaimed double counting]
  Link: https://lkml.kernel.org/r/20250111015253.425693-1-lizhijian@fujitsu.com
Link: https://lkml.kernel.org/r/20250110122133.423481-1-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1053,7 +1053,7 @@ static unsigned int shrink_folio_list(st
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1522,8 +1522,9 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	stat->nr_demoted = demote_folio_list(&demote_folios, pgdat);
-	nr_reclaimed += stat->nr_demoted;
+	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += nr_demoted;
+	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */


