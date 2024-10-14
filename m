Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A581AAE08;
	Mon, 14 Oct 2024 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917073; cv=none; b=Os4vZGdkJwpVswa9b9igJKK9rWM31q03UMdB6kpkVbw4IvEPb/JPu/T7FbYd8m86dBR5oBG7RJLeP29a/yJohOMXlsUHwjMP+kUelxSNGnJLJXvaNh1MZZnDVxd0fM4q17kDJNSvf/9R8vK1gEUVg0bhjk5reLmM9H9FYw9rGxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917073; c=relaxed/simple;
	bh=E1weDg2EZMA9lN7g5A3EmlCtbnkG6jq86596Ips2chQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyr/asiO7J7/VzAwlSAlrWI0b6Yw6yOH4Jiqio1a8+ldk4EG8pyhbF+XqYLkt7pWWELOIXKOvML9jOoJ7gu0iGlMdYvUgndI6NmsrdXeGzUDtdo6J8T8V1grFlpJbyXNPEVF9ARhLDjGKhZC/J9Q9yVwli3nMqtEOPQbs3/3Z1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYRKSEZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYRKSEZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB66CC4CEC3;
	Mon, 14 Oct 2024 14:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917073;
	bh=E1weDg2EZMA9lN7g5A3EmlCtbnkG6jq86596Ips2chQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYRKSEZDSypHvZvp/K6ulNI3v7xxN34Wv4+2XL5efWejzS5BHrjUUmwq157S7UapO
	 qDBhG2XmWVsagC691TT+ihL35ARzsz6jEh5aI1Tu/y8px7aJS6gfMc2G6doucSDvKI
	 4kc9zBQ/ZS0ieJ/elKULc4HK05qNOKCbcItxZJVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/213] SUNRPC: Fix integer overflow in decode_rc_list()
Date: Mon, 14 Oct 2024 16:20:18 +0200
Message-ID: <20241014141047.339787255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 321af81c456e2..d5f6437da352d 100644
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



