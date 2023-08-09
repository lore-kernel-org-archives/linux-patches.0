Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E417AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0821C433C7;
	Wed,  9 Aug 2023 11:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580254;
	bh=uNcZl0PnwTKu+5JjANOE9jF+i4lzvHYeRu4CfuqlW5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSe5YbOmajy6oncQUP0SQbU0rglBRVr6dQUkAsnj8zuhOjrPeOZ2RBcjDTiL0o7tZ
	 M9lZ15rrcYJRd0EJocr6us9G776PmQyzPFvjrS/TauJEmdqTkeWLLqyrcZC1stHHgc
	 WmgTRCSxVKF5qx9t+y3jdsz0tmJuUbbQGw13vEhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M A Ramdhan <ramdhan@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 4.19 283/323] net/sched: cls_fw: Fix improper refcount update leads to use-after-free
Date: Wed,  9 Aug 2023 12:42:01 +0200
Message-ID: <20230809103710.997747756@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: M A Ramdhan <ramdhan@starlabs.sg>

commit 0323bce598eea038714f941ce2b22541c46d488f upstream.

In the event of a failure in tcf_change_indev(), fw_set_parms() will
immediately return an error after incrementing or decrementing
reference counter in tcf_bind_filter().  If attacker can control
reference counter to zero and make reference freed, leading to
use after free.

In order to prevent this, move the point of possible failure above the
point where the TC_FW_CLASSID is handled.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: M A Ramdhan <ramdhan@starlabs.sg>
Signed-off-by: M A Ramdhan <ramdhan@starlabs.sg>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Message-ID: <20230705161530.52003-1-ramdhan@starlabs.sg>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_fw.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -221,11 +221,6 @@ static int fw_set_parms(struct net *net,
 	if (err < 0)
 		return err;
 
-	if (tb[TCA_FW_CLASSID]) {
-		f->res.classid = nla_get_u32(tb[TCA_FW_CLASSID]);
-		tcf_bind_filter(tp, &f->res, base);
-	}
-
 #ifdef CONFIG_NET_CLS_IND
 	if (tb[TCA_FW_INDEV]) {
 		int ret;
@@ -244,6 +239,11 @@ static int fw_set_parms(struct net *net,
 	} else if (head->mask != 0xFFFFFFFF)
 		return err;
 
+	if (tb[TCA_FW_CLASSID]) {
+		f->res.classid = nla_get_u32(tb[TCA_FW_CLASSID]);
+		tcf_bind_filter(tp, &f->res, base);
+	}
+
 	return 0;
 }
 


