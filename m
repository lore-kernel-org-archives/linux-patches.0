Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C168489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC310C433EF;
	Fri, 10 Mar 2023 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457775;
	bh=r3R0pKyDDLULWjJjRmPaBgwtEd0dbnEJV2wAA1P6tEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V++u5FxOvVpcNnsTLx1QWgVjXruNQmfQ4npAJDtuQCVfvfVRwTFr8OX2SHu4G5GtQ
	 Epa39JvA7mkVV51j/VZCrgaLhgd1ZvESJuOS5u2oCk/3XsiiEGiScJ1qkfJ7HXWti/
	 e2uHjE47flyUiAtDtgyOZiXCZAgc5ZIdxyKhg1kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/252] libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
Date: Fri, 10 Mar 2023 14:37:02 +0100
Message-Id: <20230310133720.384966750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 17bcd27a08a21397698edf143084d7c87ce17946 ]

The code assumes that everything that comes after nlmsgerr are nlattrs.
When calculating their size, it does not account for the initial
nlmsghdr. This may lead to accessing uninitialized memory.

Fixes: bbf48c18ee0c ("libbpf: add error reporting in XDP")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230210001210.395194-8-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/nlattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 4719434278b20..ac979b4290559 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -170,7 +170,7 @@ int nla_dump_errormsg(struct nlmsghdr *nlh)
 		hlen += nlmsg_len(&err->msg);
 
 	attr = (struct nlattr *) ((void *) err + hlen);
-	alen = nlh->nlmsg_len - hlen;
+	alen = (void *)nlh + nlh->nlmsg_len - (void *)attr;
 
 	if (nla_parse(tb, NLMSGERR_ATTR_MAX, attr, alen, extack_policy) != 0) {
 		fprintf(stderr,
-- 
2.39.2



