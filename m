Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18723D9DBB;
	Mon,  4 May 2026 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904373; cv=none; b=TX2JYIqkfCBxOI6fU2kx3QObdkw8r3SBv9AHr2NrhQ6tE5lmIOhYvQnjubuDrqoTZ6HW8WkRhLfERwRoYrNn7ryVHr/I3exaerduLp6b84+luKsUpDnceNS7er6rLUwpqnG1GZgdVwYJGhRWq4fXcu3KWcOdWurqQh1vTcYOhvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904373; c=relaxed/simple;
	bh=DUjvJLdT/KqwjNZxfDpNr1MomlQnpz/JpkXyCwpq9B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzocbcuFeTerAZgVNYTffEK8AFvTA/oZ5Y7LYbHeY2kxm4GKN9fpB2N2PhPZkNFA6RmsWfAJcCp/XVnMalEqWp1rW73oX7VBbuvzxS6WVkLOIfrunHTXXnv2GMGLSOL0E8DfS11/1ZqZPlt9zWbITC5x4Mm/u38JISJwSYH1ZHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMxleRsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMxleRsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80267C2BCB8;
	Mon,  4 May 2026 14:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904372;
	bh=DUjvJLdT/KqwjNZxfDpNr1MomlQnpz/JpkXyCwpq9B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMxleRsdxQKI73hZdQe4W/41VDSqVwd/GnCZgaSGLst/72dQG1HFeDZrQ4Fd4Cfci
	 nJZ9m3p2yd7sF3Fctz4IB8x0gAzwNt6SHgKAYpTPQxQCZzHq6fsckSRSSPuxsExrj6
	 Oi2O7vOqzdB9j7rP7GPGe9z5mGha0pZacbY1SR3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH 6.12 014/215] ibmasm: fix OOB reads in command_file_write due to missing size checks
Date: Mon,  4 May 2026 15:50:33 +0200
Message-ID: <20260504135130.694592952@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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


