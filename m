Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619591;
	b=MlJOhvYCMf+/9kZQ/zkzbqHD4E1jzgQX6lEamO5bddTea60e2AjJf1Fdc1UnTO8n8dZ1
	 Kh3iaZVLMUovdKqL3y5xGOEB4T655DBuddC90GCK62m9tmXnaaIXZKZkkUTLNfRnOWs+b
	 NK1XKn/9S7ER7Hxdn0NRyOHS4cdjja5Fv1wlM17bz1L70Ub2267/ULR73ZqqOrJp2QJ2V
	 KERALVgGMXY13SkM/QrV+uXhbeEn27Koqqg7a9hqvDTq0Rzwrsb706hlHqv9/iwl0B1BW
	 5sejees2n4oKuJBOcUVKVyO7xVHU2pFGH+OHJNKZwN2ZX4FkgbyscprUsK5CLrS6dkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4x/g0g/HNvlqaixG+docaFQnRguGZzhmwa8MSe/M7uU=;
	b=zikFdmqhuiqrdR+H3EN313ulb5reaTNsvq3K8e0kgG6hWzeaCL0q3TvgY2M/uJnoEqkk
	 ZcjrTEcSVSFUfu+hpFG0xyDz1GL3mXUxNSs0qjOTlzsyfWMRg7JtOxHrMTzE77MaGCIV3
	 viR5E92zMLnug5viTtHSgTFhLx17rAP+Rkf4z4SZiNSY5+OjUlJ1qjTDDz804hVhd8NUU
	 RliW+Ob7YVA0KL+4ayGwiWIjD4kmpvOqNwJTWgPgXa18053NB23iuIWEl0EOS/neqBEi0
	 4vxFwCNxUBInxC9lpRlH+D6y88tHPU5S9GyFVSctkVxOYa+8Snu+nEzmn2Co0dG05aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egflpSZk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E36E606A323;
	Wed, 25 Nov 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egflpSZk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ECC1F000C0;
	Wed, 25 Nov 2026 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619590;
	bh=4x/g0g/HNvlqaixG+docaFQnRguGZzhmwa8MSe/M7uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egflpSZkwPEgqNc5bm4yf6XyGAp27wAWR+6i3OUS9F4QbOGepL7S5Km/ZyqhpKrXt
	 cNRsPLqvQIlmmnZZcqwmlT2cR/JZdB51P8K5ICztf5kb37RzkgQQYY8hKawo2Cdb3L
	 fB5ozYNDEoLpMvtJPc+6WYz5Ar7TJkSAjA+8Bfvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0601/1005] mm/memory_hotplug: resize zones under their seqlock
Date: Wed, 25 Nov 2026 15:32:19 +0100
Message-ID: <20261125143835.823260178@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 58e81bb7de5aac8ec5e4aa21d401e7dafbd4058b upstream.

With CONFIG_DEBUG_VM the page allocator checks that a page which is
freed, split or allocated lies within its zone. The check reads
zone->zone_start_pfn and zone->spanned_pages under zone->span_seqlock, as
memory hotplug can change the two at any time.

Commit 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking") removed
the write side, since all resizing is serialized by the hotplug lock. That
leaves the reader without protection. When memory below the start of a
zone goes online, the start is lowered first and the size is raised
afterwards. When the lowest memory of a zone goes offline, the size is
reduced first. In between, the zone seems to end before its last pages. If
one of them goes through the allocator at that moment, it is reported as
being outside of the zone triggers VM_BUG_ON_PAGE().

Write the two fields in a write section of the seqlock. Interrupts are
disabled as pages are freed from interrupts, too, and the reader would
wait for the writer which it has interrupted.

Fixes: 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20261103-pgalloc-ai-hotfixes-v2-4-e0d2890ab74f@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |   44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -475,6 +475,22 @@ static unsigned long find_biggest_sectio
 	return 0;
 }
 
+/*
+ * The page allocator checks pages against the span of their zone while the
+ * zone is resized, see page_outside_zone_boundaries(). It must not see the
+ * new value of one field together with the old value of the other one.
+ */
+static void zone_set_span(struct zone *zone, unsigned long start_pfn,
+			  unsigned long spanned_pages)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&zone->span_seqlock, flags);
+	zone->zone_start_pfn = start_pfn;
+	zone->spanned_pages = spanned_pages;
+	write_sequnlock_irqrestore(&zone->span_seqlock, flags);
+}
+
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
@@ -490,13 +506,10 @@ static void shrink_zone_span(struct zone
 		 */
 		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
 						zone_end_pfn(zone));
-		if (pfn) {
-			zone->spanned_pages = zone_end_pfn(zone) - pfn;
-			zone->zone_start_pfn = pfn;
-		} else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+		if (pfn)
+			zone_set_span(zone, pfn, zone_end_pfn(zone) - pfn);
+		else
+			zone_set_span(zone, 0, 0);
 	} else if (zone_end_pfn(zone) == end_pfn) {
 		/*
 		 * If the section is biggest section in the zone, it need
@@ -507,11 +520,10 @@ static void shrink_zone_span(struct zone
 		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
-			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
-		else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+			zone_set_span(zone, zone->zone_start_pfn,
+				      pfn - zone->zone_start_pfn + 1);
+		else
+			zone_set_span(zone, 0, 0);
 	}
 }
 
@@ -703,12 +715,12 @@ static void online_pages_range(unsigned
 static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
-	unsigned long old_end_pfn = zone_end_pfn(zone);
+	unsigned long end_pfn = max(start_pfn + nr_pages, zone_end_pfn(zone));
 
-	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
+	if (!zone_is_empty(zone) && start_pfn > zone->zone_start_pfn)
+		start_pfn = zone->zone_start_pfn;
 
-	zone->spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - zone->zone_start_pfn;
+	zone_set_span(zone, start_pfn, end_pfn - start_pfn);
 }
 
 static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned long start_pfn,


