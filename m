Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F47A143879;
	Wed,  3 Jul 2024 11:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005197; cv=none; b=NODIO+hLxeQORuvSqg+tmAJg2gznKA2qFX5PWMBUCjGOV11tydZXROAhvzN8py5JWYAIgp2i1Y147gQMjB0WhkHMyEwtOdOP6k4Q3ad20CyYVgIZYfILymKnXGz9GKIUKa4x2ghOiva7Zy7eirK5CnhovsoGUmwgCmQtVmlHEQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005197; c=relaxed/simple;
	bh=4ZI6HhbZr4UaLZCItFFTUD9tENwmgJ+/IBFGXPgPdQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQt681uPaUl4gjKt9U2kJovVnMGzF0MOU78dKGrlYIV8fJbVV42lZk8Z48HiWwhagl+EWQgY2TCIG6WkHCheINIyxdwI5B+a5I38RBpOl7yMwkhPlwd0R0Q0v8XuzHxk2gWZCdJ8Ji8foR9PqwsvNgCz1Q5/p0oume1ZAeOmdYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eu3mbMFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eu3mbMFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2681C2BD10;
	Wed,  3 Jul 2024 11:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005197;
	bh=4ZI6HhbZr4UaLZCItFFTUD9tENwmgJ+/IBFGXPgPdQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu3mbMFM8R3NMq0dH69wWj3/6Nh2Z2ZnMzWYSSKPZPr6sefEbboIqGr75mYtU/W6Z
	 0C2+IkmzeCvdDitG94c4d1MAmbqweUyvWckvnxxP5B8tYu9BIZAyNPoHnl0+WIA4t7
	 tE0zl2BAycs53eFw44Vu0Iqw8BbYPdAq5u6Du7Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 290/290] xdp: xdp_mem_allocator can be NULL in trace_mem_connect().
Date: Wed,  3 Jul 2024 12:41:11 +0200
Message-ID: <20240703102915.100475736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit e0ae713023a9d09d6e1b454bdc8e8c1dd32c586e upstream.

Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
pointer. This pointer is dereferenced in trace_mem_connect() which leads
to segfault.

The trace points (mem_connect + mem_disconnect) were put in place to
pair connect/disconnect using the IDs. The ID is only assigned if
__xdp_reg_mem_model() does not return NULL. That connect trace point is
of no use if there is no ID.

Skip that connect trace point if xdp_alloc is NULL.

[ Toke Høiland-Jørgensen delivered the reasoning for skipping the trace
  point ]

Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq reference")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/YikmmXsffE+QajTB@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/xdp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -356,7 +356,8 @@ int xdp_rxq_info_reg_mem_model(struct xd
 	if (IS_ERR(xdp_alloc))
 		return PTR_ERR(xdp_alloc);
 
-	trace_mem_connect(xdp_alloc, xdp_rxq);
+	if (trace_mem_connect_enabled() && xdp_alloc)
+		trace_mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
 }
 


