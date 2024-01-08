Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70314B5AE;
	Mon,  8 Jan 2024 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/tTHnLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F2CC433C9;
	Mon,  8 Jan 2024 15:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726650;
	bh=d28UH698R2I664SYZuoG/rDLlxvy/ndx84wLiEaNw9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/tTHnLbNBpkpUHbkUf2JAHC7QkLPKeXuBBYaNld2Ia9YfA7f5Tx4BcY0qgh1DVvW
	 hwYlhDK+YHgx4RGKkJC6pgbpbcJtRtqiAQKUTXtKNYKuNe02714Fa0ENTRelbs7AQP
	 x8l3qRDuEokzxT9xiOxZKewGEh0EpfPpdGa/Agog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Hangyu Hua <hbh25y@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/124] net: sched: em_text: fix possible memory leak in em_text_destroy()
Date: Mon,  8 Jan 2024 16:07:41 +0100
Message-ID: <20240108150604.587928007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 8fcb0382af6f1ef50936f1be05b8149eb2f88496 ]

m->data needs to be freed when em_text_destroy is called.

Fixes: d675c989ed2d ("[PKT_SCHED]: Packet classification based on textsearch (ematch)")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/em_text.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/em_text.c b/net/sched/em_text.c
index 6f3c1fb2fb44c..f176afb70559e 100644
--- a/net/sched/em_text.c
+++ b/net/sched/em_text.c
@@ -97,8 +97,10 @@ static int em_text_change(struct net *net, void *data, int len,
 
 static void em_text_destroy(struct tcf_ematch *m)
 {
-	if (EM_TEXT_PRIV(m) && EM_TEXT_PRIV(m)->config)
+	if (EM_TEXT_PRIV(m) && EM_TEXT_PRIV(m)->config) {
 		textsearch_destroy(EM_TEXT_PRIV(m)->config);
+		kfree(EM_TEXT_PRIV(m));
+	}
 }
 
 static int em_text_dump(struct sk_buff *skb, struct tcf_ematch *m)
-- 
2.43.0



