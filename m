Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3936627D766;
	Tue, 27 May 2025 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366129; cv=none; b=NbEMAFQkLlmLS9wrYdmHBdRzLQMU9Sa8sGoddGU/11ABUZ/Kh3aTLESwxxqKoGIkNqTzp6jkI3UgDL7OVfzztmkFDkpOT3Fpm1AKCJJ+a4DyMSpautTBLflya8EIzGMTg0R09npadCz1VT5u1mEVHkANBFO9hUIsglb3Lvdf20o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366129; c=relaxed/simple;
	bh=YRq5e9rVEVzwEsRDI4cKoK+yZhXP8FEm2B5i/IRywqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwEHhPxrQ2te/OhBToCeY9/2+cwXIAnjbiQNyOayy/9VIqdnNy3CPeuEdFcQ2PzYNxuMcCgYmCTp9G4LoLZiKUBMkC4Fm5qKf5bx9r90NwWUWL5srKwJjdue7iY9fajS/gFglFxeUwHJJ81IQFH1jttThiLeI4x9ziyp1kIr5Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MV9LzbJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MV9LzbJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3F9C4CEE9;
	Tue, 27 May 2025 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366129;
	bh=YRq5e9rVEVzwEsRDI4cKoK+yZhXP8FEm2B5i/IRywqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MV9LzbJOwP/OrmpprdreXBaYSdqP9EHZgb+5ZUkC8FPhw8P0p3B+dHFlm237pAcIx
	 azxzYd4QtR9NfcOKRZ1O5BM7RPF05e9WYmy7nRHI9fJdRBdsSXHQbhELgRtdNY2oGF
	 TsL03w6aes59yBakst7N6SrENEzZHED7E8mlzgJU=
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
Subject: [PATCH 6.12 600/626] mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled
Date: Tue, 27 May 2025 18:28:13 +0200
Message-ID: <20250527162509.375061419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


