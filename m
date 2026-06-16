Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2713191BA;
	Tue, 16 Jun 2026 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636515; cv=none; b=n3j+lQyB65ZenV96JqtHm05mSPMj0CrGKRSMiV2K6WPLHriecxfDqwBa/M/L1bm+d6TiBim3xJEs/87+LjL3XuXdI33Pjp9xlwcJB9+bZqTFv2l/m8dCeF+nEo3tDXG5jNFXyW/sRxVD+RQKZuLGE96T/NN6ECzadqm/36JRPkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636515; c=relaxed/simple;
	bh=0V6uTzDJZBx9DXlwOM9VZByI362vScaTW+Mx3KkChE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Unzw9cdgh8DvtKz3D0THSW3LL8LZIhm7CFxoNgbNtEnje+Gcs1ZfFUHWFqMxDSas/qTYTMNXgi1VRkgcmp+sZ3QW35Y1a6gNoAxsFD6BuXnWgCHTt+26CpPlBhvJVvm2R8GrwBqyPg8Q2fngNLS+ikDNNaeEc7traVTO7tTHPT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnGyE0YD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnGyE0YD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F119D1F000E9;
	Tue, 16 Jun 2026 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636513;
	bh=cIVcAvv6cFwz5KEI8hicO1mKZdXiJkK4KtlCEbkJv8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnGyE0YDi/0ZLMsroCGnIt98oVmjdNR6TIRgxOlZ3aQC0U+HM9a5tIJ6EsXGdwBtz
	 5BEFPI1otbywlSbD96NY8kQ0HJ3HXRRCI3Ur44H/E1W8CdIphJY3WW29Pq6fdGC043
	 7todUSQehglYd+/UH3E3lFda/gtpDECs1jyo9g04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/342] smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path
Date: Tue, 16 Jun 2026 20:28:36 +0530
Message-ID: <20260616145058.444065085@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit a58c5af19ff0d6f44f6e9fe31e33a2c92223f77e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1720,6 +1720,12 @@ smb2_ioctl_query_info(const unsigned int
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


