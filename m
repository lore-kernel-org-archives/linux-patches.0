Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A3A278750;
	Tue, 27 May 2025 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366132; cv=none; b=LbiyslvD7scZ2s5UhMNckE209NXHZckd4iJfd5sIBNSutk2cRLbpAiR4ut+6G+l2wICCtwiCSUortbmtak/D4E5insBrI/g+UHP5IvFtoIsQusmEXPumtul/Pqg/36HW4z5F1zhtQhdcs6szMel8KfnlBq+X75ymL3pL2TM2Edc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366132; c=relaxed/simple;
	bh=T3oPzj9BD7oMI4CQOO2qtKhA/ZGS09+qp7v+Kqjvuk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUzsE+sDsydxVix/ev23aAY1ddT5+HHtd8O6lyKPq0cvTnONdgWV09oEWGKLK1Y4MAMAAlt3D/R6pnIjDM64sCPDvPWnNrZPjQ5Mv2Bm6Li+rHt54UAz58/uCBxdfGgdcAWkAsH7EifoY1RYncA1jLEmFUL+6itk4+HxOinLU/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng4eycxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng4eycxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B10C4CEE9;
	Tue, 27 May 2025 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366132;
	bh=T3oPzj9BD7oMI4CQOO2qtKhA/ZGS09+qp7v+Kqjvuk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ng4eycxmuIRumD7BbMjYGc2yi6U8LNe1wNEaXEmU5mIhCwUV9mCOffZQ1NE+KIhlC
	 44KzjodaPabkA6cgvQ7ZtfUVCCeBoiqhdyCtDMQbuHH0TUwvwbSOBaa9Hqik8rxLFc
	 UEZsyofOe+CVfEqE/lSAVE7dOSBbSN3VtLQNqGWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"Erhard F." <erhard_f@mailbox.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 601/626] mm: vmalloc: actually use the in-place vrealloc region
Date: Tue, 27 May 2025 18:28:14 +0200
Message-ID: <20250527162509.416496786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

commit f7a35a3c36d1e36059c5654737d9bee3454f01a3 upstream.

Patch series "mm: vmalloc: Actually use the in-place vrealloc region".

This fixes a performance regression[1] with vrealloc()[1].


The refactoring to not build a new vmalloc region only actually worked
when shrinking.  Actually return the resized area when it grows.  Ugh.

Link: https://lkml.kernel.org/r/20250515214217.619685-1-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Closes: https://lore.kernel.org/all/20250515-bpf-verifier-slowdown-vwo2meju4cgp2su5ckj@6gi6ssxbnfqg [1]
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4115,6 +4115,7 @@ void *vrealloc_noprof(const void *p, siz
 		if (want_init_on_alloc(flags))
 			memset((void *)p + old_size, 0, size - old_size);
 		vm->requested_size = size;
+		return (void *)p;
 	}
 
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */


