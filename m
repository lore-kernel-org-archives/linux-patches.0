Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43A6465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FFEC340EE;
	Tue, 22 Mar 2022 21:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985630;
	bh=OS2JY1FSwLuTAcLjNpZhlKwc2xb6s+hIEI0ezMIjvL0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=YmiTrfqkxmXDMGehcEF1DKJ21jllpp+qQB2GmNhJFSQMCXtdIhIr5ANt4fvhDPyC/
	 CAWWXHUcAOo2WaaxcZnvclShW5Zn85ORiY1u201e0yACjTKVY56lqsnbuVy1UIVoOr
	 j5gVrs8dGQgiswvpbXZJFv4pTsAgtlp2meo+1MbE=
Date: Tue, 22 Mar 2022 14:47:09 -0700
To: rafael@kernel.org,osalvador@suse.de,mhocko@suse.com,gregkh@linuxfoundation.org,david@redhat.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 170/227] drivers/base/memory: add memory block to memory group after registration succeeded
Message-Id: <20220322214710.78FFEC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: add memory block to memory group after registration succeeded

If register_memory() fails, we freed the memory block but already added
the memory block to the group list, not good.  Let's defer adding the
block to the memory group to after registering the memory block device.

We do handle it properly during unregister_memory(), but that's not
called when the registration fails.

Link: https://lkml.kernel.org/r/20220128144540.153902-1-david@redhat.com
Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded
+++ a/drivers/base/memory.c
@@ -665,14 +665,16 @@ static int init_memory_block(unsigned lo
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 	INIT_LIST_HEAD(&mem->group_next);
 
+	ret = register_memory(mem);
+	if (ret)
+		return ret;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
 	}
 
-	ret = register_memory(mem);
-
-	return ret;
+	return 0;
 }
 
 static int add_memory_block(unsigned long base_section_nr)
_
