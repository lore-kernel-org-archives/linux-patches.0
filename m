Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968C1DFFD;
	Fri, 15 Nov 2024 07:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654054; cv=none; b=gaQ1CrtE9jrWbh+20UmS+nk8G95BfAtcRP94XbDls2AH3xzkcZ0E0FU98pfwZINPUl5zlIwxjLb8lSFeKVwZP2EDFVRXaNHSpynh7vXSFxp43+15xHXEEtBpNeZIBmj6GXVBR9suIyzBtaJZnXZ19tMFFUGL8VuIki2C/x3I5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654054; c=relaxed/simple;
	bh=u+ihKTzTWAKp/o46Y+Niyb5N+sb8GrgldaqleHaUfJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB3hMj9Xl5FUgKypEn1xE3598+SpXI3/c0h7PkXZro4VtYd42a7BRLPEYkFP+JNcD3H0ddS6rTJRFSaUsv10mOfDBsUdmuA2x+VsgHJw8CbME5odHE7c/qQUEPPVn357dierPeJ7B3Ub7A/QXOmHH2+IKQflgojZYVDRE7T0jCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBIuJXuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBIuJXuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8389C4CED2;
	Fri, 15 Nov 2024 07:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654054;
	bh=u+ihKTzTWAKp/o46Y+Niyb5N+sb8GrgldaqleHaUfJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBIuJXuo09F4Rdl/R1o5/2O/6xvvPTtnpgdaUTUYZ4yZlU0RQjzJwdyNqaBROGYW2
	 lDMrzLzxvbyqskpRviWKqdnNybBn3nfICiDjzE/YeFxcQsrNldRJrgdByzo6BnKOSh
	 6GGHJRur0OAZz+YShwY/QS6yuVvKmd8N4r+LpBR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pedro.falcato@gmail.com>,
	syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/22] 9p: Avoid creating multiple slab caches with the same name
Date: Fri, 15 Nov 2024 07:38:47 +0100
Message-ID: <20241115063721.227517461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pedro.falcato@gmail.com>

[ Upstream commit 79efebae4afc2221fa814c3cae001bede66ab259 ]

In the spirit of [1], avoid creating multiple slab caches with the same
name. Instead, add the dev_name into the mix.

[1]: https://lore.kernel.org/all/20240807090746.2146479-1-pedro.falcato@gmail.com/

Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reported-by: syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com
Message-ID: <20240807094725.2193423-1-pedro.falcato@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index bf29462c919bb..03fb36d938c70 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1005,6 +1005,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	int err;
 	struct p9_client *clnt;
 	char *client_id;
+	char *cache_name;
 
 	err = 0;
 	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
@@ -1057,15 +1058,22 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto close_trans;
 
+	cache_name = kasprintf(GFP_KERNEL, "9p-fcall-cache-%s", dev_name);
+	if (!cache_name) {
+		err = -ENOMEM;
+		goto close_trans;
+	}
+
 	/* P9_HDRSZ + 4 is the smallest packet header we can have that is
 	 * followed by data accessed from userspace by read
 	 */
 	clnt->fcall_cache =
-		kmem_cache_create_usercopy("9p-fcall-cache", clnt->msize,
+		kmem_cache_create_usercopy(cache_name, clnt->msize,
 					   0, 0, P9_HDRSZ + 4,
 					   clnt->msize - (P9_HDRSZ + 4),
 					   NULL);
 
+	kfree(cache_name);
 	return clnt;
 
 close_trans:
-- 
2.43.0



