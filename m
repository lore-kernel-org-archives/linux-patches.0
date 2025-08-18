Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4A431AF14;
	Mon, 18 Aug 2025 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522729; cv=none; b=mdWCrJw953rf5md9Rg5LGOAorDR9IMrc7QfwTZXmRwyJJ3tcYALp7RTq5Uth/r31OXsIkUkVW7LmrB3cMcND1gpae4UH+7VP29QcZsFjxkKvcve4u5k2vrWgygN2a4/SR6tlp6BqHiftxfLKxxNH/DnwVMZNhNz42+4vxfILHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522729; c=relaxed/simple;
	bh=As/38ufJaXlmve227v+rwIzZ7ZcrtFy5m6NSdazVP9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nidi+CdcggU9Eu/d5sjyPkUPzQUPn8mT4HwKFtK97lDTe5Byal8l5To8B1M1/0gclIxOhdfIZstJLZC45yW1duQf38rdBWXd0DXmVk1KZpLu/MguXsbAVivl+AuKqfSI9Tg87bMCO+XGUneXp10Ts7GMMcIAmtFdK1cSwJXAM3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kngen8kI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kngen8kI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D71FC4CEEB;
	Mon, 18 Aug 2025 13:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522728;
	bh=As/38ufJaXlmve227v+rwIzZ7ZcrtFy5m6NSdazVP9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kngen8kIT2XacE7uT4Y9pUIjLtCtYjkZxGOfOA2Poo1hApLhdUNpi0xLqRZB1jJeN
	 uS4L8f4xE1UT4PvplvHWUvEJQHybO18AVfgwZLWcC2RiMpAgRZNR1KdsGtkBam2PuH
	 HfZqaJi7SBR9UEPhQcpcf7kJUv9GCOrUUZqrtGjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 404/444] btrfs: fix iteration bug in __qgroup_excl_accounting()
Date: Mon, 18 Aug 2025 14:47:10 +0200
Message-ID: <20250818124504.079423166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1492,7 +1492,6 @@ static int __qgroup_excl_accounting(stru
 				    struct btrfs_qgroup *src, int sign)
 {
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup *cur;
 	LIST_HEAD(qgroup_list);
 	u64 num_bytes = src->excl;
 	int ret = 0;
@@ -1502,7 +1501,7 @@ static int __qgroup_excl_accounting(stru
 		goto out;
 
 	qgroup_iterator_add(&qgroup_list, qgroup);
-	list_for_each_entry(cur, &qgroup_list, iterator) {
+	list_for_each_entry(qgroup, &qgroup_list, iterator) {
 		struct btrfs_qgroup_list *glist;
 
 		qgroup->rfer += sign * num_bytes;


