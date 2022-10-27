Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D258486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E3EC433C1;
	Thu, 27 Oct 2022 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890032;
	bh=Oi1jB9Jw+/DVaB0saZxYPOBsOtlsKlEB7czpAU3SAl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJASCkJJxS7Q8ccRq6LGan8puEHct64LIxueCZ4KaGtd6POSSB5R80LyOdREkOPS4
	 V320Hr+khBdx0aeob+RNiLwOyZuu4ZzLCcFQhP9i8Pv/2nADbNcUAhMQciLMRpl/uJ
	 wZCZmJecCwVf4tSDk1hMl8B+yhgbnO2jjEVO/Igg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 61/94] cifs: Fix xid leak in cifs_ses_add_channel()
Date: Thu, 27 Oct 2022 18:55:03 +0200
Message-Id: <20221027165059.637673173@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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
index 3af3b05b6c74..11cd06aa74f0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -496,6 +496,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		cifs_put_tcp_session(chan->server, 0);
 	}
 
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.35.1



