Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411F933CE9A;
	Mon, 23 Mar 2026 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277101; cv=none; b=VgFBufqJfFfIaAvin77bafigWhYP5X92Bwq2BvHS9qNKC2KoWpg6A6G8PqPrI9wjSlD0hmRy/KOx4o42FuPg6UrjGLISkM3Z2mvi3r/LlFnAvrUfs5+ptMepQtDe61bbVcCYJSo5DNvQXHKqxXN9hZjxHu3oZT4/9uZdVfWOhJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277101; c=relaxed/simple;
	bh=7eJz5AtODHe8N27udAnIBWyn2XyPCCLydAzAWsMuEss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crNS+DOqJIkTpDuiXp6FpIJ/m4+wrHWIaxphui+YIuszqS5gaccY4FmRZ9cBXKGJqbIcKAxSypmVSItxc8hGkytmXPAEsHGkKVCWPGESdm+xy/3osU1RRn/g/c7ds2T8ez48AH9Cc6Zs5tFjXVoHrlG7FVmZUmU6/tCVFfgZX00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUh/Cdtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUh/Cdtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24F5C4CEF7;
	Mon, 23 Mar 2026 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277101;
	bh=7eJz5AtODHe8N27udAnIBWyn2XyPCCLydAzAWsMuEss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUh/CdtlKpwijRzjt5n8ly0R/5Gzb++9nniS1OvM/u32Zwjy8HGyvizrYQmb0+kfo
	 04wmrvu0TDKpyNOwOcZ6Qv/wR0sBuFUVtVmb+JO4RMIHLaDRIWzF8QGD0quayoj8Jq
	 GV3561/WeVZ4YEwx7s+QFEUybC7jLEvold/ElpZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 320/460] ksmbd: unset conn->binding on failed binding request
Date: Mon, 23 Mar 2026 14:45:16 +0100
Message-ID: <20260323134534.367735530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -1954,6 +1954,7 @@ out_err:
 			}
 		}
 		smb2_set_err_rsp(work);
+		conn->binding = false;
 	} else {
 		unsigned int iov_len;
 


