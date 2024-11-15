Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3804C29A9;
	Fri, 15 Nov 2024 06:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653165; cv=none; b=j7uJAWF9LwQpckbGOpFkO5o3mgpgz31h89YrwhMhFtvUnrz+oIwUgvhoqZYc+/S5lalagZaFDH08wNkJDV4kp3tt0UVfFr5loAl+eyXo1bv5fyxScGu2GZtmamYRgEzJAwW4yty32zfmmedxNOCA2WnExLdYAA5b95itXvyJHPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653165; c=relaxed/simple;
	bh=OFfib8Dd4e7MzgNCiBZHNMN+l4fNOfqU/zE+gzkyGTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFA5kcuLKrfOmg11+y0+H6qe833QrL5C2JevqOVTjlEAKoxkoQhca1BL+76NSPP6hP2yObgI9xGIAfztZeHt1Wn6ElrCzXzBGuJ5oCrJprJLhNzMWUNiY9aW2KBX9TQA7G4hZ0KZPgKaLO37p+KLtWYC9reDiA4m3oMuf8xuoW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAs7N0Fu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAs7N0Fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3B3C4CECF;
	Fri, 15 Nov 2024 06:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653165;
	bh=OFfib8Dd4e7MzgNCiBZHNMN+l4fNOfqU/zE+gzkyGTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAs7N0FuxIsg1g6O3bd9GPYL5gjhDQA8JXXK/hTkLJodEovX60SpzCpiMJF2DTqyO
	 aT8TEtAn5xgfnDDQNMe+OkwnewTaOQT4wwBlSEVlzt0l8z+QDD4dV3vyJ+4RbPIsHy
	 +3tvmnrhFJ0fx9xOqjfcN+v+Xftyxk7tKTBeOvjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pedro.falcato@gmail.com>,
	syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/66] 9p: Avoid creating multiple slab caches with the same name
Date: Fri, 15 Nov 2024 07:38:03 +0100
Message-ID: <20241115063724.791634850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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
index 2b54f1cef2b0d..0f5db1f414be1 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1003,6 +1003,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	int err;
 	struct p9_client *clnt;
 	char *client_id;
+	char *cache_name;
 
 	err = 0;
 	clnt = kmalloc(sizeof(struct p9_client), GFP_KERNEL);
@@ -1055,15 +1056,22 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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



