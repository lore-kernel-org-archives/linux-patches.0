Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88A23EAB4;
	Mon, 23 Mar 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277148; cv=none; b=gRVQ+vbMBf0QmjxQ1RxkIJ6MBuzrmw1k733BHwmDdp0va/DVKTX0Kcv1lKfTq0UBofONFgPytFtMqjloFrImg3SgEI2STy3wULIEZD/ujda0mAoPcpiyEi0x4XDHeHDzLrVN4EkiWvpJqhcpVGkHw9wg7ftkNP2lH2qbPuoHicQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277148; c=relaxed/simple;
	bh=pu4dcSzh09w8o0avmYk+SI/CK1mY55ATH91BzklwOqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1Y8qbekWScS9GHJhHw8MCLKiEIQ5ddF4K8su4acwW/DwnjauIJCyiOeL8ViiS1c3yEHrL+pp7ECwhAQaNpFsOsz3nyyXbx0kafSLxPnBhMrl1dnlR6OvSmQqiYqQILyNheT58G3GaHk5E7nOKk9U8AL+FKecfzuDOFkm+gsetk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJukN0y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJukN0y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57224C4CEF7;
	Mon, 23 Mar 2026 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277147;
	bh=pu4dcSzh09w8o0avmYk+SI/CK1mY55ATH91BzklwOqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJukN0y8RmjzjKaNPwD2ZmpLCCGL3/5oWfpWOzs/epFJBpYaRjH9s0k/rFqci3xap
	 WSqB9tNmSfM8y7XbRakeuSLFJbcdLiGWFSlJ1ttSg+XNf1bCVDtn4j8PmLLW3SKXWP
	 4PvX1zNTSK/TIVqblqN4LR6T1rd3P640QYi39cn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Zilin Guan" <zilin@seu.edu.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.12 292/460] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Mon, 23 Mar 2026 14:44:48 +0100
Message-ID: <20260323134533.657827566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90f601b497d76f40fa66795c3ecf625b6aced9fd ]

bm_register_write() opens an executable file using open_exec(), which
internally calls do_open_execat() and denies write access on the file to
avoid modification while it is being executed.

However, when an error occurs, bm_register_write() closes the file using
filp_close() directly. This does not restore the write permission, which
may cause subsequent write operations on the same file to fail.

Fix this by calling exe_file_allow_write_access() before filp_close() to
restore the write permission properly.

Fixes: e7850f4d844e ("binfmt_misc: fix possible deadlock in bm_register_write")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251105022923.1813587-1-zilin@seu.edu.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Use allow_write_access() instead of exe_file_allow_write_access()
according to commit 0357ef03c94ef
("fs: don't block write during exec on pre-content watched files"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -875,8 +875,10 @@ out:
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}


