Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D924F19F485;
	Tue, 27 Aug 2024 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770660; cv=none; b=KVI7/LwLGy0LJ7oFZ+SMY0bFqDTSMNJVuRxtcdQ+3rNIgGnllnrT0sbtyZ+j9YLXH5zy8ufOWqJkJcL3IMU7WQfbNuE/pXUi36ISr+bNIKl63qMGOWx0k0pR6mdE3wqMvJsHLNWzcNq0YJg9trjDeH1UHLGT+/FXjZIoBbdz8Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770660; c=relaxed/simple;
	bh=q1BunPWm7Vjog0RFa2gKtchMVHytCtxU3YQoS5xreiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBLOgb/0K0gfHQXzU75JZQLumTwYU7tCP+teMhbohIWWFyTgrd/glr77wTT1C016mGOzduPaR3IAncpgh0+3qW3UarlN0E6t17snpdWL2N6wUZuO3g8y/am8IuAAeoLUr8TQO6hPKEwBBQAvfWKBp6FfrfKh9zc1xp/tyQMYCxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsMmlXTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsMmlXTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B98C61040;
	Tue, 27 Aug 2024 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770660;
	bh=q1BunPWm7Vjog0RFa2gKtchMVHytCtxU3YQoS5xreiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsMmlXTlG7IRs5XzbFsq6B0jeWkxAOeJjEmB+05u/qO3NTLJEKDCMLVEu5WFhYLbo
	 +pBRGBitBrZjfcYIkd/fCPB5GK4KAuZMQDiZOTPY5axMzChESAKevOJbNUh6yzLZaX
	 ru9+m6q/ppnHhf+qgRD3Z0yET2K9cwPldKJNzKeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 296/341] ksmbd: the buffer of smb2 query dir response has at least 1 byte
Date: Tue, 27 Aug 2024 16:38:47 +0200
Message-ID: <20240827143854.657832245@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit ce61b605a00502c59311d0a4b1f58d62b48272d0 upstream.

When STATUS_NO_MORE_FILES status is set to smb2 query dir response,
->StructureSize is set to 9, which mean buffer has 1 byte.
This issue occurs because ->Buffer[1] in smb2_query_directory_rsp to
flex-array.

Fixes: eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4406,7 +4406,8 @@ int smb2_query_dir(struct ksmbd_work *wo
 		rsp->OutputBufferLength = cpu_to_le32(0);
 		rsp->Buffer[0] = 0;
 		rc = ksmbd_iov_pin_rsp(work, (void *)rsp,
-				       sizeof(struct smb2_query_directory_rsp));
+				       offsetof(struct smb2_query_directory_rsp, Buffer)
+				       + 1);
 		if (rc)
 			goto err_out;
 	} else {


