Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B84C81;
	Thu, 15 Jan 2026 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498712; cv=none; b=I6kOiVVm6XsQN7V4Y03phDLlY/XoMgQc3xVT4754KFWkRWLutv/LdKmfMyRFyxp59AR/ihfIEWqUzMr5CBBql/n3vdWSF+gzbDm4r3o077cOoUbL/t/uZgBNJeh2tA2V9g3yv3El0u8KjCJeLHhLeu2DEIr0vx3YR1FatvPBi4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498712; c=relaxed/simple;
	bh=7LFLgYdCQjL6V+rSjp04y6wWGjq2bx7IpK+wz28skx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPmPKgqD4qfUV5dxgFZmsiy8RtoSpW/WGVEsMum1+NHU9URPKMe+HGBcWfQ7702zgR9Sdptwo0QEteKjijcRLmuOvyOwkrLwGNd2rG1fgr9eX3+Sf85c+rwzLlsxHWT33uQ+8A2iFhCsAUxHsAMpiMQbtzw+mw1l78Rm+oWIrOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOdLK1X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOdLK1X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACA0C116D0;
	Thu, 15 Jan 2026 17:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498712;
	bh=7LFLgYdCQjL6V+rSjp04y6wWGjq2bx7IpK+wz28skx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOdLK1X3G7Ix4QofYsIYe6kCjqPkgBXrvixddI1qnAzDeDUM/H5RPJJw2Lxj4aZvm
	 v7DSc5uQMpX0gQHUyRHjGiLCWdILHduZ4LnJAAQzEnHLWldLV/k0NdsVnchVd/40u2
	 DXZnEE0PX4rL9wVXPWzMFJMn60Khj0FSCjM89BHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 494/554] ext4: filesystems without casefold feature cannot be mounted with siphash
Date: Thu, 15 Jan 2026 17:49:20 +0100
Message-ID: <20260115164304.198835269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 985b67cd86392310d9e9326de941c22fc9340eec upstream.

When mounting the ext4 filesystem, if the default hash version is set to
DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://patch.msgid.link/20240605012335.44086-1-lizhi.xu@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[cascardo: small conflict fixup]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3191,6 +3191,14 @@ int ext4_feature_set_ok(struct super_blo
 	}
 #endif
 
+	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
+	    !ext4_has_feature_casefold(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem without casefold feature cannot be "
+			 "mounted with siphash");
+		return 0;
+	}
+
 	if (readonly)
 		return 1;
 


