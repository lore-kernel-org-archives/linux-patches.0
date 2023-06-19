Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A7FBE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F842C433C8;
	Mon, 19 Jun 2023 10:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172227;
	bh=/aQZyq9jAwM0/PEq8vAWmAofXwP2tbWJNQ7P4wuJ3hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0vUNmqsuIaCZQuLixE9/w50DQXCfEFQURMKZsi0fRjKutJ5BktqiDBOk8/Apy9gx
	 T2NGT23Tg6XSY08N8YjEYlFOhkd3emgSVcrlLIXOdK8Y2pN8FxK3mM6hdrIUMrMRyT
	 ++jRFNnVRsJqifQbIB4fGqL87ng3Nr/nDQON/+Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Ma Wupeng <mawupeng1@huawei.com>
Subject: [PATCH 5.10 82/89] mm/memory_hotplug: extend offline_and_remove_memory() to handle more than one memory block
Date: Mon, 19 Jun 2023 12:31:10 +0200
Message-ID: <20230619102142.020097694@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Hildenbrand <david@redhat.com>

commit 8dc4bb58a146655eb057247d7c9d19e73928715b upstream.

virtio-mem soon wants to use offline_and_remove_memory() memory that
exceeds a single Linux memory block (memory_block_size_bytes()). Let's
remove that restriction.

Let's remember the old state and try to restore that if anything goes
wrong. While re-onlining can, in general, fail, it's highly unlikely to
happen (usually only when a notifier fails to allocate memory, and these
are rather rare).

This will be used by virtio-mem to offline+remove memory ranges that are
bigger than a single memory block - for example, with a device block
size of 1 GiB (e.g., gigantic pages in the hypervisor) and a Linux memory
block size of 128MB.

While we could compress the state into 2 bit, using 8 bit is much
easier.

This handling is similar, but different to acpi_scan_try_to_offline():

a) We don't try to offline twice. I am not sure if this CONFIG_MEMCG
optimization is still relevant - it should only apply to ZONE_NORMAL
(where we have no guarantees). If relevant, we can always add it.

b) acpi_scan_try_to_offline() simply onlines all memory in case
something goes wrong. It doesn't restore previous online type. Let's do
that, so we won't overwrite what e.g., user space configured.

Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20201112133815.13332-28-david@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |  105 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 89 insertions(+), 16 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1788,39 +1788,112 @@ int remove_memory(int nid, u64 start, u6
 }
 EXPORT_SYMBOL_GPL(remove_memory);
 
+static int try_offline_memory_block(struct memory_block *mem, void *arg)
+{
+	uint8_t online_type = MMOP_ONLINE_KERNEL;
+	uint8_t **online_types = arg;
+	struct page *page;
+	int rc;
+
+	/*
+	 * Sense the online_type via the zone of the memory block. Offlining
+	 * with multiple zones within one memory block will be rejected
+	 * by offlining code ... so we don't care about that.
+	 */
+	page = pfn_to_online_page(section_nr_to_pfn(mem->start_section_nr));
+	if (page && zone_idx(page_zone(page)) == ZONE_MOVABLE)
+		online_type = MMOP_ONLINE_MOVABLE;
+
+	rc = device_offline(&mem->dev);
+	/*
+	 * Default is MMOP_OFFLINE - change it only if offlining succeeded,
+	 * so try_reonline_memory_block() can do the right thing.
+	 */
+	if (!rc)
+		**online_types = online_type;
+
+	(*online_types)++;
+	/* Ignore if already offline. */
+	return rc < 0 ? rc : 0;
+}
+
+static int try_reonline_memory_block(struct memory_block *mem, void *arg)
+{
+	uint8_t **online_types = arg;
+	int rc;
+
+	if (**online_types != MMOP_OFFLINE) {
+		mem->online_type = **online_types;
+		rc = device_online(&mem->dev);
+		if (rc < 0)
+			pr_warn("%s: Failed to re-online memory: %d",
+				__func__, rc);
+	}
+
+	/* Continue processing all remaining memory blocks. */
+	(*online_types)++;
+	return 0;
+}
+
 /*
- * Try to offline and remove a memory block. Might take a long time to
- * finish in case memory is still in use. Primarily useful for memory devices
- * that logically unplugged all memory (so it's no longer in use) and want to
- * offline + remove the memory block.
+ * Try to offline and remove memory. Might take a long time to finish in case
+ * memory is still in use. Primarily useful for memory devices that logically
+ * unplugged all memory (so it's no longer in use) and want to offline + remove
+ * that memory.
  */
 int offline_and_remove_memory(int nid, u64 start, u64 size)
 {
-	struct memory_block *mem;
-	int rc = -EINVAL;
+	const unsigned long mb_count = size / memory_block_size_bytes();
+	uint8_t *online_types, *tmp;
+	int rc;
 
 	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
-	    size != memory_block_size_bytes())
-		return rc;
+	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+		return -EINVAL;
+
+	/*
+	 * We'll remember the old online type of each memory block, so we can
+	 * try to revert whatever we did when offlining one memory block fails
+	 * after offlining some others succeeded.
+	 */
+	online_types = kmalloc_array(mb_count, sizeof(*online_types),
+				     GFP_KERNEL);
+	if (!online_types)
+		return -ENOMEM;
+	/*
+	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
+	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
+	 * try_reonline_memory_block().
+	 */
+	memset(online_types, MMOP_OFFLINE, mb_count);
 
 	lock_device_hotplug();
-	mem = find_memory_block(__pfn_to_section(PFN_DOWN(start)));
-	if (mem)
-		rc = device_offline(&mem->dev);
-	/* Ignore if the device is already offline. */
-	if (rc > 0)
-		rc = 0;
+
+	tmp = online_types;
+	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
 
 	/*
-	 * In case we succeeded to offline the memory block, remove it.
+	 * In case we succeeded to offline all memory, remove it.
 	 * This cannot fail as it cannot get onlined in the meantime.
 	 */
 	if (!rc) {
 		rc = try_remove_memory(nid, start, size);
-		WARN_ON_ONCE(rc);
+		if (rc)
+			pr_err("%s: Failed to remove memory: %d", __func__, rc);
+	}
+
+	/*
+	 * Rollback what we did. While memory onlining might theoretically fail
+	 * (nacked by a notifier), it barely ever happens.
+	 */
+	if (rc) {
+		tmp = online_types;
+		walk_memory_blocks(start, size, &tmp,
+				   try_reonline_memory_block);
 	}
 	unlock_device_hotplug();
 
+	kfree(online_types);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(offline_and_remove_memory);


