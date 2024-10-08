Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA81DE4CD;
	Tue,  8 Oct 2024 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392521; cv=none; b=TTyDqr4SyASMR//6om9tAUg69g4rt3R2Wm16LjACTk1xaXihRi8tiHmlQKS+M9X5mJUP55kmQfaYng68pfaMoEPb3+UWBq10qQ1QhhYFUFzUJFRdfWEBT4auS7fRXxV/qa7AAw4djn1OSBWLu3gQfmRwFOfy6k1TlpbAgM/Ie1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392521; c=relaxed/simple;
	bh=gEUQ9jGuDINRdsI8ltQJUNN06gOHlGYUqRHNDgwNh5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdUydnQn1s2XdPkjXo8bu34Pa5/ka879MUpwrdRDU8MyYAn+zKwPsf4OYCDICRwF9IN5ud2HllyhMq3K4kHYEklP/OztkSK9gSZXcii/lrlpn5zrPSskQ8TiAwITWCwOA7nDq3dgE45P7DDlnrPvdpR0jxMzJZ9oelL6XoKVa1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSppBb1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSppBb1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5323DC4CEC7;
	Tue,  8 Oct 2024 13:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392520;
	bh=gEUQ9jGuDINRdsI8ltQJUNN06gOHlGYUqRHNDgwNh5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSppBb1cY4caHhNalQ8/S48cD90+LcLFWOnX/24rCu+l8EgafPjPP9s6Ojm4T9H7V
	 r5u4E/QNM27pCvhbeXPmCH3QYvNxLkFeNZm8SNRSbivs635CCM5Te7HeK5CGo54Gcx
	 dBtQMMe2fxQeJ9QLHw1CZPWaeey+6SRlbSRg/yB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>
Subject: [PATCH 6.11 438/558] sysctl: avoid spurious permanent empty tables
Date: Tue,  8 Oct 2024 14:07:48 +0200
Message-ID: <20241008115719.506164739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 fs/proc/proc_sysctl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -29,8 +29,13 @@ static const struct inode_operations pro
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
@@ -42,7 +47,7 @@ static struct ctl_table sysctl_mount_poi
  */
 struct ctl_table_header *register_sysctl_mount_point(const char *path)
 {
-	return register_sysctl(path, sysctl_mount_point);
+	return register_sysctl_sz(path, sysctl_mount_point, 0);
 }
 EXPORT_SYMBOL(register_sysctl_mount_point);
 


