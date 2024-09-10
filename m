Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900BF14D431;
	Tue, 10 Sep 2024 10:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962657; cv=none; b=aBWR0fqfEvjN6WxwPxB5q1H7/fKvtoy3EzpLzxqV0vUTdtep91UBxGsJL3znpgmUNUdh7ReRUhgV5+w23qUEr+oeG7VOxMMQSp3TPhuY6LZZ5NAv6I+5p+xK+Z/8h8CQESam3nHjKaZ2qEAyO4ia4wHJEsbRSbuNpxVDb6kevt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962657; c=relaxed/simple;
	bh=B2RVVFS33HXmr/MihR330kw3/jF7IrNo8VSilIkLc20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF7jnrATg2cZx7l04rwbejZu7qHmLPucTv6J9VtEqW/RR68mAm30cbT9zZQ6UIEVqQSF1I/MBTHmyLr6uyEewyFV54KKAyAjO7fzW4ICQspX9drwEVwc/k6uha74fWj1DZ3Ts3udvQK8VmLvTTC3C3epMv1HV0KOTMs9qEiNS1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+dlIKrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+dlIKrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF814C4CEC3;
	Tue, 10 Sep 2024 10:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962657;
	bh=B2RVVFS33HXmr/MihR330kw3/jF7IrNo8VSilIkLc20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+dlIKrCeyS3CVrqI5TLBBl1GZ/Un3Ek/pO6FiNbOc9coBiQDyOsvGrgKiaXd56us
	 CGouBhGpB7WgX9JrDax5Q8884+AMyMIVoJQd8QOrkDZS8Eg/oh719TBeHFjlricliI
	 LkWso25u0AqELgIt8Wcsftlya26YOj5IEKG1Dytg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.4 107/121] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:33:02 +0200
Message-ID: <20240910092550.909500373@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

commit e240b0fde52f33670d1336697c22d90a4fe33c84 upstream.

To prevent unitialized members, use kzalloc to allocate
the xol area.

Fixes: b059a453b1cf1 ("x86/vdso: Add mremap hook to vm_special_mapping")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20240903102313.3402529-1-svens@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/uprobes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1491,7 +1491,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1501,7 +1501,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


