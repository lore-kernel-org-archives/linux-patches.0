Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49644187FE8;
	Fri, 15 Nov 2024 06:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653236; cv=none; b=CsI7xHOr0Ay63oeU+6fmBSVQD8/1b6zIFyo/lXKw5V7CmnL4PjuiD0n1zWvEJ/puKN93f3CIjJAVhvMqRA1jPCqRf9eCuHw0gNp9oRWQayPKtoPgw4uk8Hc6R39d/u60k8dnQoUtMUF6cKV96MC5Xr2e5Rw5FbyFARdqZw7ArIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653236; c=relaxed/simple;
	bh=EuiCE3dMBRJtUdjjnL+3Cb5zJs8yDKglclt2ncj7mII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kztvCrnsHLEYy8G+4VkJ7+JLpQ9O1mpC1F4jafr+ffkAD8eI36ZgpsMJ9rbAck6f8nBxdhbEjVPDkT8gUtz5WbRCOxGCpY8tPNELe4BA3kuVYVx7RVIoDMcuM/lBSWW9ljyxBWviA/6uCV12tP1SN5eBimOmZCwfPNkZMu42EJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQRnZHR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQRnZHR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC50BC4CECF;
	Fri, 15 Nov 2024 06:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653236;
	bh=EuiCE3dMBRJtUdjjnL+3Cb5zJs8yDKglclt2ncj7mII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQRnZHR3EKQouRMMVTUVyDeY3QcU7e95mz/tDBQLw5jU8pKmhDkdANNG3X72wsNK8
	 v0YF15nKIWwg37s9/0lcwsq0B3gI0AK/MYf78rEXHaBPqwqK043isCEbfs0l9btHcY
	 s65aQpihxFAN8fQyf3uwFxDboMUS77n6Qef5z5ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pedro.falcato@gmail.com>,
	syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 04/63] 9p: Avoid creating multiple slab caches with the same name
Date: Fri, 15 Nov 2024 07:37:27 +0100
Message-ID: <20241115063726.054840245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5cd94721d974f..9e7b9151816d6 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -979,6 +979,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	int err;
 	struct p9_client *clnt;
 	char *client_id;
+	char *cache_name;
 
 	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
 	if (!clnt)
@@ -1035,15 +1036,22 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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



