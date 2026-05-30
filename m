Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD653242BE;
	Sat, 30 May 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159918; cv=none; b=b9pgiVK+NFAp698neeyWozvZp8YyoQS4YsJu6L8r+8KKPKlkuZkNvS0PRXRNGYApH41qC2wKkMGNFiHyzEQexYpgV+juNnWRjlAqwplM/zXMZlHFoZi7boVUcWMJnNoaIbRIBugqSqZwCgxORh47Fi1hXM+KoeKGCL7n3OcQKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159918; c=relaxed/simple;
	bh=iSqXGPgJXoExHATwvZkxlj9acyFc6v2Px1euksN+nnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axTd2Zeq9LmimLyBXi+MfvfBiylBaTCQE7dZaC4FcdKoj2B561qq0Kzrs2Ivx8FehC/VaQeEqV3y0Ta0wtZTq0TSxSWF4RW3GwIQXvqgTf5dOwP8c1VgoJ6P7ixJQUYOfSFR2GEmBElXtrmuV6lvljdMNAV30M0B5K4WuAZ/Hr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKlaqQ8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKlaqQ8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBA41F00893;
	Sat, 30 May 2026 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159917;
	bh=gWMdqIwAeclji0qwWULKJDOsoqX/32GZ+pt5EBdL8JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKlaqQ8Vd4U+et/icgRinxuFl+iU4dnQLbJFSLtslHWwmpisviZegBKgRhuGguW19
	 HzqAXbibzzc+CIHb+MOZUZ3JFRDccUwccOxS9vLqxKKS/Q/Nhr+xlsJHa/7IInWPJp
	 DjHmdg/tJUWqwOXliIllKf5ts5U7DgWEngyF4Zxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH 6.1 166/969] ibmasm: fix OOB reads in command_file_write due to missing size checks
Date: Sat, 30 May 2026 17:54:50 +0200
Message-ID: <20260530160305.099828202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 0eb09f737428e482a32a2e31e5e223f2b35a71d3 upstream.

The command_file_write() handler allocates a kernel buffer of exactly
count bytes and copies user data into it, but does not validate the
buffer against the dot command protocol before passing it to
get_dot_command_size() and get_dot_command_timeout().

Since both the allocation size (count) and the header fields (command_size,
data_size) are independently user-controlled, an attacker can cause
get_dot_command_size() to return a value exceeding the allocation,
triggering OOB reads in get_dot_command_timeout() and an out-of-bounds
memcpy_toio() that leaks kernel heap memory to the service processor.

Fix with two guards: reject writes smaller than sizeof(struct
dot_command_header) before allocation, then after copying user data
reject commands where the buffer is smaller than the total size declared
by the header (sizeof(header) + command_size + data_size). This ensures
all subsequent header and payload field accesses stay within the buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Link: https://patch.msgid.link/20260314165355.548119-1-LivelyCarpet87@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmasm/ibmasmfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -303,6 +303,8 @@ static ssize_t command_file_write(struct
 		return -EINVAL;
 	if (count == 0 || count > IBMASM_CMD_MAX_BUFFER_SIZE)
 		return 0;
+	if (count < sizeof(struct dot_command_header))
+		return -EINVAL;
 	if (*offset != 0)
 		return 0;
 
@@ -319,6 +321,11 @@ static ssize_t command_file_write(struct
 		return -EFAULT;
 	}
 
+	if (count < get_dot_command_size(cmd->buffer)) {
+		command_put(cmd);
+		return -EINVAL;
+	}
+
 	spin_lock_irqsave(&command_data->sp->lock, flags);
 	if (command_data->command) {
 		spin_unlock_irqrestore(&command_data->sp->lock, flags);


