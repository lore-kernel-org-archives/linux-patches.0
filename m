Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603748F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D515CC433C7;
	Sun, 16 Jul 2023 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537608;
	bh=Xw1ldOvh5cxXQOHAzdqNI9rFo1LD/6yRyJjj0pFFMi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfRdDgqvp/l05xSPbj/qLXsBwrv/lm6OFU8jjGiGbOAlJ0KwBmZapTR5iw0sXmU7Q
	 h6R1jO2JzyVflMK5CqiW/CeJOXjzdP3kl0UHWI40WZ5/jSm4RY5oUyHzM6yO+yOn7+
	 IDb8r1QuPYHcqev2DbB9OU3d6g4VcNTS1qK+4U10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Baoquan He <bhe@redhat.com>,
	Cong Wang <amwang@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Michael Holzheu <holzheu@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 157/800] kexec: fix a memory leak in crash_shrink_memory()
Date: Sun, 16 Jul 2023 21:40:10 +0200
Message-ID: <20230716194952.759387198@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 1cba6c4309f03de570202c46f03df3f73a0d4c82 ]

Patch series "kexec: enable kexec_crash_size to support two crash kernel
regions".

When crashkernel=X fails to reserve region under 4G, it will fall back to
reserve region above 4G and a region of the default size will also be
reserved under 4G.  Unfortunately, /sys/kernel/kexec_crash_size only
supports one crash kernel region now, the user cannot sense the low memory
reserved by reading /sys/kernel/kexec_crash_size.  Also, low memory cannot
be freed by writing this file.

For example:
resource_size(crashk_res) = 512M
resource_size(crashk_low_res) = 256M

The result of 'cat /sys/kernel/kexec_crash_size' is 512M, but it should be
768M.  When we execute 'echo 0 > /sys/kernel/kexec_crash_size', the size
of crashk_res becomes 0 and resource_size(crashk_low_res) is still 256 MB,
which is incorrect.

Since crashk_res manages the memory with high address and crashk_low_res
manages the memory with low address, crashk_low_res is shrunken only when
all crashk_res is shrunken.  And because when there is only one crash
kernel region, crashk_res is always used.  Therefore, if all crashk_res is
shrunken and crashk_low_res still exists, swap them.

This patch (of 6):

If the value of parameter 'new_size' is in the semi-open and semi-closed
interval (crashk_res.end - KEXEC_CRASH_MEM_ALIGN + 1, crashk_res.end], the
calculation result of ram_res is:

	ram_res->start = crashk_res.end + 1
	ram_res->end   = crashk_res.end

The operation of insert_resource() fails, and ram_res is not added to
iomem_resource.  As a result, the memory of the control block ram_res is
leaked.

In fact, on all architectures, the start address and size of crashk_res
are already aligned by KEXEC_CRASH_MEM_ALIGN.  Therefore, we do not need
to round up crashk_res.start again.  Instead, we should round up
'new_size' in advance.

Link: https://lkml.kernel.org/r/20230527123439.772-1-thunder.leizhen@huawei.com
Link: https://lkml.kernel.org/r/20230527123439.772-2-thunder.leizhen@huawei.com
Fixes: 6480e5a09237 ("kdump: add missing RAM resource in crash_shrink_memory()")
Fixes: 06a7f711246b ("kexec: premit reduction of the reserved memory size")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 3d578c6fefee3..22acee18195a5 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1122,6 +1122,7 @@ int crash_shrink_memory(unsigned long new_size)
 	start = crashk_res.start;
 	end = crashk_res.end;
 	old_size = (end == 0) ? 0 : end - start + 1;
+	new_size = roundup(new_size, KEXEC_CRASH_MEM_ALIGN);
 	if (new_size >= old_size) {
 		ret = (new_size == old_size) ? 0 : -EINVAL;
 		goto unlock;
@@ -1133,9 +1134,7 @@ int crash_shrink_memory(unsigned long new_size)
 		goto unlock;
 	}
 
-	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
-	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
-
+	end = start + new_size;
 	crash_free_reserved_phys_range(end, crashk_res.end);
 
 	if ((start == end) && (crashk_res.parent != NULL))
-- 
2.39.2



