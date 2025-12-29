Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409053191A7;
	Mon, 29 Dec 2025 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025758; cv=none; b=BZeZPAhXinPg9Xa7TjZS6+Zbw0hcnlxWViECtl8uxO9zWoNDaueaATrNVoUapbbYuh+YmFzrWBm0n1/piO5wOtbH857TiICiDyNkTK5MqKYOmWH8fdn34PZ5LPl8E8rsgSLUW56YgcT5zUsQQYeTmlZLMTOOPpaeCfkN80/7IPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025758; c=relaxed/simple;
	bh=NygfxiMpL25ZqyE7DYbSiWBjNUMTMkH6ZCrWIoyUWxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl/ah0fNFRR08j9yrdxGqMTO3juH6sjLJsYMEWJ/MiZ3A3I6qj77kOzb9mGcyPnpnrV0GjrSswiUen2Elxh1LN5NTsxAVlpUY/dbKSbJZE/FM6DMFpUqWI0ARS8jANKOfJ24qsxGZnNAGD13SJ6GMATnF61SiiUOmJTYV2rX+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZdpGOFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZdpGOFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4D5C4CEF7;
	Mon, 29 Dec 2025 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025758;
	bh=NygfxiMpL25ZqyE7DYbSiWBjNUMTMkH6ZCrWIoyUWxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZdpGOFBj1isF20mP7ufy8lQJJ9ZYfLrQgLqRv2CKvxhqO/U2eNkrcUN05sFbDyOE
	 FGktJDnaRHXe96D0ITD98nywC640JzK1MOQEd86s2+WFZ78MkkDtlny/u22agjzvMP
	 s0+do3e6y25rUkRfx2SHQfHDrQBRCkuQYe6Vns74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.18 327/430] mm/slub: reset KASAN tag in defer_free() before accessing freed memory
Date: Mon, 29 Dec 2025 17:12:09 +0100
Message-ID: <20251229160736.364221355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 53ca00a19d345197a37a1bf552e8d1e7b091666c upstream.

When CONFIG_SLUB_TINY is enabled, kfree_nolock() calls kasan_slab_free()
before defer_free(). On ARM64 with MTE (Memory Tagging Extension),
kasan_slab_free() poisons the memory and changes the tag from the
original (e.g., 0xf3) to a poison tag (0xfe).

When defer_free() then tries to write to the freed object to build the
deferred free list via llist_add(), the pointer still has the old tag,
causing a tag mismatch and triggering a KASAN use-after-free report:

  BUG: KASAN: slab-use-after-free in defer_free+0x3c/0xbc mm/slub.c:6537
  Write at addr f3f000000854f020 by task kworker/u8:6/983
  Pointer tag: [f3], memory tag: [fe]

Fix this by calling kasan_reset_tag() before accessing the freed memory.
This is safe because defer_free() is part of the allocator itself and is
expected to manipulate freed memory for bookkeeping purposes.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Reported-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7a25305a76d872abcfa1
Tested-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20251210022024.3255826-1-kartikey406@gmail.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6509,6 +6509,8 @@ static void defer_free(struct kmem_cache
 
 	guard(preempt)();
 
+	head = kasan_reset_tag(head);
+
 	df = this_cpu_ptr(&defer_free_objects);
 	if (llist_add(head + s->offset, &df->objects))
 		irq_work_queue(&df->work);


