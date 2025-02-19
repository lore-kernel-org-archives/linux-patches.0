Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3A71DED45;
	Wed, 19 Feb 2025 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957215; cv=none; b=bSqG3OfmtBkWg26Q3yZy6kJwajV+cx+rmMMGyv0qD5arWFZAzBw35lLrIjQnBPi6+M2GEjILXrrNImbM9nX+aToWbSS+jUO+pQjHiemloi6HMmQVoXTQl9/eDOgJsSJBDxMEDRzKONcIkpYg3EHuh7FDT5/AphC39oxGvuukvbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957215; c=relaxed/simple;
	bh=ACaNM2QJPRrTcVKG5TNilJwSfs3tYbx3b8eUcD6DKQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3QeLU57Jthe3HMsb5lZYpm5a7IEnIJUj1hQ3QmkLTKLNCWJhHt1btDCJboihR+ECKwwq5kPnPKInbWpVh/nEMcCW/hm9SPuWM7LTFrEQ2cufOn5PZY0u0A6cQ+o7x3kijokK+dGn0f3Fv+0gtPCdVEOotBWNtysvov0yP1ii1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmfQx1S9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmfQx1S9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FDAC4CEE8;
	Wed, 19 Feb 2025 09:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957215;
	bh=ACaNM2QJPRrTcVKG5TNilJwSfs3tYbx3b8eUcD6DKQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmfQx1S9Vj5BNQea+rFga3e6R73e0M2rUZa9bdlk/TRtMuGZUP3bNnfXU0t9h7bAW
	 SiL9tCl138WwoQ2SAFI48oi2VxLZkIIEtQHz0m0l59ZdnNVG8T5Czs7hAv+lXsfMDg
	 HYv/oZzx6hwHVHBZC7NQMxkjHGX3G8rgyvfp0Wng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.1 447/578] io_uring: fix io_req_prep_async with provided buffers
Date: Wed, 19 Feb 2025 09:27:31 +0100
Message-ID: <20250219082710.579320710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

io_req_prep_async() can import provided buffers, commit the ring state
by giving up on that before, it'll be reimported later if needed.

Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Fixes: c7fb19428d67d ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1624,6 +1624,7 @@ bool io_alloc_async_data(struct io_kiocb
 int io_req_prep_async(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
+	int ret;
 
 	/* assign early for deferred execution for non-fixed file */
 	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE) && !req->file)
@@ -1636,7 +1637,9 @@ int io_req_prep_async(struct io_kiocb *r
 		if (io_alloc_async_data(req))
 			return -EAGAIN;
 	}
-	return def->prep_async(req);
+	ret = def->prep_async(req);
+	io_kbuf_recycle(req, 0);
+	return ret;
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)


