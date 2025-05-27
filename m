Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E828030E;
	Tue, 27 May 2025 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368589; cv=none; b=sNbTCqMFyFBQqI1DNdSerZBLo0LpuWmqkehBVRl2bhKcG1/RCMTNXQU7GRcjcU1j4/3gNRsZLnhKIt4u6ydMPWBGr8t1Z0lPtmWc2ZKf4mjKa7L576MFoPrDnJXb5Hg7gQ7dhr8XMiQ0icQ5pX70Sm+eC6GA33/ADihH20sVuQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368589; c=relaxed/simple;
	bh=VPu62Jztkr8/Pu2M9q1kpAI3NWTVrHJN29Y9eDCbpPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoXzInkTBTAeJlUrwep8jRXPE+eJVxoXP8DlUA2nxtV9KYVUVZulBHk5u5reQ7ev2I/bCnXqm/Ny+jWjvQFiLhiOKV8ohS0eivvzvFSins2H4GFlyFKxTc4As2g5rJqJoeT0rlTQy9Ou7CJX7IgQYDqTpg1bQE9oQ/dXf+Nz8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7/7TLZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7/7TLZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DE0C4CEE9;
	Tue, 27 May 2025 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368589;
	bh=VPu62Jztkr8/Pu2M9q1kpAI3NWTVrHJN29Y9eDCbpPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7/7TLZ+zpW9JOoc0nwJdTzIraUzNu9gPTkZXro42JOOjbA4DH1T5KxhHFuSIeE4N
	 +YlR4xyVzRgmFIG37CUc6oW0mEUGNpnDDYa37ZmZYxaRgxfbfgQNVEVJPpOUPQP5VB
	 xZUHrZpenM9bc2KsoppaWIx+Gu5oXm3ysmhJYfJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 757/783] module: release codetag section when module load fails
Date: Tue, 27 May 2025 18:29:14 +0200
Message-ID: <20250527162543.950858207@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wang <00107082@163.com>

commit 221fcbf77578826fad8f4bfa0530b5b55bf9676a upstream.

When module load fails after memory for codetag section is ready, codetag
section memory will not be properly released.  This causes memory leak,
and if next module load happens to get the same module address, codetag
may pick the uninitialized section when manipulating tags during module
unload, and leads to "unable to handle page fault" BUG.

Link: https://lkml.kernel.org/r/20250519163823.7540-1-00107082@163.com
Fixes: 0db6f8d7820a ("alloc_tag: load module tags into separate contiguous memory")
Closes: https://lore.kernel.org/all/20250516131246.6244-1-00107082@163.com/
Signed-off-by: David Wang <00107082@163.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2852,6 +2852,7 @@ static void module_deallocate(struct mod
 {
 	percpu_modfree(mod);
 	module_arch_freeing_init(mod);
+	codetag_free_module_sections(mod);
 
 	free_mod_mem(mod);
 }


