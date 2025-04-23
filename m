Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60012957D7;
	Wed, 23 Apr 2025 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421997; cv=none; b=OPPG6TpsRbE8UQem+HIp8JkBrELWJigNuYJK8f8MsX03/PZLzUEgUk2vk8bWoXcsKVmTl9dDEeo1XA+PgGWkK+GYHeUGpURchctyLs+dL64blspMeqdLU4oypicOo3T0XKVy7Rsy/O6kALq4TuN0OjlDn96hc3iDw9Mgu0/dE9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421997; c=relaxed/simple;
	bh=dwc8AokvdyxdcbDJnZ2jQlgOU63z5PR3nggvQCECJnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHgLiwdqKMx9PtNjnN6wpPMzuwfiWEvtTDUBxHVAneZg6c1l9oOIqFp16cSqQxSka4ZzvBMonmGzO6QVTO6YfAiRXx7AJ4MDaVl5W+jpSSn7Wvl87PlGe25LDtZJX69gB+uZOy+HxrSr/p/qb9gkV2ZGX2021CYA+aq8bzVA7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT0woXrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT0woXrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0DC4CEE2;
	Wed, 23 Apr 2025 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421997;
	bh=dwc8AokvdyxdcbDJnZ2jQlgOU63z5PR3nggvQCECJnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT0woXrjPclWZtVfYMAYHbIZMy8ZrOihJQqv9fOqVZDj9O5pnK5rQV2l9LKD55ij6
	 dzseEG9ku8z1rflA/G5c82Fv7ZRSrS3HxtIkjv9JhXGhDbIoQU7+0ihLw7TZ6wWkz3
	 wbSwsbdTRmZzrA+QxpdvjVK/p34q68oEcKV2nyWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 215/291] mm: fix filemap_get_folios_contig returning batches of identical folios
Date: Wed, 23 Apr 2025 16:43:24 +0200
Message-ID: <20250423142633.178170355@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

commit 8ab1b16023961dc640023b10436d282f905835ad upstream.

filemap_get_folios_contig() is supposed to return distinct folios found
within [start, end].  Large folios in the Xarray become multi-index
entries.  xas_next() can iterate through the sub-indexes before finding a
sibling entry and breaking out of the loop.

This can result in a returned folio_batch containing an indeterminate
number of duplicate folios, which forces the callers to skeptically handle
the returned batch.  This is inefficient and incurs a large maintenance
overhead.

We can fix this by calling xas_advance() after we have successfully adding
a folio to the batch to ensure our Xarray is positioned such that it will
correctly find the next folio - similar to filemap_get_read_batch().

Link: https://lkml.kernel.org/r/Z-8s1-kiIDkzgRbc@fedora
Fixes: 35b471467f88 ("filemap: add filemap_get_folios_contig()")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reported-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Closes: https://lkml.kernel.org/r/b714e4de-2583-4035-b829-72cfb5eb6fc6@gmx.com
Tested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2266,6 +2266,7 @@ unsigned filemap_get_folios_contig(struc
 			*start = folio->index + nr;
 			goto out;
 		}
+		xas_advance(&xas, folio_next_index(folio) - 1);
 		continue;
 put_folio:
 		folio_put(folio);


