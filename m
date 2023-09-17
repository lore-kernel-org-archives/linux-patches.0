Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA6E7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB346C433C7;
	Sun, 17 Sep 2023 20:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981192;
	bh=X2wAVo7GHBGy4oZqukGHgXMCIn7fkFaYv+ySoyubsCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPfs4e5ykjnBvtDGeoRAM2lhSYQXIYO7O8HAdxw1TQkSbFdh7cTZDNn9Kcwwne/bu
	 VUbP1JGKhXhacPVFM6d9X0qfvScT7n268JTPncmxXygBBMqmEGRrGQZOsiq9Fpp6Yx
	 PtaVscTHCLuutWLgNUKQw8F/E1Wil8F+uywe3/Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Winston Wen <wentao@uniontech.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Christian Brauner <brauner@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/511] fs/nls: make load_nls() take a const parameter
Date: Sun, 17 Sep 2023 21:07:25 +0200
Message-ID: <20230917191114.271371678@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Winston Wen <wentao@uniontech.com>

[ Upstream commit c1ed39ec116272935528ca9b348b8ee79b0791da ]

load_nls() take a char * parameter, use it to find nls module in list or
construct the module name to load it.

This change make load_nls() take a const parameter, so we don't need do
some cast like this:

        ses->local_nls = load_nls((char *)ctx->local_nls->charset);

Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Winston Wen <wentao@uniontech.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nls/nls_base.c   | 4 ++--
 include/linux/nls.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 52ccd34b1e792..a026dbd3593f6 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -272,7 +272,7 @@ int unregister_nls(struct nls_table * nls)
 	return -EINVAL;
 }
 
-static struct nls_table *find_nls(char *charset)
+static struct nls_table *find_nls(const char *charset)
 {
 	struct nls_table *nls;
 	spin_lock(&nls_lock);
@@ -288,7 +288,7 @@ static struct nls_table *find_nls(char *charset)
 	return nls;
 }
 
-struct nls_table *load_nls(char *charset)
+struct nls_table *load_nls(const char *charset)
 {
 	return try_then_request_module(find_nls(charset), "nls_%s", charset);
 }
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 499e486b3722d..e0bf8367b274a 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -47,7 +47,7 @@ enum utf16_endian {
 /* nls_base.c */
 extern int __register_nls(struct nls_table *, struct module *);
 extern int unregister_nls(struct nls_table *);
-extern struct nls_table *load_nls(char *);
+extern struct nls_table *load_nls(const char *charset);
 extern void unload_nls(struct nls_table *);
 extern struct nls_table *load_nls_default(void);
 #define register_nls(nls) __register_nls((nls), THIS_MODULE)
-- 
2.40.1



