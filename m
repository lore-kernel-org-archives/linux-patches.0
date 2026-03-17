Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43F23F54CD;
	Tue, 17 Mar 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766718; cv=none; b=Pm1RqLSX2+7Mo3bhT7667oQ2cLaS7a3uGaj8s0LGjTyCclqqfyfWyDDhA6sdnZpBA8/IKbdzDaLz9sgUpTA3fgOvPlneEPTfp84VYsBmcDaOa5hasTci9HizVObYq02AuByxVM136/KxbQO6uf9cd5YYeNxJRPqity8QCMapCiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766718; c=relaxed/simple;
	bh=yn46xAo5/YVb9aSQMbDY/jAseZjyBBN4VnPlPgriwpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/9ritrXTjMbcDhrDffOEyyj2UtRrviKAXdnTGn4LEokob2hF5YMDa0I9L/Icf/wIrEa3YUfAnMfhPFw2auGATzT0kYgZMvLidbRZxshLuWHlrcKoMusSVkVJvBafi1Tzf1vQg8UbA77E4NGUkQIEgJPhSPBzJVSXa7aOJAgDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioPjJEeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioPjJEeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E92C19424;
	Tue, 17 Mar 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766718;
	bh=yn46xAo5/YVb9aSQMbDY/jAseZjyBBN4VnPlPgriwpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioPjJEeQEFrGFegFTun2dqMEDwpl7v3OgnWG7CEEmBJrBxJH80eOBu81PfDmz3AKy
	 pvs/CTepO8Hhvea+Ni45FkW4bGKclY5WZ+SoDAakYsVIX48WC/BsGK6HIXtnoHy+bS
	 lQvsqThxq12mOCnUdFiXBuaqLOxjMma1KQyfIWjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 274/378] io_uring/zcrx: use READ_ONCE with user shared RQEs
Date: Tue, 17 Mar 2026 17:33:51 +0100
Message-ID: <20260317163017.088470256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 531bb98a030cc1073bd7ed9a502c0a3a781e92ee upstream.

Refill queue entries are shared with the user space, use READ_ONCE when
reading them.

Fixes: 34a3e60821ab9 ("io_uring/zcrx: implement zerocopy receive pp memory provider");
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -898,11 +898,12 @@ static inline bool io_parse_rqe(struct i
 				struct io_zcrx_ifq *ifq,
 				struct net_iov **ret_niov)
 {
+	__u64 off = READ_ONCE(rqe->off);
 	unsigned niov_idx, area_idx;
 	struct io_zcrx_area *area;
 
-	area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
-	niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
+	area_idx = off >> IORING_ZCRX_AREA_SHIFT;
+	niov_idx = (off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
 
 	if (unlikely(rqe->__pad || area_idx))
 		return false;


