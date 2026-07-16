Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05F227732;
	Thu, 16 Jul 2026 14:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211547; cv=none; b=HSTl82ssIfcZ0xE2gf4BsJQvlPy/OKaXsVSIZ6G6wkBebHbVCxdADPZY03CRC1Y6JkG4FfBr3ZmknxYfpWgN3P/qZDqiAu7B4dRYpQbd4IPqg7VyIlQgbn9tNelpjB78eG+YLpseAWWOi6rjmI3ZuIKAyyCMgj6YDQsF8iGSylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211547; c=relaxed/simple;
	bh=lPPdyxPQgjQcCJWjXhUTnhHtgqfTIndBAylcbp1vqh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9FoLE4x7m8hMjPIXZzXQ+d6sN3CQ7o7OtPee9Z7z1M+GwMGuSMoPbpeZ5OlEid9sDY+elVe7S4g2rmXlRQfhePPbRGA3cyTmVJe1cbZ3GmJ2PA9aBtD8leB3Q68P7PClhXqggQbxQSGgHBu8EkIWrIFN6f8WosDS28E8P4i7io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQfE/SPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQfE/SPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624491F000E9;
	Thu, 16 Jul 2026 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211545;
	bh=Tf5OdcOuHeY0OlfAAnKr0ZBcTSrO7daXZtC08LNdWRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQfE/SPzV5qLdGPdbtCN3qFoAyiHqCUiBFsmpyUXSkX5W5C7YOMPo1mQitZxot8l1
	 pmcJiq3QNEE5iMx4Q7WHYZI8svD4d22u55UzppQdwroh8NAvj+InQcAZiP++1FDFTh
	 WDzM5XzgFO7jNqA9rmyk64FRQ6ApeblRLr2M50zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 415/480] iommufd: Avoid partial fault group delivery in iommufd_fault_fops_read()
Date: Thu, 16 Jul 2026 15:32:42 +0200
Message-ID: <20260716133053.790718361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

commit 091ab6d70dc444f56ed14faedbcacfc979f4c613 upstream.

The cookie returned by xa_alloc() in iommufd_fault_fops_read() is per fault
group, but the inner copy_to_user() runs per fault inside the group. If a
copy fails mid-group, xa_erase clears the cookie and the group is restored
to the deliver list, yet done is not rolled back. The function returns the
partial byte count, with the successfully copied faults sitting at offsets
below done carrying the now-erased cookie. The next read() then re-fetches
the group, allocates a fresh cookie, and re-delivers every fault including
the ones already copied; userspace sees duplicates carrying the new cookie,
and a stale cookie that can never be responded to.

Use a local group_done variable that tracks the per-group progress inside
the inner loop, and only commit done = group_done after the inner loop has
finished successfully. On a copy_to_user failure the outer break skips the
commit, so done remains at its prior start-of-group baseline; the partial
bytes already written past done are undefined to userspace per the read(2)
contract, and the next read re-delivers the whole group atomically.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Link: https://patch.msgid.link/r/360cab4d4aeccb0bae275a970e2b3c340a71e0e0.1780343944.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -139,6 +139,8 @@ static ssize_t iommufd_fault_fops_read(s
 
 	mutex_lock(&fault->mutex);
 	while ((group = iommufd_fault_deliver_fetch(fault))) {
+		size_t group_done = done;
+
 		if (done >= count ||
 		    group->fault_count * fault_size > count - done) {
 			iommufd_fault_deliver_restore(fault, group);
@@ -160,16 +162,17 @@ static ssize_t iommufd_fault_fops_read(s
 			iommufd_compose_fault_message(&iopf->fault,
 						      &data, idev,
 						      group->cookie);
-			if (copy_to_user(buf + done, &data, fault_size)) {
+			if (copy_to_user(buf + group_done, &data, fault_size)) {
 				xa_erase(&fault->response, group->cookie);
 				iommufd_fault_deliver_restore(fault, group);
 				rc = -EFAULT;
 				break;
 			}
-			done += fault_size;
+			group_done += fault_size;
 		}
 		if (rc)
 			break;
+		done = group_done;
 	}
 	mutex_unlock(&fault->mutex);
 


