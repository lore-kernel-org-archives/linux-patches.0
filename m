Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E794443E488;
	Tue, 21 Jul 2026 21:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667963; cv=none; b=COSQli6P4sKeTsfiHp2obq2Zue/9bzTbW28PSoPC0Ah9FWUE/qw4jYi+TQAQe8IVN5Pn88/INSQKK9hxcKIaCivAlDsXaHoH6S7Q1Xr+ttRWQSrUFyEzH1t2OIhJNxzpwtmEHX6mPRro7949/dztYrUd2L/Ve1ixi8TRHCj2ds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667963; c=relaxed/simple;
	bh=t7suY2oZM2iTIRrMjZsDc6qVUOi0s0XkcNFZll2SDu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G+yQPapMIJ2Jcrqy0Ee4+7xWXeZq8AGMmXXdMQ4AAH3+gVsZsP9drbH0eT9ln0nfiBWNKyidnzft7DuJsxFb1DBv1wUeFvCvdCPUoQPdbng9HRAuTuIijFnesUgf7Wwsehg61EfLwssXQslWMeS761IUyXNPddgxjrdp+YQFfXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIOIpG8m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIOIpG8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D2B1F000E9;
	Tue, 21 Jul 2026 21:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667961;
	bh=kQhd45Lzbo163BbU0Z2rUSmBxlcqNeb2+tHotDOIyTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIOIpG8mH6YTCQw8+K8Rb9BJ2AaAaSNIb0N0pUPyvmXcGfxdkn/hPXDIHglUREFr+
	 5BpbcHbcPZWLd5hFk4J4Ybt9iZhbjh8lVJYJu5dScwaSR0E+a1e6NkhtyJRgkG57nF
	 Btr/Mz2prb+iIkm0SVqme58fACkPhPveJ7+kE6K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 1260/1266] xfs: fix stupid compiler warning
Date: Tue, 21 Jul 2026 17:28:17 +0200
Message-ID: <20260721152510.019156559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f06725052098d7b1133ac3846d693c383dc427a2 upstream.

gcc 14.2 warns about:

xfs_attr_item.c: In function ‘xfs_attr_recover_work’:
xfs_attr_item.c:785:9: warning: ‘ip’ may be used uninitialized [-Wmaybe-uninitialized]
  785 |         xfs_trans_ijoin(tp, ip, 0);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
xfs_attr_item.c:740:42: note: ‘ip’ was declared here
  740 |         struct xfs_inode                *ip;
      |                                          ^~

I think this is bogus since xfs_attri_recover_work either returns a real
pointer having initialized ip or an ERR_PTR having not touched it, but
the tools are smarter than me so let's just null-init the variable
anyway.

Cc: stable@vger.kernel.org # v6.8
Fixes: e70fb328d52772 ("xfs: recreate work items when recovering intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -622,7 +622,7 @@ xfs_attr_recover_work(
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	struct xfs_inode		*ip;
+	struct xfs_inode		*ip = NULL;
 	struct xfs_da_args		*args;
 	struct xfs_trans		*tp;
 	struct xfs_trans_res		resv;


