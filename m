Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8C823F439;
	Tue, 26 Aug 2025 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214292; cv=none; b=T1vBSgmy8ef4CG4XMgKN/Ptqckb3wCx2szL+cL/q00uBVO2OeurplsYtQQpPzKySJmvoyLDK+dV58BZm8fABfuhenNkxF1AEDqfShJvbifpX4LG5v0GWTIijgJ1uy1lK0ZV+YxRm6mJ1Jl4IgeG5yHsOqlNJN+bEIfhH0serzFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214292; c=relaxed/simple;
	bh=FPji+Z9s5+Z+c/7ndSrvb1BO/aS9jyo3SXw7TFe+8kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWAe9NuZmVQnxzu8uy0hT5bAV50BZyT4d+YMzkeh5OyRQyVqrqVi83hssMvkJg9kTyprBSn3HPgfZephy+G0EkW2J+JXcWCAp+w4sZ/v+KCgCsDnOh0qeg9OHIbDAS3FmbyAdRCDLOI9AhNNAKioZqZ4pzEkstaqBQE7YbWVDy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0iCUeIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0iCUeIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03F7C4CEF1;
	Tue, 26 Aug 2025 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214292;
	bh=FPji+Z9s5+Z+c/7ndSrvb1BO/aS9jyo3SXw7TFe+8kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0iCUeIE2AW3gwdyV4T/pBUT5Pz3/0CptfIjw8dNxI2dqMCK38hb5HK7cPrlXIfKS
	 NTAMVMtX3uZm3fHiyI1quS26V+Sruk86OjQAfbXrRZ6uGBjcTmMb02KQ0o0nqv6/0S
	 526mIbdgkIYTAULZJtkxqz5/xtjUAXnks9hwtgIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+1107451c16b9eb9d29e6@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/482] hfsplus: dont use BUG_ON() in hfsplus_create_attributes_file()
Date: Tue, 26 Aug 2025 13:05:05 +0200
Message-ID: <20250826110932.106366470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b0e0ba58139..beedc1a2237a 100644
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



