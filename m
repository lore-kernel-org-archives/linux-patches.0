Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876BC31ED6C;
	Wed,  3 Dec 2025 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779671; cv=none; b=ECeFGEpahfNDFqZdJdJl73cluS9EpVPdYIhQZVona9cF58Ze+VyF495Tgi8Kmx9dgnhHbPf44pZYDC+CLqRx4tZtSYA5rF4OlyQQv0Be+Z+OsO6nberlWzNpHb8R79suBbaYSDpmdavbi8Zzi7gq2noj/ClaZ0u4XodfuJO8yrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779671; c=relaxed/simple;
	bh=9q4x4IktGc//A31X25JPW3i6RIfIAIScv79D2l1K3UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=posPJTglP18JnW3FEp0yBXWoqGYKnAEG6pfzbPt8pcAszWLoy82tgDllZOtCjn3635btklCFj8/5SXlgqRGhgMuV/tcCfxu8rjRi1RPwpmg0lfCqTGi6RfOpSpWMnJIMSd8byrTTBWL35xnZ3eJ28DMUKPrKwSuNR+vnIbO2c1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5YCxRSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5YCxRSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8060C4CEF5;
	Wed,  3 Dec 2025 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779671;
	bh=9q4x4IktGc//A31X25JPW3i6RIfIAIScv79D2l1K3UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5YCxRSD7m/lS1luv+CabV9aDv6xJbLhk6hkQJOv9jNL4N01P612s5nnBgvzh4VDz
	 kINKqc5j5zfL8r6HVoC6hCRZNDaFd4dL61OYGsCzdbWZTjmDc7saCcKLkb2q5kpsTi
	 PlSHCMZHWdhawNQTglrM/CcgNcP/EzPS2t//vzn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 327/568] smb: client: validate change notify buffer before copy
Date: Wed,  3 Dec 2025 16:25:29 +0100
Message-ID: <20251203152452.686714245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 4012abe8a78fbb8869634130024266eaef7081fe upstream.

SMB2_change_notify called smb2_validate_iov() but ignored the return
code, then kmemdup()ed using server provided OutputBufferOffset/Length.

Check the return of smb2_validate_iov() and bail out on error.

Discovered with help from the ZeroPath security tooling.

Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: stable@vger.kernel.org
Fixes: e3e9463414f61 ("smb3: improve SMB3 change notification support")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3837,9 +3837,12 @@ SMB2_change_notify(const unsigned int xi
 
 		smb_rsp = (struct smb2_change_notify_rsp *)rsp_iov.iov_base;
 
-		smb2_validate_iov(le16_to_cpu(smb_rsp->OutputBufferOffset),
-				le32_to_cpu(smb_rsp->OutputBufferLength), &rsp_iov,
+		rc = smb2_validate_iov(le16_to_cpu(smb_rsp->OutputBufferOffset),
+				le32_to_cpu(smb_rsp->OutputBufferLength),
+				&rsp_iov,
 				sizeof(struct file_notify_information));
+		if (rc)
+			goto cnotify_exit;
 
 		*out_data = kmemdup((char *)smb_rsp + le16_to_cpu(smb_rsp->OutputBufferOffset),
 				le32_to_cpu(smb_rsp->OutputBufferLength), GFP_KERNEL);


