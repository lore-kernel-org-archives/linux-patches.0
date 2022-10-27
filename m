Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E60AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D426C433D7;
	Thu, 27 Oct 2022 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890172;
	bh=Xn75xEIOAju8zbTqT/LrTBiXrn1l6X2RK9VC5/E9egk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rro+06hcrZK9a5/MHUGBzPPUOKtWjC0O90JV5HtDoQ8Y2XT+1sog7NUAWQukwU0qw
	 3P591cedYUK9YRJZFRvX+dQLrS6TUEAhcYIvpCY3r2veaaCrPhJGq96ZZedySfZGyc
	 z4l+RgL0nt+tk8inTwRbHyorvybvFtaXRd5wINtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/79] cifs: Fix xid leak in cifs_ses_add_channel()
Date: Thu, 27 Oct 2022 18:55:47 +0200
Message-Id: <20221027165056.537401449@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit e909d054bdea75ef1ec48c18c5936affdaecbb2c ]

Before return, should free the xid, otherwise, the
xid will be leaked.

Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 5500ea783784..0fbd0f78f361 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -320,6 +320,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	if (rc && chan->server)
 		cifs_put_tcp_session(chan->server, 0);
 
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.35.1



