Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520C1A680B;
	Mon, 23 Mar 2026 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275647; cv=none; b=f9K9qD1tiz0xDYKXY69jNA72igqEiRJgQe1uX+u/529W2186/S82XujxeEE5pjyigsdiZpzQuNq840MsDAIFbZ6o6uNaYqdh/oZn2aoW7xceRY5OQrDenF4Y5MfbaqVkyLBQQLPDFgUvslk+jzRlTI9LhaaFBP4oqEEL5Wygx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275647; c=relaxed/simple;
	bh=tLbaMiAoRG1U73qlXfp1jb+bEFhBklkc9iK0zj3wbfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+UDBcHxlBYMUUov1qR3dYDFgCG5E76B1vMogtKx5dJZ1LbaATzAk17tKIwLmWZxCvHOVHGen/rfMDchVJIHPcbGfMA2Zr5gKMku1VGD4HpVR+VHNO2W/Wi3rjj5W14D2l3ZVkDKSGMCCA56dUH2JMoP/Dh4EWJRTKwmDgnZ+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjms8ias; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjms8ias"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEDCC4CEF7;
	Mon, 23 Mar 2026 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275646;
	bh=tLbaMiAoRG1U73qlXfp1jb+bEFhBklkc9iK0zj3wbfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjms8ias0rcbdfG/+J1e6HWec+PNMnwe6rah7FFVoZz9Wr1VgS7TuEfFpBISq8NNK
	 YmYW1K+3DgN0RWR+q+8JMUYCcPMnqGyPRLk5SqSpqp51c4cEjjgTeF8kzj4YyzpyQ9
	 XeiTmYlTGm0b97j2vQTK7i5JiAK3ugcBu3n5w0UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 171/460] smb: server: fix use-after-free in smb2_open()
Date: Mon, 23 Mar 2026 14:42:47 +0100
Message-ID: <20260323134530.741558936@linuxfoundation.org>
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

From: Marios Makassikis <mmakassikis@freebox.fr>

commit 1e689a56173827669a35da7cb2a3c78ed5c53680 upstream.

The opinfo pointer obtained via rcu_dereference(fp->f_opinfo) is
dereferenced after rcu_read_unlock(), creating a use-after-free
window.

Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3615,10 +3615,8 @@ int smb2_open(struct ksmbd_work *work)
 
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
-	rcu_read_lock();
-	opinfo = rcu_dereference(fp->f_opinfo);
+	opinfo = opinfo_get(fp);
 	rsp->OplockLevel = opinfo != NULL ? opinfo->level : 0;
-	rcu_read_unlock();
 	rsp->Flags = 0;
 	rsp->CreateAction = cpu_to_le32(file_info);
 	rsp->CreationTime = cpu_to_le64(fp->create_time);
@@ -3659,6 +3657,7 @@ reconnected_fp:
 		next_ptr = &lease_ccontext->Next;
 		next_off = conn->vals->create_lease_size;
 	}
+	opinfo_put(opinfo);
 
 	if (maximal_access_ctxt) {
 		struct create_context *mxac_ccontext;


