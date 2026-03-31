Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F601C861A;
	Tue, 31 Mar 2026 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975422; cv=none; b=PvO0i5iCDvbMywWH2L39MEiQ7O54DDGs0WasHRvlBsemSJczq2b5GE/KWdYG3iqoYxPZ18eqSpGi6TYhFZGhuQSD8t20DOGXeVBd33Iy7b0JRNpj0tsEiOxlo/IOKR3LX04WldmaewQ4ue//+ni2ruRUhfNh5gAQdgYyemWdc/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975422; c=relaxed/simple;
	bh=rOThx4XZBFDX9LOhVFecOpuI5x2890f8XxTxDwD9u08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv0endWK0C7dPkDIczp6PYr+CpJB3vpLS01ecmwfiq1HBpbChsA3YCsoqZ29cNBbhKNFk1VUzEVQuy7qAYjJ64du3BJYC1ZGlNZzzfrCUMTJaX0rI3+OIfqqYbNMCPbRfXQ+DlKGxaw+ViRPSXkWhHvO/vzoNiZDPLDeRe3hUR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVB1sW++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVB1sW++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532ABC19423;
	Tue, 31 Mar 2026 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975421;
	bh=rOThx4XZBFDX9LOhVFecOpuI5x2890f8XxTxDwD9u08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVB1sW++3cl4PM0LmmqPSrnEguct2fCoAzLGBvMg9HvIOzEYd74yuJ0/KFSd3bSII
	 TS5canE8/AVzuY1enMIEnvJCJ4kNHWWNqLyTNyYBtz5yrRzy3CBzE3ShKSUGdnpk3l
	 6SFRnKiaDpBNVOJE7sfuIlLhcWcirM1XpEag0vLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.19 288/342] xfs: dont irele after failing to iget in xfs_attri_recover_work
Date: Tue, 31 Mar 2026 18:22:01 +0200
Message-ID: <20260331161809.537567024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 70685c291ef82269180758130394ecdc4496b52c upstream.

xlog_recovery_iget* never set @ip to a valid pointer if they return
an error, so this irele will walk off a dangling pointer.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -656,7 +656,6 @@ xfs_attri_recover_work(
 		break;
 	}
 	if (error) {
-		xfs_irele(ip);
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
 				sizeof(*attrp));
 		return ERR_PTR(-EFSCORRUPTED);


