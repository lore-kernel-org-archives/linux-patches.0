Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED103F7A9D;
	Tue, 17 Mar 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766647; cv=none; b=fylH7og7+Kqf6SDd3kRBAfH3HFSnHHZn43b5QfC26h+I5TQRNsVaPd+B/im9A4U83eQyB53cZ4FVr62TvEezYvcQagpLfAW/Opf25aYfMQyenOaJaC2/YDrrsvmGQkwicbodZm0+lYxxk4H4qeF8gS1WavpBGdbad0dbHEb3YoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766647; c=relaxed/simple;
	bh=EvmKxSUMuTfBaadqsNg9zb6BLzBnTOFIWYUdlbqn/sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDVxrHczvzsUdkO9SgG+sETI0h3vEq19bcA8aP4JCFeECyHTm7ttj5nbo5UXUDsGK75hgUCBhwUb7i/NeuTtwLZ8B4d5h7ICTL2FYHeNWgrenRkrXPlXvP9UYPNKQAN7F9T0OdHhtbdvJpxi5qDyC1gTW4/0j9a5luHQDXXDGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSmSNA3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSmSNA3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BDCC2BCB3;
	Tue, 17 Mar 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766647;
	bh=EvmKxSUMuTfBaadqsNg9zb6BLzBnTOFIWYUdlbqn/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSmSNA3YrC6elzlYJVtk5QX9zn5AnaogBg6E/MetQop4W/liDVZbLu0Qlck5u/AMS
	 p3Cq/pvBFh8H4q1mRPK5JQR34TDaXD5umP87V0VIQ2Pfy1/FzVrxOEMyfnK6/q/NUC
	 VZjM6tN6dIiR3Mi485UPo/A3N9jHZUiP4mt95IEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 291/378] smb: server: fix use-after-free in smb2_open()
Date: Tue, 17 Mar 2026 17:34:08 +0100
Message-ID: <20260317163017.717052046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3616,10 +3616,8 @@ int smb2_open(struct ksmbd_work *work)
 
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
@@ -3660,6 +3658,7 @@ reconnected_fp:
 		next_ptr = &lease_ccontext->Next;
 		next_off = conn->vals->create_lease_size;
 	}
+	opinfo_put(opinfo);
 
 	if (maximal_access_ctxt) {
 		struct create_context *mxac_ccontext;


