Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63A636CDF1;
	Tue,  6 Jan 2026 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722305; cv=none; b=j8ypIPSEf3dfBPGxjv6NkuB6bj5wafxqAqtgOVli5eLZptnBszoX/zl2YkUG9RHH2xPG3JiesDDtmtuc6PedMMnKHLjcYXKHQW47TASzCS3ovAQgTXLhgb50GCZ01dulAFp4y0CSJY4rCwPAhd0HlrToYMhR5W604o4O/8aBQfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722305; c=relaxed/simple;
	bh=JitcGRzPkG//0CQSnnVE0B8E9Y17WhdmvkwCcfATNh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtQw++u2NO/lATXxWL5AXL7nXZWs6DCdOfv2UdV1zF5HOVHVun+LSNovkukXmgXKqtvAya0ukr7n27Qq5xnI76drkGFugmBXLPPdE1Y0VPhD/iaTPxWISusaKBVulKkI6PS6P/dR5dfvMcIwBbsSebrdlgss6VMVlUs1F4AL5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xH658a8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xH658a8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA31C16AAE;
	Tue,  6 Jan 2026 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722304;
	bh=JitcGRzPkG//0CQSnnVE0B8E9Y17WhdmvkwCcfATNh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xH658a856IoDMkEpTCOmtkgtks9TYkYRzS9QZB6/ikoRiXZaoe1a9qU5vKiC02dA
	 6BD0AHX7lLfIICvedSQyXwEpaas1+Nm0MB83Dmj2N73YPwU0wuKzrIp1pzYfQntNv7
	 k3QW6GkKVDxZs0GecoTXqiRMBo2N2d2y0Mviviw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 224/312] kasan: unpoison vms[area] addresses with a common tag
Date: Tue,  6 Jan 2026 18:04:58 +0100
Message-ID: <20260106170555.956155037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

commit 6a0e5b333842cf65d6f4e4f0a2a4386504802515 upstream.

A KASAN tag mismatch, possibly causing a kernel panic, can be observed on
systems with a tag-based KASAN enabled and with multiple NUMA nodes.  It
was reported on arm64 and reproduced on x86.  It can be explained in the
following points:

1. There can be more than one virtual memory chunk.
2. Chunk's base address has a tag.
3. The base address points at the first chunk and thus inherits
   the tag of the first chunk.
4. The subsequent chunks will be accessed with the tag from the
   first chunk.
5. Thus, the subsequent chunks need to have their tag set to
   match that of the first chunk.

Use the new vmalloc flag that disables random tag assignment in
__kasan_unpoison_vmalloc() - pass the same random tag to all the
vm_structs by tagging the pointers before they go inside
__kasan_unpoison_vmalloc().  Assigning a common tag resolves the pcpu
chunk address mismatch.

[akpm@linux-foundation.org: use WARN_ON_ONCE(), per Andrey]
  Link: https://lkml.kernel.org/r/CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com
[maciej.wieczor-retman@intel.com: remove unneeded pr_warn()]
  Link: https://lkml.kernel.org/r/919897daaaa3c982a27762a2ee038769ad033991.1764945396.git.m.wieczorretman@pm.me
Link: https://lkml.kernel.org/r/873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me
Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/common.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -591,11 +591,26 @@ void __kasan_unpoison_vmap_areas(struct
 	unsigned long size;
 	void *addr;
 	int area;
+	u8 tag;
 
-	for (area = 0 ; area < nr_vms ; area++) {
+	/*
+	 * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] pointers
+	 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
+	 * KASAN checks down the line.
+	 */
+	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG))
+		return;
+
+	size = vms[0]->size;
+	addr = vms[0]->addr;
+	vms[0]->addr = __kasan_unpoison_vmalloc(addr, size, flags);
+	tag = get_tag(vms[0]->addr);
+
+	for (area = 1 ; area < nr_vms ; area++) {
 		size = vms[area]->size;
-		addr = vms[area]->addr;
-		vms[area]->addr = __kasan_unpoison_vmalloc(addr, size, flags);
+		addr = set_tag(vms[area]->addr, tag);
+		vms[area]->addr =
+			__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
 	}
 }
 #endif


