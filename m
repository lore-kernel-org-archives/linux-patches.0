Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ED038C2D8;
	Tue, 21 Jul 2026 21:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667632; cv=none; b=q0LsvpEUDsgoQbdQYfK/nfcgzcBf53FYDYPv4AfSM+a1ItXiO4cyvc3OuRbUzJdP529lHn69clBI5CQImXFZh0fGIuDKuz4dtIKv1MDqmPCZh6FImAnxXrHs86Tbo8XL4l/SrG07fjT0jmp/TflVRj/CNoa+Pgs9N2MX8zCF0yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667632; c=relaxed/simple;
	bh=q00YJaAdK8aRZpWXUrqVeAslgzkwuQIgGotRjh+6Hpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDeHslSROWrm1gItb5Nrcvf9umojMmbye8wRMq9cpjWRqL/70oLMNUFstssgqHk5/8pcQmhZQuBURFAbAWujt/1hBmosjncWUHJsE6q14qyQ7mMAKY6TnaPvedLmAZspR321XRU00G2emtcA20Ba/zbZbXljsi6Fcsw8Ewiv5nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqflMlEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqflMlEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29E81F000E9;
	Tue, 21 Jul 2026 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667631;
	bh=8Owl8QQMx6sU9Vph0eQNNYN5BQcAGZfBR5TU/fAQGBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqflMlEyL3BnRg3rMzBN69UJcTFPMX2jesfPashiyufZJgcbE9ITWzb3WSr3Ox5bj
	 qwizhygEDxsVa73b00lpD07ZP7myx9/FCNRRl4LAVCa+qqrhzXipXhHr5GRIf/DTnQ
	 BXIa63ZmWvLMq7n44jrwUgbU6irHKO9Z9iHDd7Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1133/1266] llc: fix SAP refcount leak when creating incoming sockets
Date: Tue, 21 Jul 2026 17:26:10 +0200
Message-ID: <20260721152507.149014228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


