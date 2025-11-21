Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBBC1F09B3;
	Fri, 21 Nov 2025 13:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731204; cv=none; b=dKNpz6ylmUge8yJkXSqjA89MhBVWQ/xG7om4uo3CyvDe+5jJUPdWpTXUW1VHAbYgKlT0qK3XN99ZZ16vn4LR10V3ayFeM4nEiimZFZkEdHSb5d6l/DN3Opv+Wf6Oqn/J/E5IK75THnefZADTaOLpuPy2rQJ7GaXVYwH3Glw40GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731204; c=relaxed/simple;
	bh=uNat1hXm1fbC458sWEA5woG7wSVRNS6bkJKh3YrXjbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnJur/raR3VR1GgkxAhwGT5H0NtqWOasUpLdWPpQKwjU+OR0PME4kNbIP2TT1OaQpBqxg4WPgaWt6hE/YtiEOL6kK3LCrT5vTCZ/szstlEA79ZtKBtJEtwP6UDX10bnfZH6Wi/8wT4xAbi9umOEkJiAkcuHWhqcMFcabmHChmq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFBs6KG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFBs6KG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9088C4CEF1;
	Fri, 21 Nov 2025 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731204;
	bh=uNat1hXm1fbC458sWEA5woG7wSVRNS6bkJKh3YrXjbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFBs6KG334Zovbh8xCxJ3KhHYliIyNO9A0MQfnvRLHgJbBPFZ4N4PoVFF/nNNEE0t
	 FaRyFdDTfV1IakROqGEKOchuL5+L0EPXJDbN3Cg8pZdm13263S0y7IMBb1KN0Vtyrl
	 xUxL4coo/P/CTvraviUelwwLldgWJBhBhK6Pv90Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/247] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Fri, 21 Nov 2025 14:11:14 +0100
Message-ID: <20251121130159.285769323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90f601b497d76f40fa66795c3ecf625b6aced9fd ]

bm_register_write() opens an executable file using open_exec(), which
internally calls do_open_execat() and denies write access on the file to
avoid modification while it is being executed.

However, when an error occurs, bm_register_write() closes the file using
filp_close() directly. This does not restore the write permission, which
may cause subsequent write operations on the same file to fail.

Fix this by calling exe_file_allow_write_access() before filp_close() to
restore the write permission properly.

Fixes: e7850f4d844e ("binfmt_misc: fix possible deadlock in bm_register_write")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251105022923.1813587-1-zilin@seu.edu.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a839f960cd4a0..a8b1d79e4af07 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -837,8 +837,10 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}
-- 
2.51.0



