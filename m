Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD391DDCE;
	Tue, 16 Jul 2024 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145749; cv=none; b=k9AxikrBDQESkLINAJKVnioixs/CPLs/Ei03Pqs28OCxJ9i1yLbQ46vL2xAs/SQslJYM8Cj32HGRfIrRTYxBgQYuTMLFbg9ICIbvJvHZREiAnDE4Rj/0NGB4CIz5vZsPIegfyQ39EOjaygDNVIoSs8+qwKdemW3Zh+N/y8xCa4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145749; c=relaxed/simple;
	bh=zVaguHFacRmXlTuG5VwXvQ1PkiXTMu4F6upLtqgFShU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/Nd+MJ6eV0bK7i5SQgpXUvxuUoPTSXJpBCMKNSwph1ddnA1OGV9RDkmaYTcVCHamE+QPdf5zzgaQO/XvBLfwzDjRlojj3WrRbqmWkVp42/3E+BSa05btWLvXm4UV/lTGwFciGCGA5W8+07lWTvlEgXYl8mBdIhWY4jUZrmTY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dm0HazmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dm0HazmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D481EC116B1;
	Tue, 16 Jul 2024 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145749;
	bh=zVaguHFacRmXlTuG5VwXvQ1PkiXTMu4F6upLtqgFShU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dm0HazmLaEMuoz7XKOwxPwI6mSo79pGFQPI20fg9Bp9rX4YUWEKIgJHrxQnteN5Jq
	 PuDrj0aIv3mxEUYecioR4bzATpMq5S1JWQ+F7lisoutF3h/IjXRvu+Xt9lKvn95ob6
	 H7ogLXYOxFtHuiCAVFLCTZqkabonOLxOo/lwhCPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Hailong.Liu" <hailong.liu@oppo.com>,
	Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 072/121] mm: vmalloc: check if a hash-index is in cpu_possible_mask
Date: Tue, 16 Jul 2024 17:32:14 +0200
Message-ID: <20240716152754.098241529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

commit a34acf30b19bc4ee3ba2f1082756ea2604c19138 upstream.

The problem is that there are systems where cpu_possible_mask has gaps
between set CPUs, for example SPARC.  In this scenario addr_to_vb_xa()
hash function can return an index which accesses to not-possible and not
setup CPU area using per_cpu() macro.  This results in an oops on SPARC.

A per-cpu vmap_block_queue is also used as hash table, incorrectly
assuming the cpu_possible_mask has no gaps.  Fix it by adjusting an index
to a next possible CPU.

Link: https://lkml.kernel.org/r/20240626140330.89836-1-urezki@gmail.com
Fixes: 062eacf57ad9 ("mm: vmalloc: remove a global vmap_blocks xarray")
Reported-by: Nick Bowler <nbowler@draconx.ca>
Closes: https://lore.kernel.org/linux-kernel/ZntjIE6msJbF8zTa@MiWiFi-R3L-srv/T/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1984,7 +1984,15 @@ static DEFINE_PER_CPU(struct vmap_block_
 static struct xarray *
 addr_to_vb_xa(unsigned long addr)
 {
-	int index = (addr / VMAP_BLOCK_SIZE) % num_possible_cpus();
+	int index = (addr / VMAP_BLOCK_SIZE) % nr_cpu_ids;
+
+	/*
+	 * Please note, nr_cpu_ids points on a highest set
+	 * possible bit, i.e. we never invoke cpumask_next()
+	 * if an index points on it which is nr_cpu_ids - 1.
+	 */
+	if (!cpu_possible(index))
+		index = cpumask_next(index, cpu_possible_mask);
 
 	return &per_cpu(vmap_block_queue, index).vmap_blocks;
 }


