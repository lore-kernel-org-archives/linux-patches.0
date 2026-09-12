Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215FF38DC59;
	Sat, 12 Sep 2026 09:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204529; cv=none; b=fZqlzdDXxZMmH7ouWUBThdUofvhQwNp7dtalObaslvYjmn29GqfzWIDMm8HNFxsB0Bp6jf3Zg5ISHRQU1iqm+1yjSU7ABhyCPkS8s1bree3oPdE6H2BmdYwzdiYbXRZneIB7b7OTyJC8rkwAQ7tvKFpQiwcbnfswGHOpSSsjbC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204529; c=relaxed/simple;
	bh=vqPSRDJXEUubTRTUk9KK6gpfcVvyBdEmSFdXGV/eL2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbQ+0t2kYvnWCKioCdVj5O4WOkrqkQc1nnZLKTT3xH+6nwEbQ9YcbQM5ST4opDVNP9j8dwsQOToru/zFPhXGxDbUDcxZvxoji/Sjd0lxeBprzXtYkolGdrDsV+3HKTx36KRy/1rq1Cv8KLLNryUnXwDPQSiUq016jeI9WYJK+YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KUI1bWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KUI1bWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B0F1F000FF;
	Sat, 12 Sep 2026 09:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204527;
	bh=6GZXmUHgmg6m8vadTJ8iOijdhS6OHhgThu0Y1sTfi2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KUI1bWF5v0HtM+iGTSrDeuymkUrnbT6aAIVQ4vFARad1zT6+t/n2Q66F2Sg+6L7q
	 B/Zh3Ov8bMJwUvAj78cnDxuYk2m5uMYMNWCGpseWpf1I2Q+0HrP2h0p6ny0JnHNaHa
	 QHsBlcqFiwHhQEqwoC3beQRERoS8lhgFdHbf92hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Stefantsev <mikhail@mstefan99.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1630/1815] smb/client: return EOPNOTSUPP for unsupported O_TMPFILE
Date: Sat, 12 Sep 2026 08:56:20 +0200
Message-ID: <20260912065727.254356293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit a2f9fb451c68adf2b3f7cae1bb66fb5801769ac6 ]

Some SMB servers return STATUS_OBJECT_NAME_NOT_FOUND or
STATUS_DELETE_PENDING when creating an O_TMPFILE.
The SMB client maps them to ENOENT.

The ENOENT error is supposed to be returned when the path
(a target directory in this case) does not exist, while a
lack of support of O_TMPFILE by the target file system should
be indicated by EOPNOTSUPP.

Reported-by: Mikhail Stefantsev <mikhail@mstefan99.com>
Fixes: 3e7d63037a2b ("smb: client: add support for O_TMPFILE")
Closes: https://lore.kernel.org/linux-cifs/75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com/
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff04..b0ddcaa2d8159 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -1138,6 +1138,8 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	} while (unlikely(rc == -EEXIST) && ++retries < max_retries);
 
 	if (rc) {
+		if (rc == -ENOENT)
+			rc = -EOPNOTSUPP;
 		cifs_del_pending_open(&open);
 		goto out;
 	}
-- 
2.53.0



