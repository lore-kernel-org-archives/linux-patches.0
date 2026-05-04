Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BBF3A7F4C;
	Mon,  4 May 2026 14:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904015; cv=none; b=Fjgf1YUaeJNCRBiRDlVIqstVcaasdVXV9FEqh0L6aRDyx3hOq3qgCNmjKm/5Ut6vMlMw7JdI3k7mhOwsmVlzYaJqS/Wc77doSXU44WbelBXbfwUwJEmn/ahpagpajIzZxgh/AN6w7rl4U86WyR8Je4UtZOx8hQ5hwJrbfVoCNfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904015; c=relaxed/simple;
	bh=xMzadajH6GHAJA0IhyR5E6KjOkbWqvt62eoXJzsvq7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRB8/xG2YV0dwatRAhJ/cywXULfwmXomM5UYpxzLqzFF2PWZ/0/j55fCqI8LM8r8U2zUXoFh3e1csfb7O5SbtiJv5gdlRxzySa2cseqgoT79bbDAuj2HvF5Bg05hnsGdHCLGnK5i2Efr6YwhiD81y+QTUi8sO8ChIU4aSoQbosI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7gC4Msp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7gC4Msp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9E8C2BCF4;
	Mon,  4 May 2026 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904015;
	bh=xMzadajH6GHAJA0IhyR5E6KjOkbWqvt62eoXJzsvq7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7gC4MspWbCCLlfZfqJ1isA4wHM8XWGBiKgM53STSuzBXNwgZvQhyRephTbqfMNYd
	 90Tvwz47k8MGkJKe8VxSnruWrAKBDEZnMxj/2SEaCHVeigtebuUgUbePELVTe/3BoK
	 BSpyXzlGHfx+iuKi9BtZlghHNbDfZ5waXxrZTDR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 150/275] xfs: fix a resource leak in xfs_alloc_buftarg()
Date: Mon,  4 May 2026 15:51:30 +0200
Message-ID: <20260504135148.507993506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 29a7b2614357393b176ef06ba5bc3ff5afc8df69 upstream.

In the error path, call fs_put_dax() to drop the DAX
device reference.

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1831,6 +1831,7 @@ xfs_alloc_buftarg(
 	return btp;
 
 error_free:
+	fs_put_dax(btp->bt_daxdev, mp);
 	kfree(btp);
 	return ERR_PTR(error);
 }


