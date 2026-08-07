Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8379533DEF7;
	Fri,  7 Aug 2026 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115372; cv=none; b=jyd5ZyCLOnHWY65i060EJkHv6RbNZzcLO5MYqalol4SPZESNAyO+kA5qy6TyR3J9M210z8ifp+ddyZmFq9R9Ndzspb3eMBo8vUbOGUYl9DTULZ4GV8hA7XXXzJkS2P8mGwQqCCzxmJpHtpxwll8hgNFvb6uFWtW3NHhbMFq+Jqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115372; c=relaxed/simple;
	bh=unOA8HgihPi/TEsEJz6vdysw3UgrpzjNzyAU2o1nEZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gcVx6ZyjaZyJfRORsRdf2+jw1ecaJAKQCEXLuVZWMRniUa9ZWDBlsu90ms2bFeKnuJ0WDgBKxXrEoVDKsaAmEuEGy2xuH2DZn5DLUsTwvzkCw1Z5JUdM7sWctCosADztwrnIle2IDh60YN0YIIuIuZvxgMnafecB/joAo2dr3zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK93XqFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK93XqFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AE71F000E9;
	Fri,  7 Aug 2026 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115371;
	bh=ZTXScwRvfReyX+YOs9MrQDHqbU6U/rSu4tqHJ9dTHMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK93XqFXTC3+PyGJBt1RxLk7hiqeFAe1BBh3RZs5GCchaXnYyaqtgwmlLm5WGRvY2
	 6b0TBYOo8OPyGm9nAjA2Tq6d3U/+Jn0MIcUXLlr+L/VD15uBGfj2C6XZk+I5MqzJYT
	 h01NcefZ64tbfNqIBAgCsD9A+A1aANf7R4ol+HKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Link Lin <linkl@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Greg Thelen <gthelen@google.com>,
	James Houghton <jthoughton@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 236/396] mm/page_reporting: use system_freezable_wq to fix UAF during suspend
Date: Fri,  7 Aug 2026 16:36:36 +0200
Message-ID: <20260807143429.347921531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Link Lin <linkl@google.com>

commit 0b45f6927a14914ff685fe0e6f9d11232a1e03df upstream.

During PM freeze (e.g.  S3 suspend or S4 hibernation), device drivers like
virtio_balloon reset their underlying virtio devices and delete their
virtqueues via vdev->config->del_vqs().

However, page reporting work (page_reporting_process) was scheduled on the
global system_wq.  Because system_wq lacks the WQ_FREEZABLE flag, the PM
freezer skips it, leaving page_reporting_process active during suspend.

If pages are freed into the buddy allocator while suspending (for example,
when core MM invokes the balloon shrinker during S4 hibernation image
saving), page reporting triggers virtballoon_free_page_report() on deleted
virtqueues, resulting in a Use-After-Free / General Protection Fault:

    [  196.795226] general protection fault, probably for non-canonical address 0xaa1436fe70dae6df: 0000 [#1] SMP NOPTI
    [  196.825967] Workqueue: events page_reporting_process
    [  196.831038] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
    [  196.927073] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
    [  196.946943] page_reporting_process+0x370/0x4f0

Fix this by switching page reporting work to system_freezable_wq.  This
ensures that the PM freezer pauses page_reporting_process before device
drivers destroy their reporting virtqueues.  Because the reporting worker
is frozen, memory reclamation/freeing (e.g.  via shrinker execution) can
safely return pages to MM during freeze without triggering unfrozen
reporting work on deleted virtqueues.

This aligns with the driver's existing design. The comment in
virtballoon_freeze() states:
    /*
     * The workqueue is already frozen by the PM core before this
     * function is called.
     */

Testing:
I have verified these fixes using Google’s virtualization infrastructure
by running continuous suspend/resume iterations (40+ cycles) while
churning memory using stress-ng (`stress-ng --vm 4 --vm-bytes 60%
--timeout 1`) to constantly create free pages for the buddy allocator.  We
also set the `page_reporting_order` parameter to 0 to make the page
reporting worker highly sensitive, forcing it to pick up any 4K free
pages.  This confirmed that the UAF crashes are no longer reproducible.

Link: https://lore.kernel.org/20260721005603.1710551-1-linkl@google.com
Fixes: 36e66c554b5c ("mm: introduce Reported pages")
Signed-off-by: Link Lin <linkl@google.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_reporting.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -80,7 +80,8 @@ __page_reporting_request(struct page_rep
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			   PAGE_REPORTING_DELAY);
 }
 
 /* notify prdev of free page reporting request */
@@ -343,7 +344,8 @@ err_out:
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		queue_delayed_work(system_freezable_wq, &prdev->work,
+				   PAGE_REPORTING_DELAY);
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);


