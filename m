Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA2226B0BC;
	Thu, 13 Feb 2025 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460070; cv=none; b=Anj9wnyflCbTPD/23D2Nm+vdPLYpGmz1iiu+xz11gEz0UkmY6lwVXwMGN2cYSmoElKQTfzblKIpxRgMjdQ6DBAvx5BaK7A3Cvun6HSzHXgpHvHlqIwWERkc36hDuptYebnRrv76s6Q7zK2v+d0FRiJaeRllHvhaSpDRT5qV8m9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460070; c=relaxed/simple;
	bh=Rw9SFSa5pfgPIyRrzhMq6yEIXumOCQswnssD5PtJ/KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtF9I5Tf4UW431VqmR92bYPSSaU7kFDLls7kUrwTvf9sVNJUgDrlTbnmr0u4Zd0AhhniH9q/iJLKG0YAG5q574HTsDWKcluoOMK3FGZqZDDAnSdqPug3M3oXtuQIOWm3BEW1lqoZ1MykE2KHXG97LAnBYybIFXWDtQsfIuVTmu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrb5vupm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrb5vupm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7B0C4CED1;
	Thu, 13 Feb 2025 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460070;
	bh=Rw9SFSa5pfgPIyRrzhMq6yEIXumOCQswnssD5PtJ/KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrb5vupmNezPXRrjhTN437xXbnBRdBwlQlIJggJiVzL8Km7QfBAbxDc0YyMeBVW6F
	 Qz72hq05QGsr8o0Z86LbT8jHqJ3JXKHAHIXzsj3EsM63WIdM4dgXcQx8VLE3XLMhCs
	 6+D0572Cx3KCrksZio6GDP0rmJ26OvwlHRwtVZkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Barry Song <baohua@kernel.org>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 418/443] scripts/gdb: fix aarch64 userspace detection in get_current_task
Date: Thu, 13 Feb 2025 15:29:43 +0100
Message-ID: <20250213142456.742767628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 4ebc417ef9cb34010a71270421fe320ec5d88aa2 upstream.

At least recent gdb releases (seen with 14.2) return SP_EL0 as signed long
which lets the right-shift always return 0.

Link: https://lkml.kernel.org/r/dcd2fabc-9131-4b48-8419-6444e2d67454@siemens.com
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/cpus.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/cpus.py
+++ b/scripts/gdb/linux/cpus.py
@@ -167,7 +167,7 @@ def get_current_task(cpu):
             var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
             return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
-        current_task_addr = gdb.parse_and_eval("$SP_EL0")
+        current_task_addr = gdb.parse_and_eval("(unsigned long)$SP_EL0")
         if (current_task_addr >> 63) != 0:
             current_task = current_task_addr.cast(task_ptr_type)
             return current_task.dereference()


