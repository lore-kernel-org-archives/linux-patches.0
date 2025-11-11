Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C27303A1C;
	Tue, 11 Nov 2025 01:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825466; cv=none; b=o7nXXfXtgCxe4ExyV+gnWSAC+n/D/uhPttn1AeOJph6r05Y2dWarrS60xecFRNenLAiIhurwfuzarL60NZCsIsqHXrMFHrwRyFJUiCH4fKVFZaVnzMdWHqm6o4Z351wunEaxw3D0b1gu1AdzvSaFQfkwFiQMQqOhLl7k0jEAuMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825466; c=relaxed/simple;
	bh=QSfxZqTAxiaash0CcXlxooNuhvHhYcGpmYzGMTI5zD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTWkTmQiLLUF8bxiiHjxcAdrsPTJcOg5iB8jBMuOFOl0itHXT81dlApMw8F1KFi1a9qLYXEciai6/GpWZunZmVgCXc9i4PEO+248oDlZrDzXAeZn8KMYptyk2Jmv0lTnBz1lV8macPCcrcqk6qD0kdQQkNKeHgErsYnXlOjDAec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4ji82X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4ji82X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC7EC4CEF5;
	Tue, 11 Nov 2025 01:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825466;
	bh=QSfxZqTAxiaash0CcXlxooNuhvHhYcGpmYzGMTI5zD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4ji82X9Ty5xKD2LygD7QxfrziVpSPfqGl1Rl2xBTyoMJMPvCcTfXlgrvvpoToVXj
	 PA58sPZGsZiXnPibAabGXSiZXjUikWhR/3i/CyrH60iQEwpO7vr3zVItEGkF+WFrgK
	 Mz1xathkFl/CY6DkuFPNNw6WQ1nsrRFT+2gJOQmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 815/849] smb: client: validate change notify buffer before copy
Date: Tue, 11 Nov 2025 09:46:25 +0900
Message-ID: <20251111004556.130343674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
@@ -4054,9 +4054,12 @@ replay_again:
 
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


