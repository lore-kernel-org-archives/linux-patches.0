Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438882D8378;
	Sun,  7 Jun 2026 10:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827895; cv=none; b=T0fVSY6KaW3yKUef9QyD+O86xvCJLHXGsjWb4u0784gvrwABy+mFYOf9eqODeAJks5B2VC1yO87A3KiS1MEFddpsl2fr3nos7KqiWTIbnZFgNiVqUDYVow2GuvXSMqm0xTEY9aTj3IutvOJZqaXHqxswZsg9yuT2XvJfGPhvcvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827895; c=relaxed/simple;
	bh=wv95eBAffzmJfaNPAb+/Qb7MWJy5nx1DW/6xxuIcFsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9yM/Y2iX5lfNtQErbJmf9icBi+tIHnpuYq5mA/qrUrE+JPPNii/lYcIx43lDN5IeeEpMh5lGYiBWFqAESB71DJOMddceKRhrcIMbI3X5ElSFzdTEI58wKOw33UBRAb841Ue5HntsZM9DMg6NVL1Iycw+XFdQQdFgaZyRa2gSx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVk8zEBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVk8zEBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B68B1F00893;
	Sun,  7 Jun 2026 10:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827894;
	bh=11a4o+6jgSvW5V15VIvr7uCcsZLa3Zwsvv2q53klrm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVk8zEBQvdHIrXapY91X0C0bRMPzPTdBfy106vaEIgXFA7C6fX2P5Mb2whE6kvhTt
	 3YdLHPUDnOZr/QLUJsZMzgDvF8y2bfCz+0sU/LjN3NXmbakh5J2fsV1L1cXpWN8EUL
	 aB2yzuEIshRpbUNeZmbmL4HEzjP9O+ADkpnE1u0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com,
	Baoquan He <baoquan.he@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 135/332] mm/vmalloc: do not trigger BUG() on BH disabled context
Date: Sun,  7 Jun 2026 11:58:24 +0200
Message-ID: <20260607095733.055996331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

commit 04aa71da5f35aacdc9ae9cb5150947daa624f641 upstream.

__get_vm_area_node() currently triggers a BUG() if in_interrupt() returns
true.  However, in_interrupt() also reports true when BH are disabled.

The bridge code can call rhashtable_lookup_insert_fast() with bottom
halves disabled:

__vlan_add()
 -> br_fdb_add_local()
  spin_lock_bh(&br->hash_lock); <-- Disable BH
   -> fdb_add_local()
    -> fdb_create()
     -> rhashtable_lookup_insert_fast()
      -> kvmalloc()
       -> vmalloc()
        -> __get_vm_area_node()
         -> BUG_ON(in_interrupt())
  spin_unlock_bh(&br->hash_lock)

this triggers the BUG() despite the caller not being in NMI or
hard IRQ context.

Replace the in_interrupt() check with in_nmi() || in_hardirq().

Link: https://lore.kernel.org/20260515153009.2296191-1-urezki@gmail.com
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3209,7 +3209,7 @@ struct vm_struct *__get_vm_area_node(uns
 	struct vm_struct *area;
 	unsigned long requested_size = size;
 
-	BUG_ON(in_interrupt());
+	BUG_ON(in_nmi() || in_hardirq());
 	size = ALIGN(size, 1ul << shift);
 	if (unlikely(!size))
 		return NULL;


