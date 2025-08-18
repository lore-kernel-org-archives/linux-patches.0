Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B4C335BB3;
	Mon, 18 Aug 2025 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524462; cv=none; b=gEugL1LkjbY6QvgsNja1QT+wXzr8IS7ne9ojX9ACUL9hAbQkUP6SQ4pCIVApWn6TLT0RarebTv2/QWqxd/ieBmVDEaiGdnFDaTTJd7ruGkxTp0XAeSDGo78uwI920vrq7PZ9r690ucFsprVVfOkyAoMw+8P8nYwl1T0QmFRypaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524462; c=relaxed/simple;
	bh=dtyAgugaz/2g63U42U6A37DLSBNy7AOA5m0fp4nBVKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPY95vVu5qM5/Qnz6nHv5JrMCdjwz2bgxP2ZHpih056dIoJ3xQb47QZXC+DePDkjtoYhxzlMRVPGtBuTXumStM+Ky8oWvoSoYd8820xebrk5m6h6BXmC8Iq4MSYO1JwCCcFApNvF/PDslDFyxYjtJsrcvfWv3A+fREq8kAFe/y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+wuLO65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+wuLO65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69162C116D0;
	Mon, 18 Aug 2025 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524462;
	bh=dtyAgugaz/2g63U42U6A37DLSBNy7AOA5m0fp4nBVKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+wuLO65YDOr337M9EE+RZZqlJ/GN4xdqqmb68YObuHl03rmxMxlbv6vPemq0qn5i
	 CaAply4v043FvD9V+x0h6DGSGVGdCop8yuef+rfMFIngvk4hSoq0NYLENKzXmWFoXW
	 Dswn3zpqXdqozD651IbBeTfewFq3BbHagiW6mkTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 480/515] btrfs: fix iteration bug in __qgroup_excl_accounting()
Date: Mon, 18 Aug 2025 14:47:46 +0200
Message-ID: <20250818124516.900846472@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 7b632596188e1973c6b3ac1c9f8252f735e1039f upstream.

__qgroup_excl_accounting() uses the qgroup iterator machinery to
update the account of one qgroups usage for all its parent hierarchy,
when we either add or remove a relation and have only exclusive usage.

However, there is a small bug there: we loop with an extra iteration
temporary qgroup called `cur` but never actually refer to that in the
body of the loop. As a result, we redundantly account the same usage to
the first qgroup in the list.

This can be reproduced in the following way:

  mkfs.btrfs -f -O squota <dev>
  mount <dev> <mnt>
  btrfs subvol create <mnt>/sv
  dd if=/dev/zero of=<mnt>/sv/f bs=1M count=1
  sync
  btrfs qgroup create 1/100 <mnt>
  btrfs qgroup create 2/200 <mnt>
  btrfs qgroup assign 1/100 2/200 <mnt>
  btrfs qgroup assign 0/256 1/100 <mnt>
  btrfs qgroup show <mnt>

and the broken result is (note the 2MiB on 1/100 and 0Mib on 2/100):

  Qgroupid    Referenced    Exclusive   Path
  --------    ----------    ---------   ----
  0/5           16.00KiB     16.00KiB   <toplevel>
  0/256          1.02MiB      1.02MiB   sv

  Qgroupid    Referenced    Exclusive   Path
  --------    ----------    ---------   ----
  0/5           16.00KiB     16.00KiB   <toplevel>
  0/256          1.02MiB      1.02MiB   sv
  1/100          2.03MiB      2.03MiB   2/100<1 member qgroup>
  2/100            0.00B        0.00B   <0 member qgroups>

With this fix, which simply re-uses `qgroup` as the iteration variable,
we see the expected result:

  Qgroupid    Referenced    Exclusive   Path
  --------    ----------    ---------   ----
  0/5           16.00KiB     16.00KiB   <toplevel>
  0/256          1.02MiB      1.02MiB   sv

  Qgroupid    Referenced    Exclusive   Path
  --------    ----------    ---------   ----
  0/5           16.00KiB     16.00KiB   <toplevel>
  0/256          1.02MiB      1.02MiB   sv
  1/100          1.02MiB      1.02MiB   2/100<1 member qgroup>
  2/100          1.02MiB      1.02MiB   <0 member qgroups>

The existing fstests did not exercise two layer inheritance so this bug
was missed. I intend to add that testing there, as well.

Fixes: a0bdc04b0732 ("btrfs: qgroup: use qgroup_iterator in __qgroup_excl_accounting()")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1481,7 +1481,6 @@ static int __qgroup_excl_accounting(stru
 				    struct btrfs_qgroup *src, int sign)
 {
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup *cur;
 	LIST_HEAD(qgroup_list);
 	u64 num_bytes = src->excl;
 	int ret = 0;
@@ -1491,7 +1490,7 @@ static int __qgroup_excl_accounting(stru
 		goto out;
 
 	qgroup_iterator_add(&qgroup_list, qgroup);
-	list_for_each_entry(cur, &qgroup_list, iterator) {
+	list_for_each_entry(qgroup, &qgroup_list, iterator) {
 		struct btrfs_qgroup_list *glist;
 
 		qgroup->rfer += sign * num_bytes;


