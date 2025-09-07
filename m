Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002F1CDFAC;
	Sun,  7 Sep 2025 20:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275899; cv=none; b=j8syS7r3rKADm+CbsObwLqh+Vvwbgs2uf9M4plXnvv5wHVPTbXjnkWHtZIClJLCkvleMCJD8KIowDLp8uH67XhYcIgO0mbP9XgGEkuSn2lrOF3dhPngVSHsE6suYO/7AtnOxIyY6NJOr0BxK9c+zIdPkaIjljJdRWABePmroAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275899; c=relaxed/simple;
	bh=Vm9pVUwsOoChfKly9iTIGInufvnBost7BHaMDFAFWjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhRSYTlxwQMVjlDs9TKTs8hjFrt+3HqXYSCa7qkhHLon5wqa6r7BCt0tpFbmVikuTkc8wT07VTdPrYIyjzxO0V5geg2GQTtc6iVD3UeRQyN6Igkn7ZfLK5TRE/M0u2JR+70V7vn09/Hi4mQBxgk6uGXSiDDlAfCvx4d7DfxX4js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0ht7UPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0ht7UPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA690C4CEF0;
	Sun,  7 Sep 2025 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275899;
	bh=Vm9pVUwsOoChfKly9iTIGInufvnBost7BHaMDFAFWjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0ht7UPUPHwDGrPDiH75M/OwazljAro89dzmxk/ESHjUYOwm7osHoDUZ5QgDhpXaf
	 A7xK7fpOjhR6R8jISwVks2o5BqFKl/Sf30eSVg2H/dXNaWB8NbsTz6JcDBMZHSnpal
	 OLEwsfoKQDfGAjxgS2TQWXIcDL98n81IPuuTXt58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/45] cifs: fix integer overflow in match_server()
Date: Sun,  7 Sep 2025 21:58:30 +0200
Message-ID: <20250907195602.287382945@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 2510859475d7f46ed7940db0853f3342bf1b65ee ]

The echo_interval is not limited in any way during mounting,
which makes it possible to write a large number to it. This can
cause an overflow when multiplying ctx->echo_interval by HZ in
match_server().

Add constraints for echo_interval to smb3_fs_context_parse_param().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: adfeb3e00e8e1 ("cifs: Make echo interval tunable")
Cc: stable@vger.kernel.org
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Adapted to older CIFS filesystem structure and mount option parsing ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2144,6 +2144,11 @@ cifs_parse_mount_options(const char *mou
 					 __func__);
 				goto cifs_parse_mount_err;
 			}
+			if (option < SMB_ECHO_INTERVAL_MIN ||
+			    option > SMB_ECHO_INTERVAL_MAX) {
+				cifs_dbg(VFS, "echo interval is out of bounds\n");
+				goto cifs_parse_mount_err;
+			}
 			vol->echo_interval = option;
 			break;
 		case Opt_snapshot:


