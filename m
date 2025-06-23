Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC35250BEC;
	Mon, 23 Jun 2025 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685483; cv=none; b=sk9rAeNDI2pRL5EDW/xGNrpY9iPad8O30dh/J94invjkHDOBU9syB84j+gZPUiYbzOeLtZQIcUDYZ6WblQXjSMAqodconYw+z8dAYTiwS5l6Bq6zg5UtydhOJYiaUFHGwgzs+EP8PePHXtRjExHwKh9clKbPkEZ3iLEBGVLM3nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685483; c=relaxed/simple;
	bh=yl4c5OchEmOYxadISc45+urR8SOv7ewBX8xSpPTJico=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0RMKt9m9yWgnDEZy1dzc9ZFI+RUQInjew5xSDfTnCAVGWsBivLQEyNAycTqVv12Xlg+IKKI5cBzJYZhD60thtQoRlmtbZ1paH0YxRM3R3PkuwoPC4OMCAUKhLJ+jipVB1OrgEJmTIscJz+BoRXd67X5JbZFmRQfzTUz7+kAosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TV3dP7QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV3dP7QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6D5C4CEEA;
	Mon, 23 Jun 2025 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685483;
	bh=yl4c5OchEmOYxadISc45+urR8SOv7ewBX8xSpPTJico=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV3dP7QS93RpD5Da3WO5DMiOn8JaC5Vj+N3p6ZMNhSjWbsXsjCixmLz+N35WZ/CoA
	 /lCit8Obox+RNABtDSLuWKvoYNpobYi5RXG6HKr2l1TWl7lIrV6bN944r/Li9vrAV1
	 T3KqJ1XIoH03JF9uySygPHPEirBysvWik3k+iPHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	MengEn Sun <mengensun@tencent.com>,
	Andrea Righi <andrea@betterlinux.com>,
	Fenggaung Wu <fengguang.wu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 122/222] mm: fix ratelimit_pages update error in dirty_ratio_handler()
Date: Mon, 23 Jun 2025 15:07:37 +0200
Message-ID: <20250623130615.767873576@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinliang Zheng <alexjlzheng@tencent.com>

commit f83f362d40ccceb647f7d80eb92206733d76a36b upstream.

In dirty_ratio_handler(), vm_dirty_bytes must be set to zero before
calling writeback_set_ratelimit(), as global_dirty_limits() always
prioritizes the value of vm_dirty_bytes.

It's domain_dirty_limits() that's relevant here, not node_dirty_ok:

  dirty_ratio_handler
    writeback_set_ratelimit
      global_dirty_limits(&dirty_thresh)           <- ratelimit_pages based on dirty_thresh
        domain_dirty_limits
          if (bytes)                               <- bytes = vm_dirty_bytes <--------+
            thresh = f1(bytes)                     <- prioritizes vm_dirty_bytes      |
          else                                                                        |
            thresh = f2(ratio)                                                        |
      ratelimit_pages = f3(dirty_thresh)                                              |
    vm_dirty_bytes = 0                             <- it's late! ---------------------+

This causes ratelimit_pages to still use the value calculated based on
vm_dirty_bytes, which is wrong now.


The impact visible to userspace is difficult to capture directly because
there is no procfs/sysfs interface exported to user space.  However, it
will have a real impact on the balance of dirty pages.

For example:

1. On default, we have vm_dirty_ratio=40, vm_dirty_bytes=0

2. echo 8192 > dirty_bytes, then vm_dirty_bytes=8192,
   vm_dirty_ratio=0, and ratelimit_pages is calculated based on
   vm_dirty_bytes now.

3. echo 20 > dirty_ratio, then since vm_dirty_bytes is not reset to
   zero when writeback_set_ratelimit() -> global_dirty_limits() ->
   domain_dirty_limits() is called, reallimit_pages is still calculated
   based on vm_dirty_bytes instead of vm_dirty_ratio.  This does not
   conform to the actual intent of the user.

Link: https://lkml.kernel.org/r/20250415090232.7544-1-alexjlzheng@tencent.com
Fixes: 9d823e8f6b1b ("writeback: per task dirty rate limit")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: MengEn Sun <mengensun@tencent.com>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Fenggaung Wu <fengguang.wu@intel.com>
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -562,8 +562,8 @@ int dirty_ratio_handler(struct ctl_table
 
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_ratio != old_ratio) {
-		writeback_set_ratelimit();
 		vm_dirty_bytes = 0;
+		writeback_set_ratelimit();
 	}
 	return ret;
 }


