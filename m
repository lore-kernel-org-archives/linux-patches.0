Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C931A378823;
	Tue, 13 Oct 2026 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892450; cv=none; b=Bx1K7/Avpzc6h5sp3T9yiQF3Dnn3Fj1Q8Gvpe78jFXIuQrRJvw7Bz5svjVGq0ZeSu60w/ga0b+eL1189YN6/9Wy2yfzhXcU/QOrzm3DUTSFa94HQS3Y2vMC08PBDzZwHMWwh2uVulgpP1zhKfE5id3ZdzMZ32TGbPnthZVxTR04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892450; c=relaxed/simple;
	bh=G07GEC3/WdgU09psXN93G1luidrAMX8FeoGqL2rqTP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbwOuE3wb+EYUY/IKm3YtNlX1AHD0y4cIkySRSA5RH8jTJ3KpeX0m4+tGuRo/NEmFy0Dq05EbinDU5hAJ2ihuiMxAhAXBcqyy3IKRpBV3CeIFPdPPiDwghPFdkj2pCTltbeAlWdjEkdEUlD9HDR4Ka+42gJb5gvl20NNW1ZWBTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jGpJwGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jGpJwGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A941F000FF;
	Tue, 13 Oct 2026 11:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892449;
	bh=OeJdYkRcBPxdIg3z6pR+MgUD42mNEMNKp0GYjmzlliw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jGpJwGQkBOUX9wz4sHV6ykteDw0bkpxEnbASqywwyqLpJWprpNW1G65VvSTmGEBb
	 9ueSkBSpl3inE3ZnQfYIRMRiQ2pTCPuw0vWYDwCx4qwMOE7Qj0xl53HHIeDoRa2oUL
	 +/n6wv2I51F3Du8d/SesgOR+oPJuCQLFIcm8Ud+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 170/281] nullfs: dont update the access time
Date: Tue, 13 Oct 2026 13:38:06 +0200
Message-ID: <20261013112859.292052656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit caf16f9b4aa66e5092f95e98cda54f2bb7482ed2 upstream.

There's no point in updating access times of the nullfs instance. Raise
S_IMMUTABLE.

Fixes: 9d4e752a24f7 ("namespace: allow creating empty mount namespaces")
Cc: stable@vger.kernel.org # v7.1+
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-7-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nullfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nullfs.c
+++ b/fs/nullfs.c
@@ -30,8 +30,8 @@ static int nullfs_fs_fill_super(struct s
 	make_empty_dir_inode(inode);
 	simple_inode_init_ts(inode);
 	inode->i_ino	= 1;
-	/* ... and immutable. */
-	inode->i_flags |= S_IMMUTABLE;
+	/* ... and immutable, reading it leaves no trace either. */
+	inode->i_flags |= S_IMMUTABLE | S_NOATIME;
 
 	s->s_root = d_make_root(inode);
 	if (!s->s_root)


