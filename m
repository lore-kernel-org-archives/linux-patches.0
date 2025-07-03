Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3932EF9DA;
	Thu,  3 Jul 2025 15:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556299; cv=none; b=CNzA+R+E+ymTxHLM9C6TaGz9Rq6orY9kU1WuVbLtIKuISQ8+5XeF7NMTDFV1fBnzpBu1EWXEbnKDZwXIN0kU37mhFlFotAOonPXkpciYjouDKfoHTfmn51yNtVuWeE/l0DualFj6AwVr7TBKZveIaRAyDVCr95jn3FTndpQekQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556299; c=relaxed/simple;
	bh=PstK0B52w8fIGUK9yyYvjtWCAcDojQ3nFZ/BE6jDNcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJWWk5AhjHXJXxiO1r113K/VDctxtPTWABkCnPONXiXREwdCVJeXCGDWZYyUKbyE+9yPEZaW+PWQw6PXQM/TMhBMjderSeMkbxKNMXT6NtuBFPRiqXfN5NSFKFLiywzaTjwAGv6CIzQHbw6Vvx27Hf7z8dggNBvHpMEl4OMI9/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFZu+o8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFZu+o8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4793C4CEE3;
	Thu,  3 Jul 2025 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556299;
	bh=PstK0B52w8fIGUK9yyYvjtWCAcDojQ3nFZ/BE6jDNcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFZu+o8D0Xxu1BzvYys6RLPAgBz5F5557CEqxJgV5s+NTwlKqUrWsAp0KiChwdqzW
	 tNHdw+pWfwjm58MEwPvp/by7ddHqJ9bDRArDg5lQx3itKvgCBT7LYJO7ydpT61L4bV
	 5e/ynwLFW22pLZ23HYP86sKFklJd8qzEpP7LTEiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 129/132] io_uring/kbuf: account ring io_buffer_list memory
Date: Thu,  3 Jul 2025 16:43:38 +0200
Message-ID: <20250703143944.452408800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 475a8d30371604a6363da8e304a608a5959afc40 upstream.

Follow the non-ringed pbuf struct io_buffer_list allocations and account
it against the memcg. There is low chance of that being an actual
problem as ring provided buffer should either pin user memory or
allocate it, which is already accounted.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3985218b50d341273cafff7234e1a7e6d0db9808.1747150490.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -510,7 +510,7 @@ int io_register_pbuf_ring(struct io_ring
 		if (bl->buf_nr_pages || !list_empty(&bl->buf_list))
 			return -EEXIST;
 	} else {
-		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 		if (!bl)
 			return -ENOMEM;
 	}


