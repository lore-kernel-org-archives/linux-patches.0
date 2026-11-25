Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622752;
	b=wTmZDkDNdadwhA9fk9C+yvyKlgy8Ai59jjlxbX3fiV5adxIQ6DKZF8zuSLBkSHru774N
	 8n7S8Uo5VjAb/AHW/c0BvgL63rL7kt5Le6Qcr1aV6+uqt+6Fioa1EN8Nfdu/XeybZTfzA
	 sEk9t7P/szfyyp80s1SOpYIjtfEr+SUI3HQ8zSD2iX5HvUVpFhzXhxqeDYNVWMma6JmL6
	 Gwn4MpYTYvjhmtoFKun1f2cHzosMwmd58S+DTCJBaNvEiqMDH+exyXpFlISWi2j19iI0J
	 ewL/pRnInpFRyTIEEk2c+hhG7gXVk43oLFRcoga849wZQBkXDvillrQOqZibjEWGKPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yj6AygkRE+/pNwnC8fdF7aHaD8aj4GXgG5Y/c3n2x7s=;
	b=kVIEjulo5K47nPiucAtRTbl+VNw56+ksgAqaqScTBOYxKNg9OPpvneRzjy1GUtZ4M1rh
	 NZU7TY/PCXSNytB1J9WM8hyQLOCdguDRMdcURfvnIMboeslWAXS1fvGjcSrEZ3IUr6yGo
	 c1oFels4FXfLuErSCGo1PGZ5G4oMEWW2X24V98nvfcbQodhxfLi0jqB6lZ4vR9usQfTut
	 z7ixkMO/d/fuo7WQE0cGKeOxJANd4Q3wzGYMW44sTGhfRK1tebkJUdpDMA4T5x6zRW2Ws
	 DW531pnJP4rLcS1BANW+ivGFHJIGwkh52jb26a9wBCs/fjjJk/XlORCpYperWJ4HYyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PC5s96tS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC4C606A31E;
	Wed, 25 Nov 2026 16:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PC5s96tS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC101F000C4;
	Wed, 25 Nov 2026 16:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622751;
	bh=yj6AygkRE+/pNwnC8fdF7aHaD8aj4GXgG5Y/c3n2x7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC5s96tSJoGLFaz3G0RKyjwVSNcjQC/xdgoKrD9WP2O0wT8P47Y9xaaz3lrxaep3v
	 PU92i3wg09C/1qmQ8jTXa00mdTjt+M0CD8SSElzSdqobXQ9utig783t4g5IX/Om/bo
	 /cjfb5d86KIK6eS04zCyjnUdu+LkvCEUYOWx7oXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Kulikov <dar1knessx@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 634/990] ksmbd: use the resolved share path for the share root
Date: Wed, 25 Nov 2026 15:33:21 +0100
Message-ID: <20261125143836.946760970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Kulikov <dar1knessx@gmail.com>

[ Upstream commit 03b47bdc9ac8e9dacbf1d66a1dfc54b328e283f2 ]

If the share path is a mount point and crossmnt is not set (crossmnt = no,
or ksmbd-tools that predate the option), the share root looks empty to
clients: QUERY_DIRECTORY on it returns only "." and "..". Files created
in the root go to the mounted filesystem, but a directory query cannot
find them afterwards, so e.g. "rm" of a file that was just uploaded
fails with STATUS_NO_SUCH_FILE.

An empty name refers to the share root. For it, ksmbd_vfs_path_lookup()
looks up share_conf->path again starting from its parent, and the mount
on the last component is not followed, which gives the directory covered
by the mount. All other names are looked up relative to
share_conf->vfs_path, which was resolved through the mount when the
share was set up.

share_conf->vfs_path already refers to the share root, so return a
reference to it instead of looking the path up again.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Signed-off-by: Denis Kulikov <dar1knessx@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Adapted the context to this branch's older ksmbd_vfs_path_lookup(), keeping do_lock and the getname_kernel() filename handling instead of for_remove and CLASS(filename_kernel). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index a3db77b3c2728..466a0853dc486 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -82,12 +82,13 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 		if (do_lock)
 			return -EINVAL;
 
-		pathname = share_conf->path;
-		root_share_path = NULL;
-	} else {
-		flags |= LOOKUP_BENEATH;
+		*path = share_conf->vfs_path;
+		path_get(path);
+		return 0;
 	}
 
+	flags |= LOOKUP_BENEATH;
+
 	filename = getname_kernel(pathname);
 	if (IS_ERR(filename))
 		return PTR_ERR(filename);
-- 
2.53.0



