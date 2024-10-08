Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783641C5793;
	Tue,  8 Oct 2024 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392774; cv=none; b=VZUAivUte41NGps5uYEp3QT6wVJN5cxTRw7b57U2v8slDBA7RW7M+1fe4SAhuW0eZi9rD5uAkHxdPHoVD4fEmwZr+nlM69v8B7FU0ekCc7pysfUEO32aHWw4/dsNxmf5qKuGFQT+R/s816Nsex1qIhGulId/7YLcOfe+tK2B1J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392774; c=relaxed/simple;
	bh=FpOP337FLJ48D7yKV2zqBApSaZR4ViHPlX/1/yAIlSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMeiFadm5N+56VmTwJ2ts8hhvt4qetITg0hye+4BxIlaX5xJIPBFibxD3iC1I+Ma3BPXDCthd8lO2EHg8xaOHW4J2AS7uBys2Ci/+7d5AxS49WMmhR9ZGEqB7dxMr23PHwJ+sa/Waz+z4pmLAhRh6AoyfrWlrl633ReK+Wj78LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgIFnKiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgIFnKiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F092DC4CEC7;
	Tue,  8 Oct 2024 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392774;
	bh=FpOP337FLJ48D7yKV2zqBApSaZR4ViHPlX/1/yAIlSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgIFnKiDOZlvHitOV02tVRTlnqJz5ntZnKtAXdwW0RzaFTqTPk40r0sqF7T9nZsp2
	 EMOYOvajhqal69UTN7pXRmyH4NGpeqhe0z6qDP9loua3iY67gHggaWjG4lpjNxPZVb
	 twLqqW1IzeBnvYN9Z/tYNiLzyoiRSS+cB8pLOjTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Sistare <steven.sistare@oracle.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 484/558] mm/gup: fix memfd_pin_folios alloc race panic
Date: Tue,  8 Oct 2024 14:08:34 +0200
Message-ID: <20241008115721.281982453@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Sistare <steven.sistare@oracle.com>

commit ce645b9fdc78ec5d28067286e92871ddae6817d5 upstream.

If memfd_pin_folios tries to create a hugetlb page, but someone else
already did, then folio gets the value -EEXIST here:

        folio = memfd_alloc_folio(memfd, start_idx);
        if (IS_ERR(folio)) {
                ret = PTR_ERR(folio);
                if (ret != -EEXIST)
                        goto err;

then on the next trip through the "while start_idx" loop we panic here:

        if (folio) {
                folio_put(folio);

To fix, set the folio to NULL on error.

Link: https://lkml.kernel.org/r/1725373521-451395-6-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3705,6 +3705,7 @@ long memfd_pin_folios(struct file *memfd
 					ret = PTR_ERR(folio);
 					if (ret != -EEXIST)
 						goto err;
+					folio = NULL;
 				}
 			}
 		}


