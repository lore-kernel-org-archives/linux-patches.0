Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A28E280A4B;
	Tue, 27 May 2025 17:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368602; cv=none; b=kEnvLXTj0ogC76Iol2cLEezlX5wEGTFXbBfG6I/jTLIpM+ElA+RTCmJAQTScZZYP7FNlbvViAMS79gYWncK6n7kcvPbbFI23MvVpd9IfVUZ8+hAmt0SuD4aR2cmn0/XUTKbiqjzhLlwNbkj8Uyf4e6E7crVtQ4Rjijo+nVR+h3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368602; c=relaxed/simple;
	bh=qbf27/e5Lk6lg2puqR2LvjtAFkm8LDxnV1A2zHHkHPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0qNKY9YfiSUJXIImlgpFzhimWxbzQDEd8Q6ivqUGUsYrjpmKuPikYpktMxSTL8sv2n1/oPyqdZHrWYeXRN/uF/vJOTVuQDGFlpRcv2evlGXt6q0YO9Of4DeDiWZ/TzjAw+YQYb7yrUxYcdP49XpzkE+fQ60Q+MINSHAIw7JPW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQdLsN4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQdLsN4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A4DC4CEE9;
	Tue, 27 May 2025 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368602;
	bh=qbf27/e5Lk6lg2puqR2LvjtAFkm8LDxnV1A2zHHkHPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQdLsN4JwJUl6/VtUhFFV/RHuSTttJkbkooxzzHUqJ8/7Yef3gxC5Kmm9G23xN7e+
	 edVrBX+1OIOBBJv5M+EU0G6Og3RDgxvOfXnNV51DD4UjaZRFcC7GMx3XSCc8OLqIfi
	 dIxiWD4Q9u24gFdabQ9muKLiuFCpgni69cnoA1PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 759/783] mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled
Date: Tue, 27 May 2025 18:29:16 +0200
Message-ID: <20250527162544.029589986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>

commit 7190b3c8bd2b0cde483bd440cf91ba1c518b4261 upstream.

commit c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE") maps the
mmap option MAP_STACK to VM_NOHUGEPAGE.  This is also done if
CONFIG_TRANSPARENT_HUGEPAGE is not defined.  But in that case, the
VM_NOHUGEPAGE does not make sense.

I discovered this issue when trying to use the tool CRIU to checkpoint and
restore a container.  Our running kernel is compiled without
CONFIG_TRANSPARENT_HUGEPAGE.  CRIU parses the output of /proc/<pid>/smaps
and saves the "nh" flag.  When trying to restore the container, CRIU fails
to restore the "nh" mappings, since madvise() MADV_NOHUGEPAGE always
returns an error because CONFIG_TRANSPARENT_HUGEPAGE is not defined.

Link: https://lkml.kernel.org/r/20250507-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled-v5-1-c6c38cfefd6e@kuka.com
Fixes: c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE")
Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mman.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -157,7 +157,9 @@ calc_vm_flag_bits(struct file *file, uns
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
+#endif
 	       arch_calc_vm_flag_bits(file, flags);
 }
 


