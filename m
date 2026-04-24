Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2716221DB6;
	Fri, 24 Apr 2026 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038140; cv=none; b=J6v1rfjf8L/PSZ3qzJ/6FAaBIbE6McRwTk9/1/eU4wfH4fHCeetMu68LBgdzMD8BSvlGjOfnTWDlhCYe90Fe4yDQ1PsQQua5KY6PyM2y2h1aKoBkwNtq/9ESHlieSE+JYJ+4n2H71+czbYbzUFD3dEwfPASI7TiFwkzK2S8NPJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038140; c=relaxed/simple;
	bh=+GOXf6BDeMkYM6Y7AxK+V9UL091KfenP/FQCd05r4DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2mXRZdbOs2fV3/NDtZbrjVPbVqA/jWGMdPQsbBvV9BBoML60fkB0gigYeiJ4bOaTj+zUbhVTH5UxeRO54foBgpqx6Tsi37w4UEnrod4vwZ9snNKOto9tH3Ym9//MHYUmeYRwnCbuVrgStScAPQY1I19S+OoL7v0DUGisVydrek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxSNpGhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxSNpGhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EBEC19425;
	Fri, 24 Apr 2026 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038140;
	bh=+GOXf6BDeMkYM6Y7AxK+V9UL091KfenP/FQCd05r4DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxSNpGhirTy+7KzDs8HbnB/Lp1DccgjqnfNhjVQBr4AKEV5259Vbm1vaQhdoGdJo7
	 7oQiGkkW0AE5bq1cyW9SqwUERqyuIFEwGXKjCx86d8g4poP7S4JmkAllzAoMV8qTWi
	 8e0hC+mKW83SY49SdyVlu/COlJSRUjoL5UKcGIms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 40/55] smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path
Date: Fri, 24 Apr 2026 15:31:19 +0200
Message-ID: <20260424132438.329903672@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1775,6 +1775,12 @@ replay_again:
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


