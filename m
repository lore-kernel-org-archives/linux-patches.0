Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE7446EF9C;
	Tue, 21 Jul 2026 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664322; cv=none; b=AcWgpG6cCBr3Ogb7JCB3ga18vxsuymatxQ+6GZ/qAVJvVnyoaa3/We6P/+OJ8i3tyNuC9ZRW/nnAd4lW8RioFjV4Lyn3D9AfveVP3lmS65EmdFBvc8W09PyerkMo1+Y7iTJBE70ai90VH/gimYXm5xCkMa16SOmCuLIsqPDBW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664322; c=relaxed/simple;
	bh=NFz7EMtXMKTNy7TTLvaeYCVMb52JY7BDGSDKMBh9O/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPlG9r+67nTrPRIujneMkLl1o6bT05bhQnAfiagvHKOzkwWzGx73rHPxbAiLeVB4w5bQbX/nZjTYW4puI2ecwWCgGsvO6ZDU/i5zriuL/Pp6d1Bj1+parUHbU2m9yCH8vtPl8DNF4xaXcqF2LSfE00CMNnHikQ9AcjnGvF6n/RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOLeSJdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOLeSJdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCA51F000E9;
	Tue, 21 Jul 2026 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664320;
	bh=TFXLOnV1DOQlrPoZH5sGWqMLOG3/MIzf4VcOQX7o6dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOLeSJdY1pRU+RLhB7rgIaj58Dev0V+cQSnDSyW/C7mYTpMm6fmKJfr18idegwziZ
	 B06gkxBWrI317mEMYHhyyllN+NERUPc6TMxtk3cC61xOlL6EnJ92IANWLe7QJM53Nc
	 MforzE+I+rhKs1Ah5yktudUNlMBw5dKcQ7uCDtj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1113/1276] llc: fix SAP refcount leak when creating incoming sockets
Date: Tue, 21 Jul 2026 17:25:56 +0200
Message-ID: <20260721152510.902950527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 2c72eb6286347d05a885412fb076993bd5286b53 upstream.

llc_sap_add_socket() takes a SAP reference for each socket added to a SAP,
and llc_sap_remove_socket() releases it. llc_create_incoming_sock() takes
an additional SAP reference after adding the child socket.

This extra reference was balanced by an explicit llc_sap_put() in
llc_ui_release() until commit 3100aa9d74db ("llc: fix SAP reference
counting w.r.t. socket handling") removed that put. The corresponding hold
in the accept path was left behind.

When such a child socket is removed, only the reference taken by
llc_sap_add_socket() is released. The extra reference keeps the SAP alive
after its last socket is removed. Remove the obsolete hold.

Fixes: 3100aa9d74db ("llc: fix SAP reference counting w.r.t. socket handling")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260712130343.518797-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/llc_conn.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -773,7 +773,6 @@ static struct sock *llc_create_incoming_
 	newllc->dev = dev;
 	dev_hold(dev);
 	llc_sap_add_socket(llc->sap, newsk);
-	llc_sap_hold(llc->sap);
 out:
 	return newsk;
 }


