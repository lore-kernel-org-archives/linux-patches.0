Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3C43277A9;
	Fri, 17 Oct 2025 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715803; cv=none; b=DGkm72lj3hgWPuZAg4tOqlu/5KbxhHuKX/3Tc/4gcaOB2eYuYoGy1bXWdReda+2W1Y3C/+pVn6sGTri1NiyxDVW78MKYOFNpBm4QUTPWuR2CuxBA8rEy0AW6ZCp9DTDJcGQ2uPAP4wrQ17/KR9RFdfvUbsXKm2vdgsaaTrSP0mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715803; c=relaxed/simple;
	bh=iOZULuCdutpkvtqfpluC5w1a6InFip9njT+35CBXwKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSd8oTRIL6ywRg0gEbfD43vzW2WFlbGoB7THMrkgTttW430moBctb7T4UbHmGNjzfWnaYskiUWXq69gMuhxdof6oM5Drkph3xaTJDQ5zHWNPU9Hj0ykMvS6noCA+TOhiN57BSWlrFLFGwxKmfU0EeZUvTTyNO363b+yD8zAoAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bswaFi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bswaFi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7122C4CEE7;
	Fri, 17 Oct 2025 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715803;
	bh=iOZULuCdutpkvtqfpluC5w1a6InFip9njT+35CBXwKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bswaFi+7NbQ5tGOxtdDo4n1RpoYx1+OGhKcAbOPRhFGuhdMjbwIVTsdmX5fbj464
	 so0phpiB/ngWD+j8h60elnk/cWcW8koDo0XrajooacpMerNk+ej7FDNsPKFdKNdz6j
	 C7f73MdfPv+p0N0xjajfprzYV6AYOqz2MC3LdflY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.17 309/371] slab: mark slab->obj_exts allocation failures unconditionally
Date: Fri, 17 Oct 2025 16:54:44 +0200
Message-ID: <20251017145213.257067646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2034,8 +2034,7 @@ int alloc_slab_obj_exts(struct slab *sla
 			   slab_nid(slab));
 	if (!vec) {
 		/* Mark vectors which failed to allocate */
-		if (new_slab)
-			mark_failed_objexts_alloc(slab);
+		mark_failed_objexts_alloc(slab);
 
 		return -ENOMEM;
 	}


