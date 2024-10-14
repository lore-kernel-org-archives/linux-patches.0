Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747581547F3;
	Mon, 14 Oct 2024 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916118; cv=none; b=ia9Rq6SVTG3I1baKv/hWXdqr54dzEg/J/vRpS3n8hgNZFen4oqGFvz66Ek6twO8WnTnVt8GdHupHykmUzg1ry71/psFyHYBRA5T8QXJ0tTU2ElXP1JxCEQY3x2srAw+/6F9yXKoMh+OuKG3kXGHqXkHI7V/ztUxJN/0syvoWI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916118; c=relaxed/simple;
	bh=NcqJFnape+HNKi/YWFKxI0Hns4w05t/CWSWWDpqlNr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMKieevHSa9ZtWFmYqgW8xo+tP978iH5NwjSQ4GoNNUlWdMqUZTq2jt//VsIbVGG8JYPM8HWeVColGoxK/go+6Y884Z8591cz3vYxMRnBTMJ0B1EVEnC9PMg/kWcm4EvkvQWX3AsH9Pv1LWlV0z3Z5ju/VvgS1DLYvvv4OIx3I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLSdvQL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLSdvQL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B80C4CEC3;
	Mon, 14 Oct 2024 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916118;
	bh=NcqJFnape+HNKi/YWFKxI0Hns4w05t/CWSWWDpqlNr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLSdvQL4WcFQ7S9+0Qak7zpOKLdvk9HBzUJn7xPWPoLax/nwUuhAeF6gEszTVCqw8
	 ptipnx6oaZ3Dmew64a0PvKQTn2jMzN/hG6BhcAN7qlU35TZvpogeGuIC1nnr3dfhdj
	 9RQEZuJuBTG6xrzp2xHveNDPQzND/1lXxEmPlbVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 088/214] SUNRPC: Fix integer overflow in decode_rc_list()
Date: Mon, 14 Oct 2024 16:19:11 +0200
Message-ID: <20241014141048.428854478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6dbf1f341b6b35bcc20ff95b6b315e509f6c5369 ]

The math in "rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t)" could have an
integer overflow.  Add bounds checking on rc_list->rcl_nrefcalls to fix
that.

Fixes: 4aece6a19cf7 ("nfs41: cb_sequence xdr implementation")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 6df77f008d3fa..fdeb0b34a3d39 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -375,6 +375,8 @@ static __be32 decode_rc_list(struct xdr_stream *xdr,
 
 	rc_list->rcl_nrefcalls = ntohl(*p++);
 	if (rc_list->rcl_nrefcalls) {
+		if (unlikely(rc_list->rcl_nrefcalls > xdr->buf->len))
+			goto out;
 		p = xdr_inline_decode(xdr,
 			     rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t));
 		if (unlikely(p == NULL))
-- 
2.43.0



