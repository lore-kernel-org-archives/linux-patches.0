Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632CFB641;
	Tue, 16 Jul 2024 15:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144292; cv=none; b=SJGbvskw0x9/c8/mI8JEwreqdPW1NnEK1Oy7FPbS2JQEKe+h/yKDQQdflixlxnFZfxiE0AmZUGKROyWN1pGx673UMyWhPkgVoLaA1eyoJhveqCn7k1I5oMbryTwBRnYGlYGm/0sWuvDHw+lhwKxmf8kWCO36hqG1CNz6MwXWJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144292; c=relaxed/simple;
	bh=ElG4hQmQO5VQ13U8kuQsK+hMahOxHT2Du6Cw8kbSVWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLRuqRgnf/VgBn/8mGJLG/WewGs5iKSOQYXdmRutfJY6mCIwCzYhCNmiZaeyI1abjd3Ucco4wiVNqoKLTJvzb8/ggLKv6Mu/r6ewI/2yl6tS3FkwJjLpIYiSTjNnVdP+UL7A+vwqwUeV4yl32d4s5QzCxraEiq8dm3xqafiN5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmcfKjnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmcfKjnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A3FC116B1;
	Tue, 16 Jul 2024 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144292;
	bh=ElG4hQmQO5VQ13U8kuQsK+hMahOxHT2Du6Cw8kbSVWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmcfKjncIjN34xdripPzQHEXH6N6FLocGmfkK8eFMEESCk1OLrGHvkp2sPre0xaG+
	 WeZEzhbQcnEmOdVlLpY7JZWDortDh52NQwVo6zTUIHAmfcZbDVoeJY+0qkJoUBR55n
	 ++7Hi6wFJYPkzFP1RQrJSGopOshW4fEY0ldF+RMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Archer <erick.archer@outlook.com>,
	Xin Long <lucien.xin@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/78] sctp: prefer struct_size over open coded arithmetic
Date: Tue, 16 Jul 2024 17:30:41 +0200
Message-ID: <20240716152740.987768947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Archer <erick.archer@outlook.com>

[ Upstream commit e5c5f3596de224422561d48eba6ece5210d967b3 ]

This is an effort to get rid of all multiplications from allocation
functions in order to prevent integer overflows [1][2].

As the "ids" variable is a pointer to "struct sctp_assoc_ids" and this
structure ends in a flexible array:

struct sctp_assoc_ids {
	[...]
	sctp_assoc_t	gaids_assoc_id[];
};

the preferred way in the kernel is to use the struct_size() helper to
do the arithmetic instead of the calculation "size + size * count" in
the kmalloc() function.

Also, refactor the code adding the "ids_size" variable to avoid sizing
twice.

This way, the code is more readable and safer.

This code was detected with the help of Coccinelle, and audited and
modified manually.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments [1]
Link: https://github.com/KSPP/linux/issues/160 [2]
Signed-off-by: Erick Archer <erick.archer@outlook.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/PAXPR02MB724871DB78375AB06B5171C88B152@PAXPR02MB7248.eurprd02.prod.outlook.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cbcbc92748ba9..c188a0acfa594 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7158,6 +7158,7 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	struct sctp_assoc_ids *ids;
+	size_t ids_size;
 	u32 num = 0;
 
 	if (sctp_style(sk, TCP))
@@ -7170,11 +7171,11 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 		num++;
 	}
 
-	if (len < sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num)
+	ids_size = struct_size(ids, gaids_assoc_id, num);
+	if (len < ids_size)
 		return -EINVAL;
 
-	len = sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num;
-
+	len = ids_size;
 	ids = kmalloc(len, GFP_USER | __GFP_NOWARN);
 	if (unlikely(!ids))
 		return -ENOMEM;
-- 
2.43.0



