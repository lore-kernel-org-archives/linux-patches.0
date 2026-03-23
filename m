Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9949F265CA2;
	Mon, 23 Mar 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279103; cv=none; b=LWwApPZvlG5b6hVBJv/WSOOY6QZVp1ih+9CWO4V/m1d+v7ZXxqhj17/2x7+0GSpZGPhQM44aGZU6znIeyZq/mOs/1erniNw2r4ZyfvDTBtPXdVwvuKPXgEBni8MCmRjWzZ4JuY5gfHM+8/Yppsmr8vH2gq2BsXKoCUpOj5ZHwvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279103; c=relaxed/simple;
	bh=qGauyJNVWDKIUiYuhAxbulWy9D4f9EFI9TA4rzkuObg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=desLwhPeDByeNmAHaE4sr30gKuFi+R0aHGk/yrLue0Opy1HkjhXj4VLlGQDztCDrukIDBiuNQM/whZQjdZdDq0UIh/usDiyRmM0DbxdYU9m9doNNVHTeJJYqWBGvQsGVrhPAPFrfF23w7WcSl3Ov1qYINE/KG2q1DnKXByiTuyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzVpMQwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzVpMQwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107EDC4CEF7;
	Mon, 23 Mar 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279103;
	bh=qGauyJNVWDKIUiYuhAxbulWy9D4f9EFI9TA4rzkuObg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzVpMQwddi8nF1dR0sAKtqJXt3viBWDOkU8Z3VEy/nXs1x/x856eqaOs9slAVF+xe
	 3ukNarCH6E0RPhGHtCRtQC6AGEZiaynz4AJ3f3dhEqClr66GVAOoG3JfjqzBWZT6xv
	 pHWnG4m2fwPMGZ7fXFexjJvyr5Iqrqmw/xF2fZZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 462/567] ksmbd: unset conn->binding on failed binding request
Date: Mon, 23 Mar 2026 14:46:22 +0100
Message-ID: <20260323134545.412554061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -1934,6 +1934,7 @@ out_err:
 			}
 		}
 		smb2_set_err_rsp(work);
+		conn->binding = false;
 	} else {
 		unsigned int iov_len;
 


