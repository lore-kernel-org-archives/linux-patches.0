Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8405453E02;
	Mon, 11 Dec 2023 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fl+oDKM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF8AC433C7;
	Mon, 11 Dec 2023 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319720;
	bh=2KTOMBZYNZbNiNdlV4Fz5HFnqY1wpCZ/hCxOKyIJwB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fl+oDKM7VB5/IjI/nuA4GboQsSD/i77khm7PWujpl4v5uVLFmLF+1j9/vASO+DA+0
	 li4oYe1dSvf7MZ62WrFP95U4CKqePPuahckLyT2PeiEdexxfIwbjUmo8b/odg9DEWk
	 MsV4+SXrT0uDtkwlmpt4F5wQ+N2lGZ/93CZ/zR7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	kernel test robot <lkp@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 169/244] mm/memory_hotplug: fix error handling in add_memory_resource()
Date: Mon, 11 Dec 2023 19:21:02 +0100
Message-ID: <20231211182053.470141306@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit f42ce5f087eb69e47294ababd2e7e6f88a82d308 upstream.

In add_memory_resource(), creation of memory block devices occurs after
successful call to arch_add_memory().  However, creation of memory block
devices could fail.  In that case, arch_remove_memory() is called to
perform necessary cleanup.

Currently with or without altmap support, arch_remove_memory() is always
passed with altmap set to NULL during error handling.  This leads to
freeing of struct pages using free_pages(), eventhough the allocation
might have been performed with altmap support via
altmap_alloc_block_buf().

Fix the error handling by passing altmap in arch_remove_memory(). This
ensures the following:
* When altmap is disabled, deallocation of the struct pages array occurs
  via free_pages().
* When altmap is enabled, deallocation occurs via vmem_altmap_free().

Link: https://lkml.kernel.org/r/20231120145354.308999-3-sumanthk@linux.ibm.com
Fixes: a08a2ae34613 ("mm,memory_hotplug: allocate memmap from the added memory range")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1458,7 +1458,7 @@ int __ref add_memory_resource(int nid, s
 	/* create memory block devices after memory was added */
 	ret = create_memory_block_devices(start, size, params.altmap, group);
 	if (ret) {
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, params.altmap);
 		goto error_free;
 	}
 


