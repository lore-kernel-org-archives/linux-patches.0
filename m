Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D05E8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75444C433EF;
	Thu,  5 Jan 2023 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923555;
	bh=LpaIaeMXAlEYAP2A6sCn8L3cflaEkifNJ2tTxxOhdCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmDxq2/DDN7qk3xnDaeHzlGxboGra+IqVpkj2wvSQRn+rsKKJJLxwLt648mYi0IFU
	 h3/XvcJPrtKADPPguU9fChawhlHgPohybYzqM4hA+pu6ywe4cixmO7xqZqBPmGtGWR
	 HAZLWMKCJ2PO/sam6yPu9MywEDFXcnha73ly+Ba0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Pitt <mpitt@redhat.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/251] fs: dont audit the capability check in simple_xattr_list()
Date: Thu,  5 Jan 2023 13:52:47 +0100
Message-Id: <20230105125336.143609272@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit e7eda157c4071cd1e69f4b1687b0fbe1ae5e6f46 ]

The check being unconditional may lead to unwanted denials reported by
LSMs when a process has the capability granted by DAC, but denied by an
LSM. In the case of SELinux such denials are a problem, since they can't
be effectively filtered out via the policy and when not silenced, they
produce noise that may hide a true problem or an attack.

Checking for the capability only if any trusted xattr is actually
present wouldn't really address the issue, since calling listxattr(2) on
such node on its own doesn't indicate an explicit attempt to see the
trusted xattrs. Additionally, it could potentially leak the presence of
trusted xattrs to an unprivileged user if they can check for the denials
(e.g. through dmesg).

Therefore, it's best (and simplest) to keep the check unconditional and
instead use ns_capable_noaudit() that will silence any associated LSM
denials.

Fixes: 38f38657444d ("xattr: extract simple_xattr code from tmpfs")
Reported-by: Martin Pitt <mpitt@redhat.com>
Suggested-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index c0fd99c95aa1..d66983d1e57c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1017,7 +1017,7 @@ static int xattr_list_one(char **buffer, ssize_t *remaining_size,
 ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 			  char *buffer, size_t size)
 {
-	bool trusted = capable(CAP_SYS_ADMIN);
+	bool trusted = ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	struct simple_xattr *xattr;
 	ssize_t remaining_size = size;
 	int err = 0;
-- 
2.35.1



