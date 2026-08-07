Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDA735C188;
	Fri,  7 Aug 2026 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115106; cv=none; b=aBr72bdehNWR7qoR7yFMbHMKwuGuw5cVhTODQSL4pJMseaZDgn0bWdWyDejuY0+ZaEkbf5oDb6tx87mHmWL3erI15cXyL5QCDAzTIig+SPHLxLi7zVdLAd0+RJ5WLRgW/XVXQaGlI3Rk/TcExSa0oZOiPhDWAhtI5IE36b6dn7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115106; c=relaxed/simple;
	bh=h+smHl+Q6OLrJEvbZPyn4LRl0hhHtqFBVxiXasTaqS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apx3u5+6zn9H/13tN84HBp3zu3dOmi+xaAIU/oorUCnZ3ZC6Oi4rLNLHNQpQUwI94Ex8+1WuNUDlnFlb3QwQ94e6+Y5Kc9zpOKe5c/QtvPoc0/tSnFt3hwoM5LodOG6ex/uzX7zB7q9Xq8YFUZzsD0E2l0FkQrNDAbw1fHBNX9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDo8Udjy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDo8Udjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D371F000E9;
	Fri,  7 Aug 2026 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115104;
	bh=2bSPNlW9bO1H7UwrcljURSYwhNF9o6hRs/L6psYNbRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDo8Udjyqbo7Dy4Ft+Me4CLw3JoirJrPO8PEoyzqW2fa+BoRlKnuLqvhbCaK39x16
	 kqZkDSgKT+Bt28fiHrmBIEehGRHXdvXRfdDtJe9+RSLVdBEFdaAgfpXQ93nJ6R3pwG
	 5bNbR01wpmhBsOg/AtNUvvhd7H79pcmwBFtNaYiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/396] mshv: Order pt_vp_array publish against irqfd assertion path
Date: Fri,  7 Aug 2026 16:35:19 +0200
Message-ID: <20260807143427.737817946@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit b098dc869219c15dc49bf9cf63fb5fc1481d3373 ]

mshv_partition_ioctl_create_vp() initialises a VP struct (allocations,
mutex_init, init_waitqueue_head, page mappings) and then publishes the
pointer into partition->pt_vp_array.  Several ISR paths read this array
locklessly: the intercept ISR, the two scheduler ISRs, and
mshv_try_assert_irq_fast() on the irqfd fast path.

Of these, only mshv_try_assert_irq_fast() can structurally race the
publish.  It runs from an eventfd waker without holding pt_mutex, and
MSHV_IRQFD does not require the target lapic_apic_id (== vp_index) to
refer to an existing VP at registration time.  A user can therefore
register an irqfd targeting a yet-to-be-created VP, then trigger
mshv_try_assert_irq_fast() concurrently with MSHV_CREATE_VP for the
same index.  On weakly-ordered architectures the reader can observe a
non-NULL pointer in pt_vp_array before the initialising stores to the
VP struct become visible, leading to use of partially-initialised
fields (e.g. vp_register_page).

The other ISR readers cannot reach this race: the hypervisor will not
generate intercept or scheduler messages for a VP that has never been
told to run, and the user can only call MSHV_RUN_VP on the VP fd
returned by MSHV_CREATE_VP, which by construction is returned after
the publish.  Leave those readers as plain loads.

Use smp_store_release() in mshv_partition_ioctl_create_vp() to publish
the pointer, and pair it with smp_load_acquire() in
mshv_try_assert_irq_fast().  On x86 these compile to plain accesses
under TSO; on ARM64 they emit one-instruction acquire/release barriers,
acceptable on this fast path.

The destroy-side path (destroy_partition() clearing pt_vp_array[i] to
NULL after kfree(vp)) has a separate ordering and lifetime concern
that is out of scope here.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_eventfd.c   | 9 ++++++++-
 drivers/hv/mshv_root_main.c | 8 +++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 65b969b82fb97..161a9655aa0b1 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -169,7 +169,14 @@ static int mshv_try_assert_irq_fast(struct mshv_irqfd *irqfd)
 		return -EOPNOTSUPP;
 #endif
 
-	vp = partition->pt_vp_array[irq->lapic_apic_id];
+	/*
+	 * Pairs with smp_store_release() in mshv_partition_ioctl_create_vp().
+	 * MSHV_IRQFD does not require the target lapic_apic_id to refer to an
+	 * existing VP, so this read can race a concurrent VP creation; the
+	 * acquire ensures that a non-NULL pointer implies the VP's
+	 * initialising stores are visible.
+	 */
+	vp = smp_load_acquire(&partition->pt_vp_array[irq->lapic_apic_id]);
 
 	if (!vp->vp_register_page)
 		return -EOPNOTSUPP;
diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 4e04bef544379..3a356b34774bd 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -979,7 +979,13 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 
 	/* already exclusive with the partition mutex for all ioctls */
 	partition->pt_vp_count++;
-	partition->pt_vp_array[args.vp_index] = vp;
+	/*
+	 * Pairs with smp_load_acquire() in mshv_try_assert_irq_fast(), which
+	 * can run concurrently from an irqfd waker without holding pt_mutex.
+	 * The release ensures the VP's initialising stores are visible to any
+	 * reader that observes a non-NULL pointer in pt_vp_array.
+	 */
+	smp_store_release(&partition->pt_vp_array[args.vp_index], vp);
 
 	return ret;
 
-- 
2.53.0



