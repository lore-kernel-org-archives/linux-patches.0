Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89D41E47AD;
	Tue, 12 Aug 2025 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026895; cv=none; b=PanOLE04nANRxFM1uaTgZA1uCItflZ6QFDwkTIy6GvIiPjogmARL0NVk5Nvebt2bew1CDykl1neohN10v58ILDOJxeVzunXPUnorlPc6OS/uyuMERMc6oDjmYDbwgmG78xGPcH/VaVX1lim0VJLqepIIv8VGH2n8Pv5c7jnNBfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026895; c=relaxed/simple;
	bh=TC+G2VMEyv1H1zgl1WLJgOIJXaIUPcQTa9lb8q9Bt+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOuDvF1DN5Mit1Ws9PDHcc2S9GvWcBVcZb2nRe5i0P4BpMaqOd4/iBq1wTDOByU41ENyPIQ5r7384wM34zy7EfHLBd1xUt+rxYD4PAfX2N5BV+C+fZpmjeV8R0mPIJVx9xiM6wxFCkAhAHqmBqyKLOVjwYK+7w8SHmLxYNgg7gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuBCURsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuBCURsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E357C4CEF0;
	Tue, 12 Aug 2025 19:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026895;
	bh=TC+G2VMEyv1H1zgl1WLJgOIJXaIUPcQTa9lb8q9Bt+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuBCURsWYSyv/V/RBefwK7fj3I/vO/f4bsu4CYEZF00ST81SvcsVa5RXIy2Wps4fo
	 iSX6yNwXw25Eida5S3rkx8NGul9xodCFy8QHO9PwYZUa/yXj8WA987UJoqxFNktlIM
	 f0qxi1Y2y+gr8JTWFuxDL+UXApjuS+DKfeWegcXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Patryk Kowalczyk <patryk@kowalczyk.ws>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 471/480] mm: shmem: fix the shmem large folio allocation for the i915 driver
Date: Tue, 12 Aug 2025 19:51:19 +0200
Message-ID: <20250812174416.807110270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 8d58d65621118fdca3ed6a0b3d658ba7e0e5153c upstream.

After commit acd7ccb284b8 ("mm: shmem: add large folio support for
tmpfs"), we extend the 'huge=' option to allow any sized large folios for
tmpfs, which means tmpfs will allow getting a highest order hint based on
the size of write() and fallocate() paths, and then will try each
allowable large order.

However, when the i915 driver allocates shmem memory, it doesn't provide
hint information about the size of the large folio to be allocated,
resulting in the inability to allocate PMD-sized shmem, which in turn
affects GPU performance.

Patryk added:

: In my tests, the performance drop ranges from a few percent up to 13%
: in Unigine Superposition under heavy memory usage on the CPU Core Ultra
: 155H with the Xe 128 EU GPU.  Other users have reported performance
: impact up to 30% on certain workloads.  Please find more in the
: regressions reports:
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
:
: I believe the change should be backported to all active kernel branches
: after version 6.12.

To fix this issue, we can use the inode's size as a write size hint in
shmem_read_folio_gfp() to help allocate PMD-sized large folios.

Link: https://lkml.kernel.org/r/f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5930,8 +5930,8 @@ struct folio *shmem_read_folio_gfp(struc
 	struct folio *folio;
 	int error;
 
-	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
-				    gfp, NULL, NULL);
+	error = shmem_get_folio_gfp(inode, index, i_size_read(inode),
+				    &folio, SGP_CACHE, gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
 


