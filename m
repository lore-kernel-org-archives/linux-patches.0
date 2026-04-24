Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599E919A288;
	Fri, 24 Apr 2026 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038058; cv=none; b=ER2Z3e8FE7Rm2hNH0AvSlzV2EQOhQZEe8HXmWRmbwxRqqpnmggNDUvQ+fmlOfWzuWJisxalmS1WZbQyGOoeR6uMbcoDan7i2DddgZtHWMgFk7HqT4i8GeStXm1EGkrGEZ34QhbNRFYqLkqY6lgzhqpG5oaDVb1pwivO+Aa+9u/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038058; c=relaxed/simple;
	bh=yllJQDdxsTb3i+3VS8gOlFtsbi1woPLTIPvGNAyUWWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQeCp4E4ycCre0QUVASQWJpw0LfjGxwKnckohbH/+lbtS5w5QAsREUJaAAQiW6hpAmZ5YWZa0wwnr9SywrsBNtRZtlYbPQ0//v9naVC1uT8L6LL7QOlje1EPyO5tpc1CZDplNv111jlYm/bkPsczScfbnWfCUpU177KT1lJWFjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8gv4G1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8gv4G1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BCBC19425;
	Fri, 24 Apr 2026 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038058;
	bh=yllJQDdxsTb3i+3VS8gOlFtsbi1woPLTIPvGNAyUWWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8gv4G1kGIw3IpYJ1yg/XDOFkPRea73YTDktJHdfxX4tRlJLZ8qP5cD0Wurg5vOaw
	 Fmqt7AJUkeeWak/3XeWgH4Ooi3Hy6Fv535Qsgl4gfD+8V/q8SqSrVFcw2KiGTuIcAQ
	 8gYsmnARgds7ck3HstMb4m4AfXY3sqCgOTeejDAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 153/166] smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path
Date: Fri, 24 Apr 2026 15:31:07 +0200
Message-ID: <20260424132605.153488256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit a58c5af19ff0d6f44f6e9fe31e33a2c92223f77e upstream.

smb2_ioctl_query_info() has two response-copy branches: PASSTHRU_FSCTL
and the default QUERY_INFO path.  The QUERY_INFO branch clamps
qi.input_buffer_length to the server-reported OutputBufferLength and then
copies qi.input_buffer_length bytes from qi_rsp->Buffer to userspace, but
it never verifies that the flexible-array payload actually fits within
rsp_iov[1].iov_len.

A malicious server can return OutputBufferLength larger than the actual
QUERY_INFO response, causing copy_to_user() to walk past the response
buffer and expose adjacent kernel heap to userspace.

Guard the QUERY_INFO copy with a bounds check on the actual Buffer
payload.  Use struct_size(qi_rsp, Buffer, qi.input_buffer_length)
rather than an open-coded addition so the guard cannot overflow on
32-bit builds.

Fixes: f5778c398713 ("SMB3: Allow SMB3 FSCTL queries to be sent to server from tools")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1739,6 +1739,12 @@ replay_again:
 		qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 		if (le32_to_cpu(qi_rsp->OutputBufferLength) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(qi_rsp->OutputBufferLength);
+		if (qi.input_buffer_length > 0 &&
+		    struct_size(qi_rsp, Buffer, qi.input_buffer_length) >
+		    rsp_iov[1].iov_len) {
+			rc = -EFAULT;
+			goto out;
+		}
 		if (copy_to_user(&pqi->input_buffer_length,
 				 &qi.input_buffer_length,
 				 sizeof(qi.input_buffer_length))) {


