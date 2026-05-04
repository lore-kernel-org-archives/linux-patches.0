Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ADF3D5645;
	Mon,  4 May 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903187; cv=none; b=i7jjYUrlb7QkE9cYtkc6QpGTLlu5d76m6Fg57qzFMybYVMsQ5/69W7oCVCyrMtJixNbChgwHJXpPkM2Gqw4dGJ8hoWoIo7HfFH/6NWdAzS8DFKclZYbWNLqvFXnZDiUnT255ehbWVuYklPMeTxtdL49TInDmFmDV8BLq6aFbi+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903187; c=relaxed/simple;
	bh=Qh2rb6ZhO4P4Mh9T8lM1sxS4DNsqJUV7XxpVJX8qaSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIL1HG1SahpmtHF47Z1OGu+fP8wf7St6NWHURkqRYU1qiQwoNBekzHKp+A3TjQXdrANeJrhrbzCjYXYubhF2OhayPLhGBI3L2r2+IrDB9LND8l3itEqrS2683IeJ9PIsdiY62MGSYXmsOydZPGxS/7CBHoc2gp2/zXebeyuih/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSngP45x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSngP45x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA2BC2BCB8;
	Mon,  4 May 2026 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903187;
	bh=Qh2rb6ZhO4P4Mh9T8lM1sxS4DNsqJUV7XxpVJX8qaSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSngP45xCDhUKTsLFohXzTXgbeDR3BAlIzHgbmjHR3T2T6PeC6uR4L1CF3Fg6WnS/
	 FmC7IuoM9+8QkwlYX9RaqqnM4wthdAFQHjjggac0zrlRruc5hJw3m/XBL22kJqb0qx
	 W0hIN0JDGfxJVGZDkS3oQz1O1fQpF3MtV6l/UExw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 105/307] mm/zone_device: do not touch device folio after calling ->folio_free()
Date: Mon,  4 May 2026 15:49:50 +0200
Message-ID: <20260504135146.762878552@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit 39928984956037cabd304321cb8f342e47421db5 upstream.

The contents of a device folio can immediately change after calling
->folio_free(), as the folio may be reallocated by a driver with a
different order.  Instead of touching the folio again to extract the
pgmap, use the local stack variable when calling percpu_ref_put_many().

Link: https://lore.kernel.org/20260410230346.4009855-1-matthew.brost@intel.com
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
 		pgmap->ops->folio_free(folio);
-		percpu_ref_put_many(&folio->pgmap->ref, nr);
+		percpu_ref_put_many(&pgmap->ref, nr);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:


