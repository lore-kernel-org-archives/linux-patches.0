Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C51C0DFD;
	Mon, 14 Oct 2024 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919869; cv=none; b=DsRDKYuIWoLBwYOGvgV/H+ZCZra7ePaiMtq5A7tqD/0W+55ON3ac2UUHiU0Bxc4I5kAHqLrItA6DJclO4QnqQ5BkWY95EnzDCTUrw7j7m98VjSuGfvkZY7wxorGq6mC/tT4Kxv8k/RUGD96nJoQqvd9us+AsyNlLzMbjjBPVAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919869; c=relaxed/simple;
	bh=oBqs+yrF8OsmtRblPMZVsUx8vATfwx7LienMoXL2SpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1j7SZSb6D2eyX9T7OnMAxGy2hD4ZMvVIXq12eKOp21Q0F3c27Jr8B4sjyA+wfFSC/jpe0Hyl9Dedn43/VXrjv5WmIKOzd2bRDxGHKN9qAlVVTq/n8KrI8RuoAP3tlrX595ll9h9vGYp+gmhdARVJSdbCGIg6GJnfiKkg+JKZ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvBru0Dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvBru0Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B757BC4CEC3;
	Mon, 14 Oct 2024 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919869;
	bh=oBqs+yrF8OsmtRblPMZVsUx8vATfwx7LienMoXL2SpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvBru0Dw9grItS31upan01lRLIYFmFCykLswpEGmSzjKC90a6HK7JHdMYOmBI4kev
	 LEvByd6/3FuJkzqZeZ+ayX6c5OjuCfjLy2yPDhhKpGlWr4jIwMVBWeoFxkCtFomc8h
	 JhnqMVArwONootxseXAq3fBMy1BeTvWnIZ2U/vYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 729/798] SUNRPC: Fix integer overflow in decode_rc_list()
Date: Mon, 14 Oct 2024 16:21:23 +0200
Message-ID: <20241014141246.712328370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0cccddb7d088..fa519ce5c841f 100644
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



