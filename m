Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD1626B08D;
	Thu, 13 Feb 2025 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458372; cv=none; b=jT15ZY/zotznc5uQvh0bbokAQ1Co+EAJab3auWjnLTLc3qKPnPTkVlZnGE+OX0FuI3qlvBpWcZTY1DdUrOnYv7sDObmabt9muogiCWqMYYaHVfiIENbOzm9RARHzXjRkbMg5s13iOWREczSMHDcZ1xf16tGXv3JpXseMTkgC3L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458372; c=relaxed/simple;
	bh=RYKlpUzax2uDLhNruf0xJi+sgFWddeEI8moAnvBI3Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T38wE2VDII/X2iromBzE9x66tA4OUVyonwakVKA2AZoCbII0LMtq8+lKLVXqMtRdrMQeWRJ0gl1UCfZOfWSJ/Ju9sl5u0jLqRne2Mn1Rossv7DCuwVrG9nAuL7JsRMrUk82G204X8RgSj0SVu1ZFnkXGvWtlh51ZcoInng2TN2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnxHrFVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnxHrFVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E66C4CED1;
	Thu, 13 Feb 2025 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458372;
	bh=RYKlpUzax2uDLhNruf0xJi+sgFWddeEI8moAnvBI3Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnxHrFVv8mPEj9Q60VeXSk/p7+3ThMCn1ObyzeHdRhhwNXVB5E4F+wuXMKjU2qWNH
	 ftXdIbDeu1UmZELZKlu593NHtC+Wlcsef0vGk8idLt+Bk9U5Um5m0yB6HOZoLS0bf3
	 mlonZeVpQQ0oEC68Xd0YU5rcX2iGFECAVMQdHvTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Barry Song <baohua@kernel.org>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 381/422] scripts/gdb: fix aarch64 userspace detection in get_current_task
Date: Thu, 13 Feb 2025 15:28:50 +0100
Message-ID: <20250213142451.249900514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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


