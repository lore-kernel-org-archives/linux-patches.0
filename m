Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB27515E8B;
	Mon, 30 Dec 2024 15:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574373; cv=none; b=IRFxGQStX7KqsPaHX5JlWvnmshzE1B8wRiEE8oXhYdJKnnUITuIv5KA7BHe9BJu0JYgdgXsHWevIgX2HrSCKn+h/4NSVce8gLqyIMnpFhTjVENIldPcb4tZGf7g6vYDxFpHX4RTl7akgLXBEIdpCmH9i/DLwoctP0v/MrpKvgUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574373; c=relaxed/simple;
	bh=WULU8nHliZGxFr2zvWYSr9mI52/otOu4J9y46YX/jGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE7EByHniyqD/Em8XNMdFaJZ3urnpPNppmWzzSK1sDBKDsNOCJ2fLLD/Fas9WnNJQN4FR5YMbfhR6WHSJEQEmAt418hrtOXmxp1JQnngMDj4YocPAqrCV/twbtkLYrwGBfPaP5yehPKbIA52S6U4q0S2sJCcYBVO+l2OTtBkWkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt2eX7EQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt2eX7EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A758C4CED0;
	Mon, 30 Dec 2024 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574373;
	bh=WULU8nHliZGxFr2zvWYSr9mI52/otOu4J9y46YX/jGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt2eX7EQQ47F6+O7V/WYirnG15RtudFVaQcnlBAZZPn9BqaP7CWbkRq0vA00EvFNX
	 quOuNhnpHPxtb5xzvTo/YC3MTg8Qkb5NrMbL16wBUThPV1PW6xoncdkxpHiiwmA7sD
	 3jgkcXKg3WgmOn91x4MWNNTlchreIRdkAZMwaJ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 086/114] tracing: Prevent bad count for tracing_cpumask_write
Date: Mon, 30 Dec 2024 16:43:23 +0100
Message-ID: <20241230154221.404309776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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
@@ -5111,6 +5111,9 @@ tracing_cpumask_write(struct file *filp,
 	cpumask_var_t tracing_cpumask_new;
 	int err;
 
+	if (count == 0 || count > KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	if (!zalloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
 


