Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8623B6C06;
	Mon, 23 Mar 2026 14:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274524; cv=none; b=W3329oMgZGywDL/knnHJMm+1OAQZHAOpIxLoRkkqJrkKv7U2TCB+TMjDjoPM7G+JikCrum/42FPFaXYJ/6AL0ybnDRlb/fO+5qLL/KnhLyKsZShSz2AcjvOD5kZudmMlw+D2uvX9xkVEJ/KqLCPhs8X0vySH8AfwYqBpK2GrVnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274524; c=relaxed/simple;
	bh=p8O8FV5LI8aeF0VZezTt4m2Da5dZKvq0uOaccBxuvFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuJsH5za6bQnWgFvH4/68bby+C1vkoD4yZ5Wko0L1Ks9XCoCRgt+sUhFOQf1XjIKXxyMLL/98TFCa1rIObRDM63cqEzydF7Lvv6uXAD8yB3bXmDRsOqg0LzQM7isZ75bOq4ovGHDTNq6N862sCOYPjZTPIFmVkBqYcGDzqz8crg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2+ZtlCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2+ZtlCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0017BC2BC9E;
	Mon, 23 Mar 2026 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274524;
	bh=p8O8FV5LI8aeF0VZezTt4m2Da5dZKvq0uOaccBxuvFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2+ZtlCkqy55GNbnm1nSPXvG8Zg1IPDnt15rw2zG9BOUPrgMy9mNug/u3ZQl7cCTl
	 VWwggsK6Gow4DD8iek+NeYJ+8+44PWFpHbD0MtElZiJ412gTslUGS+xlqS7Htti+pg
	 j4Wz82vrMJI4mE0iPIooo6nZBQLyKh8fqDdcBEzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 024/212] ksmbd: unset conn->binding on failed binding request
Date: Mon, 23 Mar 2026 14:44:05 +0100
Message-ID: <20260323134504.520521031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 282343cf8a4a5a3603b1cb0e17a7083e4a593b03 upstream.

When a multichannel SMB2_SESSION_SETUP request with
SMB2_SESSION_REQ_FLAG_BINDING fails ksmbd sets conn->binding = true
but never clears it on the error path. This leaves the connection in
a binding state where all subsequent ksmbd_session_lookup_all() calls
fall back to the global sessions table. This fix it by clearing
conn->binding = false in the error path.

Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1957,6 +1957,7 @@ out_err:
 			}
 		}
 		smb2_set_err_rsp(work);
+		conn->binding = false;
 	} else {
 		unsigned int iov_len;
 


