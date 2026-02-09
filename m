Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9246C37C0E2;
	Mon,  9 Feb 2026 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647802; cv=none; b=GL47U3gWhHJw1Zef0YXkhCTfDK065jg4VWghmehaJVS4WIudEJLdreWkHAU+0NMn7kFThvPmx/Vjp74GOv/IAE1NHXmV7s4SK2Pa8TqyLdL3qXvgiFHta91KJEMV/kFeaL3StOzoZ51c1HJZe26xjXUb7xQVk7Kzx0dyLqpXMso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647802; c=relaxed/simple;
	bh=eW6tXNX6PY12/GulqWzQzfTlDneBlvh87aYH0+mcIo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwRMXRGTLP89ZswQvQFb7DXcuJZ3MSZNBbROu4hzUfluOBQxGkjCuM/ox1FKWVSeIZpmuUF6+umoysVdow9Y2s0ywcQSeKWF7Ot7GZaVwzIFT+ujmlzuH+dcG/RmhCWpZ/HsAzgVIHeelaeLstJBJZEDSMch6eqHS+Vd3Zvnm7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2a7katY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2a7katY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4854C116C6;
	Mon,  9 Feb 2026 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647802;
	bh=eW6tXNX6PY12/GulqWzQzfTlDneBlvh87aYH0+mcIo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2a7katYzV98axkPPEcLlNx5X9p8WHVUcRMXnQf0l9d6by4OyeYW4Ro0PQYQlNF7t
	 a75TO8NAPKAwM12IH4/ArxBk0zmHBsusS9UftTR9nzgi/p+8WicYNtWomeHJggIJOO
	 a6/ASioksWUQMReY/b4ZWJEn5LNERaBkkBESQhh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Steven Moreland <smoreland@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12 025/113] binder: fix BR_FROZEN_REPLY error log
Date: Mon,  9 Feb 2026 15:22:54 +0100
Message-ID: <20260209142311.112749332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Carlos Llamas <cmllamas@google.com>

commit 1769f90e5ba2a6d24bb46b85da33fe861c68f005 upstream.

The error logging for failed transactions is misleading as it always
reports "dead process or thread" even when the target is actually
frozen. Additionally, the pid and tid are reversed which can further
confuse debugging efforts. Fix both issues.

Cc: stable@kernel.org
Cc: Steven Moreland <smoreland@google.com>
Fixes: a15dac8b2286 ("binder: additional transaction error logs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260123175702.2154348-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3749,8 +3749,9 @@ static void binder_transaction(struct bi
 	return;
 
 err_dead_proc_or_thread:
-	binder_txn_error("%d:%d dead process or thread\n",
-		thread->pid, proc->pid);
+	binder_txn_error("%d:%d %s process or thread\n",
+			 proc->pid, thread->pid,
+			 return_error == BR_FROZEN_REPLY ? "frozen" : "dead");
 	return_error_line = __LINE__;
 	binder_dequeue_work(proc, tcomplete);
 err_translate_failed:


