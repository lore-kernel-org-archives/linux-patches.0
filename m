Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FABC2FE57E;
	Tue, 12 Aug 2025 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025149; cv=none; b=hKrGW5HUaABZUTtLXJW+O8uupNSi1zRWofa5bf3mBCS/aZZkyLd5op5WPO1ESMg0255K85CUeoL5nw4qBkOI2Z98MGViM2V2bVu3vzTVnNNxGoA7ffg24BR49iMIYWl3/tVWu9NJVdp1CzE50xb+avOFn4xlhmPMu/w7w3qVrcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025149; c=relaxed/simple;
	bh=wQMVd7/U+Ml3ONpcwMlYcV95CRICbudnDCGTnQG8TTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk3iV0McDihkzpab3dzJuxNCH3+e1OSrndh+Wvp8IVj/3o1uCzKtTToaldj/8cgFD+o2Yo2oaCruEpfxEMohOd6g/9sv51aAfzMMT3vFPbt/oxVaRf3cGV4MtTuVuy8dJ32BAtCNAGsh3eDr3PBHBY8fUl9AIqPULutHv9R/UkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQclHATn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQclHATn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA50C4CEF7;
	Tue, 12 Aug 2025 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025149;
	bh=wQMVd7/U+Ml3ONpcwMlYcV95CRICbudnDCGTnQG8TTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQclHATnb9yLdxZ3xGdleJapW31n28dGeu7KlzJ+CWn8ICuYw11oi/kAFjz9ooWfg
	 tS6YtBCAyoPVFSuxK68CzCqIYZLKJI4Nriwz/oCxkcBd6B2CrxpjJRNDmQ/IRQqd4H
	 ZrCNaNJrau9HWTfaVNTbmM4YNfLJug9DXErJEIJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 583/627] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 12 Aug 2025 19:34:38 +0200
Message-ID: <20250812173454.048758850@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Budimir Markovic <markovicbudimir@gmail.com>

commit aba0c94f61ec05315fa7815d21aefa4c87f6a9f4 upstream.

It is possible for a vsock to autobind to VMADDR_PORT_ANY. This can
cause a use-after-free when a connection is made to the bound socket.
The socket returned by accept() also has port VMADDR_PORT_ANY but is not
on the list of unbound sockets. Binding it will result in an extra
refcount decrement similar to the one fixed in fcdd2242c023 (vsock: Keep
the binding until socket destruction).

Modify the check in __vsock_bind_connectible() to also prevent binding
to VMADDR_PORT_ANY.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Budimir Markovic <markovicbudimir@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20250807041811.678-1-markovicbudimir@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -689,7 +689,8 @@ static int __vsock_bind_connectible(stru
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port <= LAST_RESERVED_PORT)
+			if (port == VMADDR_PORT_ANY ||
+			    port <= LAST_RESERVED_PORT)
 				port = LAST_RESERVED_PORT + 1;
 
 			new_addr.svm_port = port++;


