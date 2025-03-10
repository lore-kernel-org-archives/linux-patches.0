Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901861B3927;
	Mon, 10 Mar 2025 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627393; cv=none; b=Ch8GWFksm9I2mPml1bdpXEmuZ6G2TLuSS2sCn0hx/jMgnPeS4k9xrCyDc+ETTBLJaw/3Awj0lJZFVl1NWQ3zoZDcS3S+NPONL7zNkP0fMeAO3R18sIxPlAb6M67OI4Z5JQ6yEQ+hrNWkA+USMukTXrpNFaBD+lqD7VJrBii2Eyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627393; c=relaxed/simple;
	bh=Fy6wIe2C0Y0LMzjtPogGdALSRoZfLQnZh/62ObIxdaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzAn6zWWyKvnGe/kXtH0YuH+v3T+oTfRtrxfGJaC0HvoNZWhi71mFH1s8Q/u5ZXj4XBfU6nESwXMgZXIYBefWU00vfshNLD4eZt/PlD9uxwS0gohtc2FCVgQvLt7LsFobFet1HA4iwz5etPc8xUpuXrdRr4/ybD0SEVx4HtGX9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjbM+67D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjbM+67D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181FEC4CEE5;
	Mon, 10 Mar 2025 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627393;
	bh=Fy6wIe2C0Y0LMzjtPogGdALSRoZfLQnZh/62ObIxdaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjbM+67DwSea6yw1eIkssGTdmv6987aw28Dax5UDG6ylFaSd4LAXZarYNCQvUMyDT
	 J8HDcd0PauLK+f0fh2GIrWcr3kqkX99rD3fZAPZkUWNgRl19Ouxo/nWHJVgP1UAx+J
	 4+NX13y+HG4AvyrGBZTmYPrjrHfHjragIClS51v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 083/269] ksmbd: fix type confusion via race condition when using ipc_msg_send_request
Date: Mon, 10 Mar 2025 18:03:56 +0100
Message-ID: <20250310170501.029788421@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit e2ff19f0b7a30e03516e6eb73b948e27a55bc9d2 upstream.

req->handle is allocated using ksmbd_acquire_id(&ipc_ida), based on
ida_alloc. req->handle from ksmbd_ipc_login_request and
FSCTL_PIPE_TRANSCEIVE ioctl can be same and it could lead to type confusion
between messages, resulting in access to unexpected parts of memory after
an incorrect delivery. ksmbd check type of ipc response but missing add
continue to check next ipc reponse.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -281,6 +281,7 @@ static int handle_response(int type, voi
 		if (entry->type + 1 != type) {
 			pr_err("Waiting for IPC type %d, got %d. Ignore.\n",
 			       entry->type + 1, type);
+			continue;
 		}
 
 		entry->response = kvzalloc(sz, GFP_KERNEL);


