Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DD22550CF;
	Mon, 23 Jun 2025 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685412; cv=none; b=d67Zl/h5gHfYQ+MHS2uccNcN8m5KFrD6KDIzUIxAHCw4G0CpGlCJs/k6GNGY1X6jtK3fLBsfOWeFtkmsUkeULiO+xVuVgej1x2s+PBo0B43x2IoLk3hh3ByxhnNScjSqI1yjFojEVYys4Xq6ZYDN+uHAtrt54MqeR0uGV6ZMib0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685412; c=relaxed/simple;
	bh=vtXEEAFGflJ+Z6K+yZvZuycwBQe0iakKewGJLmjon68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUHNgD3wj9PdoW8e79loG+b+CwxJjqQ6L0OgbO1WwcWWHanI6Ugbs9Fv4SNRDlJl5rMt2HnsDbqQ2HaNOGubLMI7Z4WXs927iMmdel0Bdlb0yZIuhKwTT94swng60U/1fp3YlR/Y6cquuDrr/B2lRaNdqaNhWLs1g6uC4gooPig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GedZY+eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GedZY+eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D992C4CEEA;
	Mon, 23 Jun 2025 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685412;
	bh=vtXEEAFGflJ+Z6K+yZvZuycwBQe0iakKewGJLmjon68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GedZY+eZQoc0PZEFRNvStUrgWhmFLI92mui9lDmYbmcT4Cux7nSBdIB9D/sD8bcf5
	 r3KGWOTYzUzFTxrFrrjVpm3B35xQnAI6aq7gtXoaCxgQtosnqZxGPr7QTcPxTXXluy
	 IfvOjgid5NbW9s6AzqC191Ssx8lTmJE53oKJgBEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 006/290] io_uring: account drain memory to cgroup
Date: Mon, 23 Jun 2025 15:04:27 +0200
Message-ID: <20250623130627.144078049@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit f979c20547e72568e3c793bc92c7522bc3166246 upstream.

Account drain allocations against memcg. It's not a big problem as each
such allocation is paired with a request, which is accounted, but it's
nicer to follow the limits more closely.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f8dfdbd755c41fd9c75d12b858af07dfba5bbb68.1746788718.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1808,7 +1808,7 @@ queue:
 	spin_unlock(&ctx->completion_lock);
 
 	io_prep_async_link(req);
-	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		ret = -ENOMEM;
 		io_req_defer_failed(req, ret);


