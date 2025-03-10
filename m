Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182FC23372A;
	Mon, 10 Mar 2025 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626518; cv=none; b=mTe6O5SZQjfO4ToGWVVdjC4wK/cwGpnb+f5WFG/aYhYTsjR64BT8lcOKdEtq0Otw7hnLRokGcT5swrLvVov684dxsQtVsFuwxLTHexoYbXcdiqBnZSH0VhWaAPOtdPtGAqzZVNdqJLEyJVclcsd+oFdDrLBwZFNGMfybfumSjiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626518; c=relaxed/simple;
	bh=17vZxk8dopXOFKzZ0PqTCBqm0Ha4035TzrVPw1Wetvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1kLTA2pol82gVEbqQfZkHzqYKrBAFR2r1ZNVf2MtKQm3q00lP5rQli7WV6taKTYbxeH3gDBw4tnNCJKM7NGMX7jn7jxekTwkEKp2Bd+Qo9V6NdJaH1IWYvYTWGbNRDzNCa1KxyUYEVFVBFQTcdcm9fLKo45G24QSWLnUEvnPRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjI2OcQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjI2OcQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEC2C4CEE5;
	Mon, 10 Mar 2025 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626517;
	bh=17vZxk8dopXOFKzZ0PqTCBqm0Ha4035TzrVPw1Wetvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjI2OcQDHsggT5rfbcO3hLG6gLAViKE1H3qQbtMVQFQmdt0DhQhPkQmkSYP1zkxCb
	 XrI6ji8dSdxAWRI3HuIF+a+qtnoBwpoV+x623xB0yMrWMER7sElZ/N/HMdwJlJ2YoE
	 xng1yiHa5psARUoXx9l9GlOZe7Vzlk8fjEkAfom0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 020/207] ksmbd: fix type confusion via race condition when using ipc_msg_send_request
Date: Mon, 10 Mar 2025 18:03:33 +0100
Message-ID: <20250310170448.573338898@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 
 		entry->response = kvzalloc(sz, KSMBD_DEFAULT_GFP);


