Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDC382F25;
	Sat, 17 Oct 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253218; cv=none; b=ONsXtLnrfoYf2jfuuHC1MKnzeaaNq93huRmX3XL96+2zE2X+yRv+eHR6iLpxYeaSArconJsT7BMqDVhCEXVEQgC0/kV02sgRAPgy338K4yFXc2dO2+gAX/sYHNqlZ9R7PPvLszJZew+Ts+aAzv3R8aFR/S7Bp2CpfoTyh088jSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253218; c=relaxed/simple;
	bh=dd/1CFK6b9Aqkq1CCc5mRzRr4xW0WOid6Psewg+RQn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBi4yTnPmV5tOY1AUCURNS0P9UQ9d+cOtNjrwaFlj7BGa9K4QRegR/e6zgH7MxhCdalBO+21weGrBOmlbBpzbD0pxrHmS+B79ImoD+SG+GCRUjGtldYZtf88WKbpXfeWTrDtOW8FRDQIn4gEsx2LfFUm8MYEMmkXUhPf6HXV39g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7H12ciD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7H12ciD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7627B1F000C4;
	Sat, 17 Oct 2026 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253217;
	bh=RnhH4Hp74hlHW4j8EmyxdnDRbl3HJ2PW/WuYb/Glht8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7H12ciDWcVKomwN2K00iLKsFFX23SAoNCy8oDhEbu4X3oseG2BI0gLK4UZa7PiEx
	 u8PxEURVD/4RpkbBGChC+uG6c6Cgt1fx9kYEp0wdxp0YipvcBF2VzjsZ4xTq2Wl2/3
	 7JqWH9NAsSxHnCmbO4bjq8ZMT+Og6NU1hcZW3FVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/869] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Sat, 17 Oct 2026 17:48:08 +0200
Message-ID: <20261017160038.223042058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit b0d1022b9bdb1e98aa7fb3244fdd50a58c61766c ]

An immutable inode is never written to so write hints are pointless.
Refuse the hint on an immutable inode the way setattr(), fallocate() and
etxattr() refuse their changes.

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-3-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adjusted context due to the missing inode_owner_or_capable() check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index c4cdee6a78005..cb40e1f661eb2 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -374,6 +374,9 @@ static long fcntl_set_rw_hint(struct file *file, unsigned int cmd,
 	u64 __user *argp = (u64 __user *)arg;
 	u64 hint;
 
+	/* nothing is ever written to it */
+	if (IS_IMMUTABLE(inode))
+		return -EPERM;
 	if (copy_from_user(&hint, argp, sizeof(hint)))
 		return -EFAULT;
 	if (!rw_hint_valid(hint))
-- 
2.53.0



