Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82D314A4E0;
	Tue, 23 Apr 2024 21:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908751; cv=none; b=qcAc73x/rhAlURF2OFjBdtfi+6OBY+9LfK0EHnOrxby0iSeXcPjDUsqtJYc57Ir1kbT00w7XM1djJNw3CItaTbJe+HVWy82Tj2sK1OPFyRABf5gY5tsY9ZO3RouRr9GQKUCc+tauLDI2ITUXxUTo1gkXoGWNQdK35OPz8GfmuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908751; c=relaxed/simple;
	bh=H6Peiw2WiHhxqz9oHdfyT6l7fpxwnyuXisW3x1HF6E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dx/L81tsp7slMcuN4F0FhFO8IZUXvAyiF7+a814Qo2nTBLjjevUFJiRZ0/i3WqGFCZ+isoHUiG+9SZEn7uPcaFvZ08fk4liLQ8A/uiren367KWhtMutcH+uIjdAFmts5mMHc9CqZmMJioLy+IjVnyWe5JzwpJmumCO1zeaneyck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugvQ0E9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugvQ0E9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7365FC32783;
	Tue, 23 Apr 2024 21:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908750;
	bh=H6Peiw2WiHhxqz9oHdfyT6l7fpxwnyuXisW3x1HF6E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugvQ0E9sGIEJqONtSka/1J7Ar5n+OVy4cmJH62v1UfGWlvP4V2qnzgGXOZE9xdQOs
	 TDA4cL7Fa3iWvcByS0MUyMv0PSxKDuxr0T0B4Fd0qnC0QITy6Z4ZCjL2Z8PtiN+Yc1
	 OOmFAZlDUw8dKxUjd44Cvh9y7fWW5hPSPsERXlRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 125/141] init/main.c: Fix potential static_command_line memory overflow
Date: Tue, 23 Apr 2024 14:39:53 -0700
Message-ID: <20240423213857.262698649@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <ytcoode@gmail.com>

commit 46dad3c1e57897ab9228332f03e1c14798d2d3b9 upstream.

We allocate memory of size 'xlen + strlen(boot_command_line) + 1' for
static_command_line, but the strings copied into static_command_line are
extra_command_line and command_line, rather than extra_command_line and
boot_command_line.

When strlen(command_line) > strlen(boot_command_line), static_command_line
will overflow.

This patch just recovers strlen(command_line) which was miss-consolidated
with strlen(boot_command_line) in the commit f5c7310ac73e ("init/main: add
checks for the return value of memblock_alloc*()")

Link: https://lore.kernel.org/all/20240412081733.35925-2-ytcoode@gmail.com/

Fixes: f5c7310ac73e ("init/main: add checks for the return value of memblock_alloc*()")
Cc: stable@vger.kernel.org
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/init/main.c
+++ b/init/main.c
@@ -633,6 +633,8 @@ static void __init setup_command_line(ch
 	if (!saved_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len + ilen);
 
+	len = xlen + strlen(command_line) + 1;
+
 	static_command_line = memblock_alloc(len, SMP_CACHE_BYTES);
 	if (!static_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len);


