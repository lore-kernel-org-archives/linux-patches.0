Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619A923A6;
	Tue, 10 Sep 2024 10:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965202; cv=none; b=gzU2FzXRJWjYkqrK+YeDZCURvWZzGaNQSzlcNENnG602jQwO2UIyt+5Stk2UVun6W6dBL848d3Jo47vGXbtaVAg6BViNaOVLPUXhW9xjJ4OPiyjxQLHqIDmJlOzqwPp91QdncC4OPYQyIXr1X0ZYG+fWJvDNSlykQwJ+uy8jr7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965202; c=relaxed/simple;
	bh=rgVHft18eEmAQwmUIIEHobNWIRSQS+ZD2EyxJXpMsJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdAvMQUfa4qjHxs+lvs5roLGZXyfZ98sB4B2I3tnrpq2RQFJWQ9DR6PIH3ufX495leyZIaimjuN2Wkn6DBZxQ6wli6ozawRT5J/165GuP+f/uyZ0z7NEIBbSfvZbv3Cq0uOemQL2vep4WtFaNvQi4gbPehXyH8g0Orf+D6m53XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEQ+2C20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEQ+2C20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF52EC4CEC3;
	Tue, 10 Sep 2024 10:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965202;
	bh=rgVHft18eEmAQwmUIIEHobNWIRSQS+ZD2EyxJXpMsJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEQ+2C201hpg8q5QQsAhVL5j40rRhk0pQ5Y2J8TYy+cRQmuqkmplMWLLi7ps9ReWV
	 zjLcpvl7PZ/hnCuZ+lndjsUO5u3eWlgSuGTQskJ55Y9cmY6beDkDMsVkhtWCziAZn9
	 utkBHxp2CJKuQlfwwMheyN7471wAtIQcI1zGoQX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.10 171/186] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:34:26 +0200
Message-ID: <20240910092601.664463581@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1485,7 +1485,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1495,7 +1495,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


