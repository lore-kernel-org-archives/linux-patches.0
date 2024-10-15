Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE21210C32;
	Tue, 15 Oct 2024 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998535; cv=none; b=sKfv9ZAp4rbiPwJQEca+1igVWVH4gfYOyYEJxR/85QfaPCZ70/c76t9GftlB6GCjPFhBUjggb350ZjjBaOIZx+zM86VQqBMskihBC2DS+6ebFZAH02HoB9K29WWdDWdbkf88IkEAaDu86kkIrwTyY9FVGrfRHzzV8mMZSEXqToA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998535; c=relaxed/simple;
	bh=R+Y2snef3TslZN9Sr1WpZsDzJax6CbvyyPjQF4kSIfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tr/PDlqofn4TtaeP8xwas53wbfBpkkux26tFm07iZS309E146fFjx03c9NWYqve+47aOyv8Sv777ZInf9vWgV/4XNF0SWY9863cZseRKGq5I+kepxpOBNb5rtTM+uPy/wQkNKXM6nvbY9KnGe6UcDfVk681uyTlUphidsJyg7po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0G96hOAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0G96hOAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4332C4CEC6;
	Tue, 15 Oct 2024 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998535;
	bh=R+Y2snef3TslZN9Sr1WpZsDzJax6CbvyyPjQF4kSIfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0G96hOACE8P8FbL5wRpt51gf0SIRfu72NcvpR/0LdcpJ734dL3nrJOFEuu10V96oO
	 2qBwYe40rpBGr9UwUIrPEDjWWTBdM9Q68OFZTBS5J1pZ//+e0tQ02dC+Ay8Y5jizn7
	 4noGKg5R2bKiupC71aG7jSogcYmTx+c8OOYGgyjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 474/518] SUNRPC: Fix integer overflow in decode_rc_list()
Date: Tue, 15 Oct 2024 14:46:18 +0200
Message-ID: <20241015123935.301723740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
index db69fc267c9a0..c8f5a0555ad2c 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -372,6 +372,8 @@ static __be32 decode_rc_list(struct xdr_stream *xdr,
 
 	rc_list->rcl_nrefcalls = ntohl(*p++);
 	if (rc_list->rcl_nrefcalls) {
+		if (unlikely(rc_list->rcl_nrefcalls > xdr->buf->len))
+			goto out;
 		p = xdr_inline_decode(xdr,
 			     rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t));
 		if (unlikely(p == NULL))
-- 
2.43.0



