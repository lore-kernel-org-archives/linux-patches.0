Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC44B192594;
	Tue,  8 Oct 2024 12:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391415; cv=none; b=HuuboNTi593HIuxfjpwGtE4ho+/Oz/s1LUJRUmIMCnPb4yA2c2mhzumD+z/VzJdn63kguLHfzKZfNoJ6OaGsdmg/L/7pXpsG4b2Ij+PxbO9d1Xt6j03SPAXQm66qYscdP78vCmO5I2ssITCzBtxtlnbPPhMeB1APe7k4IdZ4ZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391415; c=relaxed/simple;
	bh=eYH4bCIjrMIYz4EgsvSfSNn2OuD1irzF6Kiy/ZYlrbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APRV9sc7D5UEeEgvGc6yanmobsl34NkTYXF5GP3TRZc6dOXp04k2kMm2hY6UPqltnSegUYcVcQsl8VYueSQOmb2U4Qd0slkFBGiTahibd5sZziXvYUXqz5p1hSV8+hOQQUCFn0lco0ZYr5z1Y9QIZ61LyYpd2dUV+YJf+3e5LFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNA2bN/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNA2bN/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327ECC4CEC7;
	Tue,  8 Oct 2024 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391415;
	bh=eYH4bCIjrMIYz4EgsvSfSNn2OuD1irzF6Kiy/ZYlrbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNA2bN/QMFGsl6TWdLdb9VeouHOBvwUKy/zfuRjBdEJiZWaU2qHWfcGhfdKZh/50N
	 jv2A9JBSVoQhRcUtdu99L3gy5sMN1+HtBYt+0ArNTFU6ZMBXMfqFcBHKbtYnpqqakL
	 mGDvj9AQpp6QeoxTj80moaGzgzeuu2c6UeKmr19Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 075/558] cifs: Do not convert delimiter when parsing NFS-style symlinks
Date: Tue,  8 Oct 2024 14:01:45 +0200
Message-ID: <20241008115705.327828023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit d3a49f60917323228f8fdeee313260ef14f94df7 ]

NFS-style symlinks have target location always stored in NFS/UNIX form
where backslash means the real UNIX backslash and not the SMB path
separator.

So do not mangle slash and backslash content of NFS-style symlink during
readlink() syscall as it is already in the correct Linux form.

This fixes interoperability of NFS-style symlinks with backslashes created
by Linux NFS3 client throw Windows NFS server and retrieved by Linux SMB
client throw Windows SMB server, where both Windows servers exports the
same directory.

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index cfa03c166de8c..ad0e0de9a165d 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -335,7 +335,6 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 							       cifs_sb->local_nls);
 		if (!data->symlink_target)
 			return -ENOMEM;
-		convert_delimiter(data->symlink_target, '/');
 		cifs_dbg(FYI, "%s: target path: %s\n",
 			 __func__, data->symlink_target);
 		break;
-- 
2.43.0



