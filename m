Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229223B42CB;
	Tue, 21 Jul 2026 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666764; cv=none; b=XoFhciVTsT3F/1AjBddFuIxPSlHvAp9mnKnBJEJ7f3Mqq0AB3KZ8GbaTa1jzfrXiyHM1Ry/SB9d7Bug4Qv3z1x4nkItWKxEJXFXqof/GDu95a/SOpriQLZmPBwR9Ly+db4yUnrjkYBhvhNadcttBxFmUMBc+95QHZz/keOyF80o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666764; c=relaxed/simple;
	bh=zkEuwOAXu6QaJxrFthjuRrxvXdwiRRKfO3DSrSbe3C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKfCV33faRnYDCd6rKDr1xoMmkOdvBtOI6wnzrdr0rcI1SSRd6LNWgH1pesn0MilvK1J52hO7YFWP+aF0IhtyrvzPzgjPgA46kFI+vW5ue1kv7ykreUmxyJbgH1f4l1YkO8y0xjNkaq2Dbabko/1rVnyLCAwYwlMf12bWoieeTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5vIf7Kf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5vIf7Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B4D1F00A3A;
	Tue, 21 Jul 2026 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666763;
	bh=81dO1PJXhudRjswO3mGBWtvFD9zKypu5Qp6GvGGr9PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5vIf7KffZZ3ag86aLGKb18AUyEI/zdcopC51eWHaMX23c4vE3z9+cgyJs3iCX6al
	 81Imj+31sbtLO8ebfnOK3ca6NzGwCTsjtt6UKnxml8MPNmuk+idSToeH+bUly2R4q/
	 8EXzfOfKr+yjvAsZR//1oQI4hK19XwFTwHxPME1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0806/1266] sctp: fix SCTP_RESET_STREAMS stream list length limit
Date: Tue, 21 Jul 2026 17:20:43 +0200
Message-ID: <20260721152459.895325310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 2b9f5ef534184bd81b8a4772780626c40eed1fd5 ]

SCTP_RESET_STREAMS carries a flexible array of u16 stream IDs, but the
optlen clamps treat USHRT_MAX as a byte count and then multiply
sizeof(__u16) by the fixed header size.

That caps the copied and validated option buffer at about 64 KiB, which
rejects valid requests containing more than about half of the u16 stream
ID range.

Use struct_size_t() for the maximum struct sctp_reset_streams layout
instead, so the bound matches the flexible array described by
srs_number_streams.

Fixes: 5960cefab9df ("sctp: add a ceiling to optlen in some sockopts")
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260625142354.2600-1-alhouseenyousef@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 890c587ebe2745..4cc73e7b3c2aae 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4110,8 +4110,9 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	if (optlen < sizeof(*params))
 		return -EINVAL;
 	/* srs_number_streams is u16, so optlen can't be bigger than this. */
-	optlen = min_t(unsigned int, optlen, USHRT_MAX +
-					     sizeof(__u16) * sizeof(*params));
+	optlen = min_t(unsigned int, optlen,
+		       struct_size_t(struct sctp_reset_streams, srs_stream_list,
+				     USHRT_MAX));
 
 	if (params->srs_number_streams * sizeof(__u16) >
 	    optlen - sizeof(*params))
@@ -4597,8 +4598,8 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	if (optlen > 0) {
 		/* Trim it to the biggest size sctp sockopt may need if necessary */
 		optlen = min_t(unsigned int, optlen,
-			       PAGE_ALIGN(USHRT_MAX +
-					  sizeof(__u16) * sizeof(struct sctp_reset_streams)));
+			       PAGE_ALIGN(struct_size_t(struct sctp_reset_streams,
+							srs_stream_list, USHRT_MAX)));
 		kopt = memdup_sockptr(optval, optlen);
 		if (IS_ERR(kopt))
 			return PTR_ERR(kopt);
-- 
2.53.0



