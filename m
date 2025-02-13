Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F001FFC69;
	Thu, 13 Feb 2025 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460909; cv=none; b=ZBy8qy2evtHu8Vi+0oiJdO9y3UZqJKrBFk3v3qUUIP4jVwZ77hpCXqgnitDQ1Bd1KAZFjTNGn9uRgSCgyUngHC4T1MoIIIjYD3xVo2mxVQHnM8Vejkr/DvYFl3laHWlrNOMw4aEDJZayKxyr9urUwahPG/fXMpooBMOO0qFZ+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460909; c=relaxed/simple;
	bh=wo1pTweRFNPB3DsLoy0P4smY2TkVMU+RrSK32QJ9CCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CM69sYg9JOp6cSiZMhFlZtE/Fo1Tf384aP7gjVf03h+9GQ7mJ1YYm8YNW/a/puy7TSoDgd9TYBg06SxHoQYr7csRgq3LVWYvoDyO4sdGdjKBA2iv2xwL5HRSOtdMrldcae6qGFlCjVt6n3jU/pWL2q4FOHQnMy724UYk+AfxF5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLz7aKv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLz7aKv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058A0C4CEE9;
	Thu, 13 Feb 2025 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460909;
	bh=wo1pTweRFNPB3DsLoy0P4smY2TkVMU+RrSK32QJ9CCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLz7aKv6zTRDsCWLlJokNCsTWoNEbzSdyTHLeUSpkvesSkMhBYRtmNZeueKb//jla
	 4oa+nx5Ue41uvVoqUrg9+AUWr6hT4hJhly0M6Omz3jIq1JiPS8mYFbJ78F8enKeDI+
	 c1H0aXO6mmDGIe/8+5Dj3bm+MsbZ0hE+bIgB+Fto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Barry Song <baohua@kernel.org>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 248/273] scripts/gdb: fix aarch64 userspace detection in get_current_task
Date: Thu, 13 Feb 2025 15:30:20 +0100
Message-ID: <20250213142417.232638341@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -172,7 +172,7 @@ def get_current_task(cpu):
             var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
             return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
-        current_task_addr = gdb.parse_and_eval("$SP_EL0")
+        current_task_addr = gdb.parse_and_eval("(unsigned long)$SP_EL0")
         if (current_task_addr >> 63) != 0:
             current_task = current_task_addr.cast(task_ptr_type)
             return current_task.dereference()


