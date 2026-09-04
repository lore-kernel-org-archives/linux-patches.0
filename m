Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523873515D2;
	Fri,  4 Sep 2026 05:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498454; cv=none; b=XQCQavzhl2sJmDeB90o5gRWwElxRNdYuT8jwdTvKu77INm+xtO0kRXdffv7BPYipP0DQd7tbqVEv/5T/1gxWylJvHO3NiBu/Ww9cj91awLjn3sY99DIdZ88RlHBnbMxlqJA5eP+TMrNVFBpVaF++lhN5xYFwm+JFKhcJqb6Un5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498454; c=relaxed/simple;
	bh=EhRTyIZGQyBOwzaB6ENafVq3nIAQqRGuojacgjnphQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8E8xQ0F/aWE8TylSrkGlhWQgcuApUWg7h39LAg++VsjcrIYeVLOxkNkK/YU9lbXBj0s8O3oWX8xhoHRoPRrwcsaV1SdH7IT++bOPqLv534wkAp5gC8bHjz53WDzu4kZurKQQLXZPi4DnOROpvdvqds/YWDIVbJv/GQF6O3sfZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1FEx9N6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1FEx9N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6711F00A3D;
	Fri,  4 Sep 2026 05:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498453;
	bh=ISMQSZXVhAUPmAc9GBrzxmyNqYRYjt/908HmhpTJU4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1FEx9N6Pm+HjUXV1lfQBsqZxvPVRT3Q/rnA3mzK7MUBAEzEpmYRO8gXl+IVBCUbp
	 AQG2oEHXoONqV/OCJM7Wg+rtMlDewAsS6JnU6Nx6CK4Hf3ha4A3xxipabufCbxr1OY
	 K3hJx3m2k+fo/pw/9OK0UwMz5/mh6J1Zu/K9h+0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.2 067/713] mm/slub: prevent pfmemalloc objects from entering the barn
Date: Fri,  4 Sep 2026 06:50:35 +0200
Message-ID: <20260904045805.343814706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengming Hu <hu.shengming@zte.com.cn>

commit 9338b189be6895e45cf6fcf819c55cd3c47e4a18 upstream.

kmem_cache_return_sheaf() may refill a partially consumed sheaf before
placing it in the barn. Without an explicit restriction, this refill may
draw objects from pfmemalloc slabs and consume emergency reserves.

Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
because this refill is a best-effort attempt and failure is acceptable.
If the refill fails, flush and free the sheaf instead.

Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
Cc: stable@vger.kernel.org
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Link: https://patch.msgid.link/20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5153,7 +5153,7 @@ void kmem_cache_return_sheaf(struct kmem
 	 * simply flush and free it.
 	 */
 	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
-	    refill_sheaf(s, sheaf, gfp)) {
+	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return;


