Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F87D337110;
	Fri, 17 Oct 2025 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714603; cv=none; b=dJi7F2BKy3DxxT0eb5r4qZMeroYiNsSWwGjxk5DoUOnX1YNki7J/C7399AvcPhGf+Ue3nKOQbrxArvrF5PV51lgeVeFpKAPJxmDx1wuthL2n4JGIN8GWeH5qyMoJGcdR/1Z1jmXkiU/wXLIUBVPF34UaqVHfST9mwGjD9Fky/B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714603; c=relaxed/simple;
	bh=40NYl5lw9oto3GjV7Y7g1QwZswWVTGx0s2a8EjBV1vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgwOhxrPOpiho2x4V9rMdNWsxDTCLocW/aq2L+tEtDgzRzTtQHdmMgcic3fUQrCvlGMgsQLjJ9vARVy4Kw0ecl/9DUmHY+tA2tRcv8xA7CGcA4OfoKdNvPWw0KasqJk0QfxRLqiWOcFC0A2f873ld9jCjwU1feROpIWadJav4EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zt1Gvmfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zt1Gvmfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9EFC4CEFE;
	Fri, 17 Oct 2025 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714603;
	bh=40NYl5lw9oto3GjV7Y7g1QwZswWVTGx0s2a8EjBV1vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zt1GvmfjgWWC8CQ+sRiBrRl9lsvZ0/JiODo7ePqiC01h1LEoTbwNJBr4eyU+TNAn6
	 IH83SEr1L5idjH9g5gfZyVtrLTeCXiJvfRPWXNNY3cd7uWUpuJdqMazuEBp1curfxS
	 1znj5XN4eJnxrEFKzj39/H4jAvSlpsBl/V7ZHVZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 201/277] slab: mark slab->obj_exts allocation failures unconditionally
Date: Fri, 17 Oct 2025 16:53:28 +0200
Message-ID: <20251017145154.460960900@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit f7381b9116407ba2a429977c80ff8df953ea9354 upstream.

alloc_slab_obj_exts() should mark failed obj_exts vector allocations
independent on whether the vector is being allocated for a new or an
existing slab. Current implementation skips doing this for existing
slabs. Fix this by marking failed allocations unconditionally.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
Closes: https://lore.kernel.org/all/avhakjldsgczmq356gkwmvfilyvf7o6temvcmtt5lqd4fhp5rk@47gp2ropyixg/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org # v6.10+
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1999,8 +1999,7 @@ int alloc_slab_obj_exts(struct slab *sla
 			   slab_nid(slab));
 	if (!vec) {
 		/* Mark vectors which failed to allocate */
-		if (new_slab)
-			mark_failed_objexts_alloc(slab);
+		mark_failed_objexts_alloc(slab);
 
 		return -ENOMEM;
 	}


