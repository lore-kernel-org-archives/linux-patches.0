Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0941B46D2D1;
	Tue, 21 Jul 2026 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657951; cv=none; b=DUaJ9ig7XUCpcIzWpKw9pLh0330gpA4TrByNJi+Ru+yV+mTUYZsBxgd/k7EyFCdFmtyIw+za24fAcH6IkViZOzsaHWmDghAK1ic4Sztok+2WN5h+IaTH6gOayNP2VHd1x6J1TDRyQhdf4kC14kRG2dvahK6Jxx8F8rsbUUX60/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657951; c=relaxed/simple;
	bh=mmeyquYwE/MZt99uD00NdCxBt9Yv/QjtzzY9ieJGJZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecZlMMmV7cXI/YbUJJQ8HAXz70P7+F//ysHCV9653fxWiqHDpztEWu2nA3cx38sI3+1fN+UhY9SJH5+gvNW9orUjMWO7znM5k8YiTpXaTnRCw3l1VN2b31suVb1g52XcP1gHIaGTPkE0MAAs8tFc7MfTyafIBaR3LeTlsDq+oRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYBK5p2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYBK5p2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FDE1F000E9;
	Tue, 21 Jul 2026 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657949;
	bh=XE3ek540RNu3OwBD0WZHjCFl8OpJKM4jvajHmhSIo18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYBK5p2DiHjt6wDFkrB7TFBdE8VzS51wjrYJF00wgD7qqXK4AhexueItV5M8uL/wD
	 N/Ios92Rvg+WFqJmi8wxSnA6dIR5oqWG/Iub8o4HmVsmXf2im5gAM+fqxzbOxKiFvE
	 LqrUeOcO49I3VghqGk20PBF3Gl89l8od+ivqb3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0958/1611] sctp: fix SCTP_RESET_STREAMS stream list length limit
Date: Tue, 21 Jul 2026 17:17:54 +0200
Message-ID: <20260721152536.941331804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7a641cb8473840..b4f706a975be27 100644
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



