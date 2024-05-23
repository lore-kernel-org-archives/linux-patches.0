Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A133314B07E;
	Thu, 23 May 2024 13:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470391; cv=none; b=kzRTCya+623PjPDYalhwdZMtZr4XJavYZSj9hwI0+XLKCJYv/2MdhXF9lGzY6+9gAY18CW+fKuKAElmHKCLo3NdP/Dw0L9+OJnjjsQAgzzQrQaCLiom0I2MVNSDQlYZ6XLC+nl3V2frOMbPN4ER3W9M2mZyQjHSqsbKngvTN4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470391; c=relaxed/simple;
	bh=gaORDWgCy6XpMMEfLVCQF97Ke5hqb4zdPuNfLR2C6FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlfFqF4ddxBW8ldmsox7j4tKbNF3BUI1Lmh4uvjv4k7jVL0VurWA9y2t3YjiJoumiKLi8E3fO760444dCsdsre59aF6Vhax+M4Xv0cmV281GhPqJrzPx3aDUdB/gaU2qGEwC0IYKFiQAc3nVcLks0AYddLKtsWMZYIGP5Fu6k2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QenQAXjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QenQAXjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F1AC4AF0A;
	Thu, 23 May 2024 13:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470391;
	bh=gaORDWgCy6XpMMEfLVCQF97Ke5hqb4zdPuNfLR2C6FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QenQAXjNakrMOSbbtYxhEDk3FKb+wHj6N/4ksPrsqgDz2nnB5SiUHP1UE4BC3TdDe
	 sdvGbpoVq0EfsFGD27QThRiZG9WxmOnInA0GiTPbvxxfLqwknTiCxtIx5QBt+Y+Uf6
	 uHuoswWtVLaMoTOxvTCyPmGmiQS5TrgMrvFJTxdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 20/45] xfs: fix incorrect error-out in xfs_remove
Date: Thu, 23 May 2024 15:13:11 +0200
Message-ID: <20240523130333.255434214@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2653d53345bda90604f673bb211dd060a5a5c232 ]

Clean up resources if resetting the dotdot entry doesn't succeed.
Observed through code inspection.

Fixes: 5838d0356bb3 ("xfs: reset child dir '..' entry when unlinking child")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2479,7 +2479,7 @@ xfs_remove(
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
 					tp->t_mountp->m_sb.sb_rootino, 0);
 			if (error)
-				return error;
+				goto out_trans_cancel;
 		}
 	} else {
 		/*


