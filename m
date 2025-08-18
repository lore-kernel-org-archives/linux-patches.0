Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DFF335BC8;
	Mon, 18 Aug 2025 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523230; cv=none; b=pPAu6XxTuES+yiqVr9PqokOfKeXyf4qRmnho+ZGm/i58PV19Ni+FaM6/08bNqnrJBDVPA+WNpOnzP6QL36HQSBh3xfHtsFwo98r6/t4J5Yb/ykcFawp6L1j1udUuotZGteUhL7Cl/oGGiDBXBsb7tLlUgudTADpPX9zDscdVeVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523230; c=relaxed/simple;
	bh=E36Wx0jtMChjC58KMxEMss/XjhrKxDJ0in3GAMetehU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOSS7VOZiPZvhWUzrTQ3yIt+JOlMiV9cotUPB4XJJ1TsiRgg9007o1zsvt34+4WYLy4qwa8EZfvRhXHJtv4NlCq5pFcQTfp2EmbyuWu0ggpsfqFlB1ivJriHy7zrdK1qefbY2g6DpRedB8XqOsN/0+RHBw4DjIVDGKF6um2vcYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQzcX8c6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQzcX8c6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C3EC4CEEB;
	Mon, 18 Aug 2025 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523230;
	bh=E36Wx0jtMChjC58KMxEMss/XjhrKxDJ0in3GAMetehU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQzcX8c6VhxlhrqO4Me8GZr+aKQCxFN98zysN+J/WJu818s+Wq9RJxkO2MA+5Uxho
	 e+GQhLO8/Ks+4f/IznvaXMve3mR1hVy/KJ9Kk/QRaS2jb3PYEKpoDlWwMBl+lmvQjb
	 4qlRuKlzAlce006W+TVvR4+DmmQjmuUZgGKOCuPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+1107451c16b9eb9d29e6@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 082/515] hfsplus: dont use BUG_ON() in hfsplus_create_attributes_file()
Date: Mon, 18 Aug 2025 14:41:08 +0200
Message-ID: <20250818124501.538348419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit c7c6363ca186747ebc2df10c8a1a51e66e0e32d9 ]

When the volume header contains erroneous values that do not reflect
the actual state of the filesystem, hfsplus_fill_super() assumes that
the attributes file is not yet created, which later results in hitting
BUG_ON() when hfsplus_create_attributes_file() is called. Replace this
BUG_ON() with -EIO error with a message to suggest running fsck tool.

Reported-by: syzbot <syzbot+1107451c16b9eb9d29e6@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1107451c16b9eb9d29e6
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/7b587d24-c8a1-4413-9b9a-00a33fbd849f@I-love.SAKURA.ne.jp
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/xattr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 9a1a93e3888b..18dc3d254d21 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -172,7 +172,11 @@ static int hfsplus_create_attributes_file(struct super_block *sb)
 		return PTR_ERR(attr_file);
 	}
 
-	BUG_ON(i_size_read(attr_file) != 0);
+	if (i_size_read(attr_file) != 0) {
+		err = -EIO;
+		pr_err("detected inconsistent attributes file, running fsck.hfsplus is recommended.\n");
+		goto end_attr_file_creation;
+	}
 
 	hip = HFSPLUS_I(attr_file);
 
-- 
2.39.5



