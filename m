Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD731885A6;
	Tue, 10 Sep 2024 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961181; cv=none; b=BakfzJN/sNfdAMYs64FG8gEfP9cIJ9pAFJM5rNuJEIMxCtS5duG1eMNhcvmp/eq6x73x8y2jv4x0C4yBq5uU4jUbWWgiC0ztkf9v07SzfDVTatQvHiVrWU5SCSKTVHDRN74GZDB3Al5U9deMhfwHHK11pZF/OghS+ZOL1qmxh34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961181; c=relaxed/simple;
	bh=njKAORXpojAd4nKLDq8fVHFfbeWrz5rfVgvgdUml9mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUysE4BZ2Owzr0rQeX5QvVFRF+F14fH3O1OjWDzTGPj+L3IS0eQCPQgp404rq92U+uQoQaBhCe3bGjRpPOT58IHbMGEN/J+c5GgosUGKbq2MYitda37qJ0ThW+oEsujICaLAExnq3qFNiGdPErnE3ty1REB7+AiYIy7SVT0hRhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi/FYENS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi/FYENS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42DAC4CEC6;
	Tue, 10 Sep 2024 09:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961181;
	bh=njKAORXpojAd4nKLDq8fVHFfbeWrz5rfVgvgdUml9mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xi/FYENSwmoJ7hnVUrDmiSZRi8VhFPNOWJiRE0i//77vqiW1FERR06inSEky8Nb99
	 PQonNkN0F4IKpIxfpuJqkYLoA/AnHkJF+pckZ3wuFscCjozk0wl/a6HWHMS+R6ybx/
	 QQzGI3u/9yTBLk1JELsLthGughhS2Cn5ua2NFiBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4.19 81/96] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:32:23 +0200
Message-ID: <20240910092545.095513530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1187,7 +1187,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1197,7 +1197,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


