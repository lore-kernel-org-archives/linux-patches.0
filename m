Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622891;
	b=dw/1xIk7BNscR2WboJIUgyNz3sj+qph+fYYGL+SKKQRXYASL27WTz0fVX876WYq9z+9e
	 3IIxcKWIw27SIth6Ol+tzsYeW72c8bEjBvQkut/1v/QNmVfkpQL2An2DFzgLHNY5CFNyL
	 roV7KE3u1n57dSLVesLo64HCv/cHF1RkJ9oSaFMseOenoMdc847EOiGUBT4RaWcQSf22u
	 a13C9DSEam2GLDaeJgpk+A0FwduHSL09555l5P7f/yhHln5QnBfDcw+FAbXf+mSA80Dgn
	 1UPV6Mb5zQVtnSiO4pI4zEIb/7eAaLd3GEA/UalvSJH5kmCGs/5NtqehJzoNuGboRfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3moZhsn7E+LFV5JStLFti3CwMovcmXU2CDWvQm/iTU=;
	b=w13orRkw+ktsC5741x1tqzMPhfCe11zCh2yc7qPXyyobs59TxJ/brCtQikFJv+/oW/y9
	 JIJnmj1gCYdqkoE6YMPgWK8pRJd2RRbQIBote9r6wAEcPJthh/zNBaykLlb5ZTNoceJOs
	 7V3LHnTMJ8oVW0qeTLNN8xbXbfXwnkDW11GdtJBrDDFxK9FCR6EYStP+mtIphXUCbwwdV
	 eS94Mdce58+J9q42Dwiwabw0VicwBMvVWb6yNQfudrDkCS5Yo0+4S/W4oD92ntQsp5giE
	 aOpRRnpKTxMXBxgMrmh7NrKyx16VGgotlS9T/9CbsZVch5auVV+kK4qQ9svM8+Lksrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g6kX/qeF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94034606A321;
	Wed, 25 Nov 2026 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g6kX/qeF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62601F000C0;
	Wed, 25 Nov 2026 16:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622891;
	bh=d3moZhsn7E+LFV5JStLFti3CwMovcmXU2CDWvQm/iTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6kX/qeFfEy3Yi/rxpuk8g2Q5GzZXv7qFcOwvLVhL0tlWIoiaFedz/cu0Q9lXlI0k
	 t6WmrGNtPU68bNRVOmdl3r2rCqB7klZBxQH+S+NQcGDF7L8g6O8Rs9XKONBZU87nyS
	 kVNn6PUm+BacRLciwNl2pjNFtYQ++lQ1AxwOYh1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 681/990] mm/memory_hotplug: resize zones under their seqlock
Date: Wed, 25 Nov 2026 15:34:08 +0100
Message-ID: <20261125143838.038038579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -479,6 +479,22 @@ static unsigned long find_biggest_sectio
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
@@ -494,13 +510,10 @@ static void shrink_zone_span(struct zone
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
@@ -511,11 +524,10 @@ static void shrink_zone_span(struct zone
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
 
@@ -706,12 +718,12 @@ static void online_pages_range(unsigned
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


