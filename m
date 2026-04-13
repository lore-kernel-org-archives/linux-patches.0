Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8029C3264F2;
	Mon, 13 Apr 2026 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099352; cv=none; b=pvYQ9o+0rkQ7udlFuVavUQ8ae3+PQNtfQyVZ9oD01H2gVqqGeZpsSy1Mlp0ydWb6McWvd+yEacZa/mvbATWDzJ5a66UrEvJbTyCQGIEq7B40hHR4UQn6Ed2LosskWU9tnDYnDIXQ0ICAgpCfoDWiTOALSN0+PJBpHBV9J2aCAKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099352; c=relaxed/simple;
	bh=rS/FeMv3QRW0AsvG2MJlgqGvbG2SMjVoj2x4OPI4Mjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/QSSo7oZJqMh+llRF+SDqRfjHrWyZ13ZTiTjR7qoUYIc4nr6uPp2HcyyAle7jDeYL+5j/D37Iow5EMQgGlKxYhkK+omsYbv2Ha5Asa/CjZgUm2+eCraj6cgbYj/sM0XmjPJuL/0jbeZUmO6e5G2R+DUvquCla4Cyclzy1vGMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpO8Qwvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpO8Qwvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B45C2BCAF;
	Mon, 13 Apr 2026 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099352;
	bh=rS/FeMv3QRW0AsvG2MJlgqGvbG2SMjVoj2x4OPI4Mjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpO8Qwvg/8kdun7mUYiviIrTlyepevLV4gtqnlmV9bx8mfRuX0VUWzG4mXYiC8jbl
	 17ScmT0AWlI4I5E2TOTwX4khRR69b7W+8E40Mfd+m4N6u/gyjJR8VBSvXRKr34VaSk
	 v9vGrrqjiAWGjUTNl80cIW3COclfpwNj3ELOFwXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH 5.10 307/491] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Mon, 13 Apr 2026 17:59:12 +0200
Message-ID: <20260413155830.533812326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

commit 3822743dc20386d9897e999dbb990befa3a5b3f8 upstream.

bigalloc with s_first_data_block != 0 is not supported, reject mounting
it.

Signed-off-by: Helen Koike <koike@igalia.com>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b73703b873a33d8eb8f6
Link: https://patch.msgid.link/20260317142325.135074-1-koike@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3369,6 +3369,13 @@ static int ext4_feature_set_ok(struct su
 			 "extents feature\n");
 		return 0;
 	}
+	if (ext4_has_feature_bigalloc(sb) &&
+	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
+		ext4_msg(sb, KERN_WARNING,
+			 "bad geometry: bigalloc file system with non-zero "
+			 "first_data_block\n");
+		return 0;
+	}
 
 #if !IS_ENABLED(CONFIG_QUOTA) || !IS_ENABLED(CONFIG_QFMT_V2)
 	if (!readonly && (ext4_has_feature_quota(sb) ||


