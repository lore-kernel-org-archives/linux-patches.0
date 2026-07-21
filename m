Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310293A4F4B;
	Tue, 21 Jul 2026 19:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663222; cv=none; b=dySteiRdJ+jax2bZ1u2nCI9XupCXW/lLtOq/r4bF8bct8+5CfT2UGuzhc5bwZas81MXwXlK7APQ6b4mpo0wmOVC7m9YuKYSrkhMzeq7jEC47H0GF1ACESOySoxmjNSw7VcYZ9H2Y/9nIggDTp9YbM6AgSUnXSbXQjr5hOVK3CiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663222; c=relaxed/simple;
	bh=F5xO2H8Q5O3fmvbNqqobI9zpxIgs0oYGB1gJswT1c1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjCbf/vindNjTb2aULXE3LQ+UbM2CpA3kVzE5fsgaoMkyjgps3nmQTAlQSjTUq1yHBYgblf3EOYKOjCY5xK15USRzHfxIjnTwApRauhP1nhpP6RNKPuQA702avBkIex/V7vnMoMJNnY4J6nWd76JhIFq1hP1xBeTyBEWagA8JC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WE2aSoAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WE2aSoAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2D61F000E9;
	Tue, 21 Jul 2026 19:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663221;
	bh=MIx/08xgjVCGOtgsQIG0SdjV1EqDSaSsoWDeuhG5F8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WE2aSoAN/OQEOjDs+u9pZ5ej6E+QEgTptqA4DwLHKnB5uxPwQ2hTEi45wkFn4adx3
	 9TtzlqU7Zq3BlJg3vyTt72yExVo/FoCJZ7YsXPgMKoEEx6fZryrcw6ILZWT2jOb6zv
	 SAIF/vBxIs3VqEfsQGioCVd739xMc/d20E+mZFGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0697/1276] sctp: fix SCTP_RESET_STREAMS stream list length limit
Date: Tue, 21 Jul 2026 17:19:00 +0200
Message-ID: <20260721152501.692936080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72450359ccec89..4e09c01c7109d4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4111,8 +4111,9 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
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
@@ -4598,8 +4599,8 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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



