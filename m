Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186E619EEA9;
	Tue, 16 Jul 2024 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145071; cv=none; b=eDbF9iN+pO5/CTMYQPEf+9Coq9e401lWESzDS/DdeEEeG6tb0h0Yiy9aqCtrhzp/f1N4rns6Hup274oswhDbRAxH8mHXeAdXHVUkcf+idCinx1vwdQSPJ3MgIzI+qb5MIjIZvMCNwIwHVcD6tjX1RDnxxluJ1tXyLzMOXGYxjqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145071; c=relaxed/simple;
	bh=d5ccjW/sg26z60RTSzehEMGctmXrHdazXr7FxI0VKjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO/36B59yR4r9dq96/QFVxJun7F7bghCtIV4tK8pN5APaaW6gAWeRy5pf4iHU2IZzEV7kvsxlVR9Lzv4sMrzz7HOQn4gdsqb3rrn6z4ANa5nNovcp4lkDYgTC4kT65ykppaF+PH2QUh/gmTr53MxRYv7A6w2uPOCGsw8rQqLth8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWYFNPqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWYFNPqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C23C4AF0D;
	Tue, 16 Jul 2024 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145071;
	bh=d5ccjW/sg26z60RTSzehEMGctmXrHdazXr7FxI0VKjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWYFNPqAoYQqQ9ZUSDuhXhmBnB8ZrZ+EP3VT0EJK2jH3soCbRaUnmXGCyvxRkSuZ4
	 2H0lj5/MeIdmeSEwpaNov37/qklN5gRD2MziUsMTmGhRkWO/YgUW4e9RUA82mlX1x/
	 PRBaZWw+s1kpsggHODTByKkxiaAk+1D9hFLwiYxg=
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
Subject: [PATCH 6.9 087/143] mm: vmalloc: check if a hash-index is in cpu_possible_mask
Date: Tue, 16 Jul 2024 17:31:23 +0200
Message-ID: <20240716152759.321109374@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2519,7 +2519,15 @@ static DEFINE_PER_CPU(struct vmap_block_
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


