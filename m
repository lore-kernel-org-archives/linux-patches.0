Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D211E485;
	Tue,  8 Oct 2024 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390728; cv=none; b=pgQLtmaCEi34I8/HVpC2FYWQ4u3wiahD3fdKyy6epAI928udGv2y48DttPSDNuHRytbbltScquOD71LMsO85J1he6TE40J+grs7ymY4UUfdew5bemC3+3DBggV+Zx+YwQ5WZj/DG81rVQvJLchT8cs2jgQI6lBtzaiSruKxvkL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390728; c=relaxed/simple;
	bh=vzxus5TqzihteuDGgjRghlx8+OMIekTErMSlbnif3Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5QY0kGMT++D8COH198BMAih7ronHNUr/3lUpmZnzrauDrSZMZfNppGetnrk/nU1uwL0zw5QhN4n6lC1SLSRSLzIivU9a5RyupyaSB7QtFyWywYYrNaNPWziL/fQ/GJ7v96T29XTEViMEhrOU7zclPx27WD9V3AUhqFdYLP/hlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMVYjRyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMVYjRyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7112BC4CECD;
	Tue,  8 Oct 2024 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390727;
	bh=vzxus5TqzihteuDGgjRghlx8+OMIekTErMSlbnif3Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMVYjRygcDuFHca1KM9JPdXi9QMyy9q+lDk2bDlZc49urYeYn6Y5Gwbw/tWYjP0Pt
	 CMTQ/DUn2cknJmgRNenqFnn8ONyr7SlOOK3rNnO66rgmrkwkx4eWeYgQ5Efx3zKIr3
	 /GMHnAdgiSe3Hvhk7NLtAVimoGxlTpRq8HtKrTYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>
Subject: [PATCH 6.10 375/482] sysctl: avoid spurious permanent empty tables
Date: Tue,  8 Oct 2024 14:07:18 +0200
Message-ID: <20241008115703.178103938@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 559d4c6a9d3b60f239493239070eb304edaea594 upstream.

The test if a table is a permanently empty one, inspects the address of
the registered ctl_table argument.
However as sysctl_mount_point is an empty array and does not occupy and
space it can end up sharing an address with another object in memory.
If that other object itself is a "struct ctl_table" then registering
that table will fail as it's incorrectly recognized as permanently empty.

Avoid this issue by adding a dummy element to the array so that is not
empty anymore.
Explicitly register the table with zero elements as otherwise the dummy
element would be recognized as a sentinel element which would lead to a
runtime warning from the sysctl core.

While the issue seems not being encountered at this time, this seems
mostly to be due to luck.
Also a future change, constifying sysctl_mount_point and root_table, can
reliably trigger this issue on clang 18.

Given that empty arrays are non-standard in the first place it seems
prudent to avoid them if possible.

Fixes: 4a7b29f65094 ("sysctl: move sysctl type to ctl_table_header")
Fixes: a35dd3a786f5 ("sysctl: drop now unnecessary out-of-bounds check")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Closes: https://lore.kernel.org/oe-lkp/202408051453.f638857e-lkp@intel.com
Signed-off-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 9553e77c9d31..d11ebc055ce0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -29,8 +29,13 @@ static const struct inode_operations proc_sys_inode_operations;
 static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
-/* Support for permanently empty directories */
-static struct ctl_table sysctl_mount_point[] = { };
+/*
+ * Support for permanently empty directories.
+ * Must be non-empty to avoid sharing an address with other tables.
+ */
+static struct ctl_table sysctl_mount_point[] = {
+	{ }
+};
 
 /**
  * register_sysctl_mount_point() - registers a sysctl mount point
@@ -42,7 +47,7 @@ static struct ctl_table sysctl_mount_point[] = { };
  */
 struct ctl_table_header *register_sysctl_mount_point(const char *path)
 {
-	return register_sysctl(path, sysctl_mount_point);
+	return register_sysctl_sz(path, sysctl_mount_point, 0);
 }
 EXPORT_SYMBOL(register_sysctl_mount_point);
 
-- 
2.46.2



