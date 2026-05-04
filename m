Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5FD3D47D0;
	Mon,  4 May 2026 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902865; cv=none; b=c+MPutNiLP8O3qpKZMC9uJMVqJKZj5a2oZMJJflPVH6XZcdwEdQMW8dpHORc6gHV5bJsbKphImtDDPYdxgXT8GRcECfepWnaDZMKjaoja/Vq+mI3sKq6fW2qVP3vV9T9w9oNvsWoQY7XLbxTCuEnLNn8PSQlOMzUCPsFIAqCqdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902865; c=relaxed/simple;
	bh=0BjoDPx8GFbPw7yEBjHCgefNqnPpL/LOQiEsWFioBEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSIr0j5T01Ahw4Zd3snPMY1trScalo2POv6vwKWvBw0EyJX8xtKSJXtvNzer7LeJUsddm146RYqOzURB3iV85e7nYVD052pwoq08BgMzRm9gAVhcKcvUg8CJzZIZtIXeLF+d17L1rHj9Ezyddr3FnOfn//U4dJCZ6Dq1VyvmZJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1K8t4OkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1K8t4OkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE13FC2BCB8;
	Mon,  4 May 2026 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902865;
	bh=0BjoDPx8GFbPw7yEBjHCgefNqnPpL/LOQiEsWFioBEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1K8t4OkUj7jW7mynnS+FQBX1XhpngH8nMkhYD0A/4Cvkd+KBrNjxVdIwGY+PY4rm5
	 0Evks5YCVc8ZQN/FBa+LYlQC5iShoMrjYzFahZ1mnUYrR6W+ZDN2EszpSmIz2rr9mw
	 N88i5yjYxCt9BD31icMG9xim7V1ebULJTs0WkbpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	ychen@northwestern.edu,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH 7.0 013/307] misc: ibmasm: fix OOB MMIO read in ibmasm_handle_mouse_interrupt()
Date: Mon,  4 May 2026 15:48:18 +0200
Message-ID: <20260504135143.325708297@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 4b6e6ead556734bdc14024c5f837132b1e7a4b84 upstream.

ibmasm_handle_mouse_interrupt() performs an out-of-bounds MMIO read
when the queue reader or writer index from hardware exceeds
REMOTE_QUEUE_SIZE (60).

A compromised service processor can trigger this by writing an
out-of-range value to the reader or writer MMIO register before
asserting an interrupt. Since writer is re-read from hardware on
every loop iteration, it can also be set to an out-of-range value
after the loop has already started.

The root cause is that get_queue_reader() and get_queue_writer() return
raw readl() values that are passed directly into get_queue_entry(),
which computes:

  queue_begin + reader * sizeof(struct remote_input)

with no bounds check. This unchecked MMIO address is then passed to
memcpy_fromio(), reading 8 bytes from unintended device registers.
For sufficiently large values the address falls outside the PCI BAR
mapping entirely, triggering a machine check exception.

Fix by checking both indices against REMOTE_QUEUE_SIZE at the top of
the loop body, before any call to get_queue_entry(). On an out-of-range
value, reset the reader register to 0 via set_queue_reader() before
breaking, so that normal queue operation can resume if the corrupted
hardware state is transient.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Fixes: 278d72ae8803 ("[PATCH] ibmasm driver: redesign handling of remote control events")
Cc: stable@vger.kernel.org
Cc: ychen@northwestern.edu
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Link: https://patch.msgid.link/20260308062108.258940-1-LivelyCarpet87@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmasm/remote.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/ibmasm/remote.c
+++ b/drivers/misc/ibmasm/remote.c
@@ -177,6 +177,11 @@ void ibmasm_handle_mouse_interrupt(struc
 	writer = get_queue_writer(sp);
 
 	while (reader != writer) {
+		if (reader >= REMOTE_QUEUE_SIZE || writer >= REMOTE_QUEUE_SIZE) {
+			set_queue_reader(sp, 0);
+			break;
+		}
+
 		memcpy_fromio(&input, get_queue_entry(sp, reader),
 				sizeof(struct remote_input));
 


