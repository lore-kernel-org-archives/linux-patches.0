Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086D01369B4;
	Mon,  6 Jan 2025 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178812; cv=none; b=DydUpNtFpZ9JgbXVIvCjwfm8gXs+qaNfc9FscYDynKX3cLSr7hteRZ5QfM4tW9C5EzqwoMUlKE2q416CFu3DiVbYkbJkX2CaKV7WasZh789Hp4iqVgNng+5Y1f4DTahuNuoLgtftSCWflA6ZSeAWIu5RbZk8jN5W+hyrDIB6gRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178812; c=relaxed/simple;
	bh=3hpsOB9Q/YcG7dBvxEXa3HoaYkV9xe6UA5ZqKMcpLlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGKmwGYGKAn96vWzudMBzA9oK6eUMxo/zEZ4FQreb6KJguFIriLR9hogjTIqKO9+BBH8yC8t2K62G5qVbtVe4h9WeLZUS1QR7aEzfU+k+SX7134e3k/oEj+YgVD0f/DJUezilga+8zFmmZvhwFm+b5K5fGLRVnfvPqW65ad4gfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vULkw2nS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vULkw2nS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E42C4CED2;
	Mon,  6 Jan 2025 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178811;
	bh=3hpsOB9Q/YcG7dBvxEXa3HoaYkV9xe6UA5ZqKMcpLlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vULkw2nSusixe1d7YelCbeuApgbk3RQWt+1LENgXKFSUScr4cbVry3ndhrr6ZkTGD
	 /PiQ48lHCVOPNzPPxKlkqjbwtnhJjYyLY3wqoqqUSsY63PIErHJJG690qlHDGexthG
	 eF4kcWV3hsGp4pBwBMejeLy3kHERpldQjM9lgLss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 099/168] tracing: Prevent bad count for tracing_cpumask_write
Date: Mon,  6 Jan 2025 16:16:47 +0100
Message-ID: <20250106151142.201793507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 98feccbf32cfdde8c722bc4587aaa60ee5ac33f0 upstream.

If a large count is provided, it will trigger a warning in bitmap_parse_user.
Also check zero for it.

Cc: stable@vger.kernel.org
Fixes: 9e01c1b74c953 ("cpumask: convert kernel trace functions")
Link: https://lore.kernel.org/20241216073238.2573704-1-lizhi.xu@windriver.com
Reported-by: syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0aecfd34fb878546f3fd
Tested-by: syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5250,6 +5250,9 @@ tracing_cpumask_write(struct file *filp,
 	cpumask_var_t tracing_cpumask_new;
 	int err;
 
+	if (count == 0 || count > KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	if (!zalloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
 


