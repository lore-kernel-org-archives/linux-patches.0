Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F3F1774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791DBC433C7;
	Wed,  9 Aug 2023 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579469;
	bh=I3UXroALJLUEpABFaBQQqmNLj4WewaGE1AGtLJ8LP+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKcgs/awWwVnFGT6pRKBGrGPduOKDmbnNVv3yi1f7jommEVrOm/MG1zhFrRWaS4Kp
	 YN8BSI+t4HconWo20MiUpIJ8KS+N44zFsuQOIXLhWh4KatvaO7UwGHhKs7WxvQ+bza
	 V/I4TE5nz091XKj+6kdZ6rmupcMCuwPejdDX05Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M A Ramdhan <ramdhan@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 4.14 178/204] net/sched: cls_fw: Fix improper refcount update leads to use-after-free
Date: Wed,  9 Aug 2023 12:41:56 +0200
Message-ID: <20230809103648.460763089@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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
@@ -225,11 +225,6 @@ static int fw_set_parms(struct net *net,
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
@@ -248,6 +243,11 @@ static int fw_set_parms(struct net *net,
 	} else if (head->mask != 0xFFFFFFFF)
 		return err;
 
+	if (tb[TCA_FW_CLASSID]) {
+		f->res.classid = nla_get_u32(tb[TCA_FW_CLASSID]);
+		tcf_bind_filter(tp, &f->res, base);
+	}
+
 	return 0;
 }
 


