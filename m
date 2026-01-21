Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE263D3482;
	Wed, 21 Jan 2026 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020366; cv=none; b=bdwpuLrEVQO86kSTDRImQSFJBo2S169tFdGlcl/reUUsdVZT7nSqSqTkI4OOlS0N7XqNjCAqL3f8rXAdog8XqicxscD+QOWXUjpTtiItZ0W56mxvcXuCZvCDDmLrIWqc8Ufm/aBRWLVTU+Hvs0Gwr1Y/xO+CvL2Acin550IuuXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020366; c=relaxed/simple;
	bh=grYRSzM9s/IXke0tj3yCVMRUArVlzf+KxxPt8kR/pwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJIZoelXq/fyjFDzd1v0TbAzwjQrD3P4BRgXJhOJF3AuwwViYHNkJmMPXZNMP++/pwJBPSkBaWRAe6Q8aS47ICJ6LEPVie8TANnVA6MqDl+zs+sRmUIaYNqcai5r4jf6hbOg/F4Y0bQl1yakWM/OL2g+CUdKfjRHK6wpoTdS4QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWeVX+2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWeVX+2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF89BC4CEF1;
	Wed, 21 Jan 2026 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020366;
	bh=grYRSzM9s/IXke0tj3yCVMRUArVlzf+KxxPt8kR/pwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWeVX+2jzmSU0KoxOc2M8Siljy8/7o9x77SKgYKNLFN5KtLrRpMLr+kobvThPAw8x
	 yU8xa21fCsUuOU7jpy7hvm1jbEujLs05gjmCOi6Z/ineuJhUxiDH5TeUTsrGWyjMVv
	 PoIi2Bv/wdLZO8OiFen2MvNII3xSARl9rzERRku4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 103/198] tools/testing/selftests: fix gup_longterm for unknown fs
Date: Wed, 21 Jan 2026 19:15:31 +0100
Message-ID: <20260121181422.260314939@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 21c68ad1d9771d331198cc73cbf6e908d7915f35 upstream.

Commit 66bce7afbaca ("selftests/mm: fix test result reporting in
gup_longterm") introduced a small bug causing unknown filesystems to
always result in a test failure.

This is because do_test() was updated to use a common reporting path, but
this case appears to have been missed.

This is problematic for e.g.  virtme-ng which uses an overlayfs file
system, causing gup_longterm to appear to fail each time due to a test
count mismatch:

	# Planned tests != run tests (50 != 46)
	# Totals: pass:24 fail:0 xfail:0 xpass:0 skip:22 error:0

The fix is to simply change the return into a break.

Link: https://lkml.kernel.org/r/20260106154547.214907-1-lorenzo.stoakes@oracle.com
Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/gup_longterm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index 6279893a0adc..f61150d28eb2 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -179,7 +179,7 @@ static void do_test(int fd, size_t size, enum test_type type, bool shared)
 		if (rw && shared && fs_is_unknown(fs_type)) {
 			ksft_print_msg("Unknown filesystem\n");
 			result = KSFT_SKIP;
-			return;
+			break;
 		}
 		/*
 		 * R/O pinning or pinning in a private mapping is always
-- 
2.52.0



