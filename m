Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8CD629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30547C433D7;
	Wed,  2 Nov 2022 03:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359552;
	bh=5qoyQAzGFb7N4gD268/IODBO7AMC5nuBzNAEBHo0qbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WsYI1XqciIGDXNFpe3wuM51cafj6TgjIR9DlFqulkED478zLOpZwj5aQgqT5KAw1
	 sH0zaVSLwkWPVw9aLrzZkrgq61Sgqkhw0nBFHRO9bm47P+y/87boVt7zXXVV6d3LAj
	 bEmhm14bHMAyV5pFua3V3KIhWug85xU0yZKUg45c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com,
	Thomas Graf <tgraf@suug.ch>,
	Aaron Conole <aconole@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 58/64] openvswitch: switch from WARN to pr_warn
Date: Wed,  2 Nov 2022 03:34:24 +0100
Message-Id: <20221102022053.688142235@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit fd954cc1919e35cb92f78671cab6e42d661945a3 ]

As noted by Paolo Abeni, pr_warn doesn't generate any splat and can still
preserve the warning to the user that feature downgrade occurred.  We
likely cannot introduce other kinds of checks / enforcement here because
syzbot can generate different genl versions to the datapath.

Reported-by: syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com
Fixes: 44da5ae5fbea ("openvswitch: Drop user features if old user space attempted to create datapath")
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Aaron Conole <aconole@redhat.com>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 41035ce0d23c..5dc517d64965 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1560,7 +1560,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb, struct genl_info *in
 	if (IS_ERR(dp))
 		return;
 
-	WARN(dp->user_features, "Dropping previously announced user features\n");
+	pr_warn("%s: Dropping previously announced user features\n",
+		ovs_dp_name(dp));
 	dp->user_features = 0;
 }
 
-- 
2.35.1



