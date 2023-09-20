Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF522AB22
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ACDC433C8;
	Wed, 20 Sep 2023 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211687;
	bh=JWUeEW/2wRF3OVfZp0jr1Cn3NgJUpHDhxnwpwaB3IVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYC/1w/j7sl/Tlx8SJ7r3yKH4zXQXdjaNCwOTkYqDsUUrlVF2xKuGlWxyb4UVQsEE
	 D1c59L/Zdng6hBJqKDZ6yEWVNkZYCbxSVOpU/IuftP8mFhTbNZmqjVAts/E0NwETrq
	 ADRqh5+OwtJAKVpWBX63Y63bbe7CmTqzkrFpQd2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	M A Ramdhan <ramdhan@starlabs.sg>,
	Jakub Kicinski <kuba@kernel.org>,
	Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 4.14 185/186] net/sched: cls_fw: No longer copy tcf_result on update to avoid use-after-free
Date: Wed, 20 Sep 2023 13:31:28 +0200
Message-ID: <20230920112843.555347765@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: valis <sec@valis.email>

commit 76e42ae831991c828cffa8c37736ebfb831ad5ec upstream.

When fw_change() is called on an existing filter, the whole
tcf_result struct is always copied into the new instance of the filter.

This causes a problem when updating a filter bound to a class,
as tcf_unbind_filter() is always called on the old instance in the
success path, decreasing filter_cnt of the still referenced class
and allowing it to be deleted, leading to a use-after-free.

Fix this by no longer copying the tcf_result struct from the old filter.

Fixes: e35a8ee5993b ("net: sched: fw use RCU")
Reported-by: valis <sec@valis.email>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: valis <sec@valis.email>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: M A Ramdhan <ramdhan@starlabs.sg>
Link: https://lore.kernel.org/r/20230729123202.72406-3-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Fixed small conflict as 'fnew->ifindex' assignment is not protected by
  CONFIG_NET_CLS_IND on upstream since a51486266c3 ]
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_fw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -281,7 +281,6 @@ static int fw_change(struct net *net, st
 			return -ENOBUFS;
 
 		fnew->id = f->id;
-		fnew->res = f->res;
 #ifdef CONFIG_NET_CLS_IND
 		fnew->ifindex = f->ifindex;
 #endif /* CONFIG_NET_CLS_IND */


