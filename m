Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9B71E7C27;
	Thu, 30 Jan 2025 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247376; cv=none; b=NYVCLP82/0jEiLrjYsfOJSInVB8Qdgo/8VJ0+CLne8RG8DQzAHmnfMgN2RRUWR/KqFGNBf1JuS29URrPIgIWVxHATV5v7DfVTTpYWjIH+aoN1LRqHwMQ0d2pgK3pSwsoGG/xt9QhwrdbUQ9XEOS232TCFzKPRcxN9k3efJMsYSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247376; c=relaxed/simple;
	bh=BG3O/gBkSgzS9aifryPckHxc4EdSedBANfnj8ob6DY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6NngdwIIHgiKNIT+Nlg/P2MJfgcxjINcXh1FDlikfZO9CDinWPYJFf7b+pc+bcjivaj3s1iUGbOupvTAfitXk0uSTTVjpeS3rHDgLShB9zy/cQfMMKtgjRfHsPevJN1h4sCPjl6+E5/AWdZB15sqRaiA8qFuKVymZN6H60Ja94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fruw3jzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fruw3jzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D38DC4CED2;
	Thu, 30 Jan 2025 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247376;
	bh=BG3O/gBkSgzS9aifryPckHxc4EdSedBANfnj8ob6DY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fruw3jzmYgO/bSluqUuaARmOm0t+tyFrSdfhGQYqinKe7kUsBErkx5ibyTG2vIXIl
	 DbWIAp9Xe4d9+tWFPisUT2daHOgGzKGhrkcV1av/N9dZyPHfbb/J8ccsRD2nP0zjDB
	 YHVW2DYCTLuD9ZginG2UVhjzga9I4lGJ07Zrw5Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Lin <cheng.lin130@zte.com.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 18/49] xfs: introduce protection for drop nlink
Date: Thu, 30 Jan 2025 15:01:54 +0100
Message-ID: <20250130140134.572636448@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

From: Cheng Lin <cheng.lin130@zte.com.cn>

[ Upstream commit 2b99e410b28f5a75ae417e6389e767c7745d6fce ]

When abnormal drop_nlink are detected on the inode,
return error, to avoid corruption propagation.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -919,6 +919,13 @@ xfs_droplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
 {
+	if (VFS_I(ip)->i_nlink == 0) {
+		xfs_alert(ip->i_mount,
+			  "%s: Attempt to drop inode (%llu) with nlink zero.",
+			  __func__, ip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));


