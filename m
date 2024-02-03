Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99CCFBF2;
	Sat,  3 Feb 2024 04:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933511; cv=none; b=IrBttJY++q880xHMjfwANJRBj6VhXsfZncYc8feUR0mMvMRNGfU+M+mIp8SoQ5nSC4V1wxIwlI8eZTnlg68N4lCQwBNISTFk4y2fP65sleGuiTnhceHKF7tkzb6MeI09RMBpw7Y6Dvrc3JKCawjtw7vZVapG9UzcnRVKmmb0Pzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933511; c=relaxed/simple;
	bh=uFc26fBd6YUNLASkbzuaUh2x2Jp4izCai2nlcc51sf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snV5EO9Sj0BYWyPJTX8S+LbFizTJEFOrdMZasbZyzF659RwzeQw+CJZVWJ0DLQEV2e1U/AM1ML456rwjPrkcoE1xCj8DzcaXea49x912R9XA65Qt2lT5jHl75KooMY5b6ModVr+0fAfIW+7fn891EPNMzk8dNEmhbm28tLm9Wv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiEyRYof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiEyRYof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18D7C433F1;
	Sat,  3 Feb 2024 04:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933511;
	bh=uFc26fBd6YUNLASkbzuaUh2x2Jp4izCai2nlcc51sf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiEyRYofQ3zyL84RkIgNHWuxBON6GPhV53mVZQEW2rzerS+y2Gs5LqoWTFQMWBSN2
	 z6pKjjJaS5iflZMJsnp2z42rmRK+xrbi1W9W4cYHA3VLoPLdii5zSpJ/ZKDonNGeOT
	 0FYNXQc9vIc9WB4FXWU/RdeU9xpeIA65UEVfSw8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Granados <j.granados@samsung.com>,
	kernel test robot <oliver.sang@intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/322] sysctl: Fix out of bounds access for empty sysctl registers
Date: Fri,  2 Feb 2024 20:02:25 -0800
Message-ID: <20240203035400.659252071@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Granados <j.granados@samsung.com>

[ Upstream commit 315552310c7de92baea4e570967066569937a843 ]

When registering tables to the sysctl subsystem there is a check to see
if header is a permanently empty directory (used for mounts). This check
evaluates the first element of the ctl_table. This results in an out of
bounds evaluation when registering empty directories.

The function register_sysctl_mount_point now passes a ctl_table of size
1 instead of size 0. It now relies solely on the type to identify
a permanently empty register.

Make sure that the ctl_table has at least one element before testing for
permanent emptiness.

Signed-off-by: Joel Granados <j.granados@samsung.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202311201431.57aae8f3-oliver.sang@intel.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index de484195f49f..5b5cdc747cef 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -44,7 +44,7 @@ static struct ctl_table sysctl_mount_point[] = {
  */
 struct ctl_table_header *register_sysctl_mount_point(const char *path)
 {
-	return register_sysctl_sz(path, sysctl_mount_point, 0);
+	return register_sysctl(path, sysctl_mount_point);
 }
 EXPORT_SYMBOL(register_sysctl_mount_point);
 
@@ -233,7 +233,8 @@ static int insert_header(struct ctl_dir *dir, struct ctl_table_header *header)
 		return -EROFS;
 
 	/* Am I creating a permanently empty directory? */
-	if (sysctl_is_perm_empty_ctl_table(header->ctl_table)) {
+	if (header->ctl_table_size > 0 &&
+	    sysctl_is_perm_empty_ctl_table(header->ctl_table)) {
 		if (!RB_EMPTY_ROOT(&dir->root))
 			return -EINVAL;
 		sysctl_set_perm_empty_ctl_header(dir_h);
@@ -1213,6 +1214,10 @@ static bool get_links(struct ctl_dir *dir,
 	struct ctl_table_header *tmp_head;
 	struct ctl_table *entry, *link;
 
+	if (header->ctl_table_size == 0 ||
+	    sysctl_is_perm_empty_ctl_table(header->ctl_table))
+		return true;
+
 	/* Are there links available for every entry in table? */
 	list_for_each_table_entry(entry, header) {
 		const char *procname = entry->procname;
-- 
2.43.0



