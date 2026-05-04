Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4F3D8129;
	Mon,  4 May 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904589; cv=none; b=kWRXulI7UJ1LTTm3pbh6F0JB6zVGipT98omhonMFK5/6uJ5TkANSw4rO4K/bNVT69eNoelaOKZnAfRMVIGg9sDWoReyLZrVlsVezfK+yWlvD+Kxoht1kE/N0C0hb6AFIhrZRL2GzE/T8WLeRZaE0HRKw1yJ/9ljlMidZ2UeQyPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904589; c=relaxed/simple;
	bh=REYXbTJAgFiwfN+031FZL+DCpeIgSeHxg2ygaMbPVn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebRdMVuoVJ6S8QUFWbU/8qJxyqIvkzArCLG6xbjjGPs7s+RY6tQubp8rL5MXm2MMSIrmTdDD89wZs9oYfDUI4vTF7HQKqhZLWilcAAIcHaMc4rX2jpmC+loWAAX6LmfStqMJ7HavmoqU7QxgLDyZ2ikY0j51xMaKzefXAYKkznI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xn//l5Y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xn//l5Y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A124C2BCB8;
	Mon,  4 May 2026 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904588;
	bh=REYXbTJAgFiwfN+031FZL+DCpeIgSeHxg2ygaMbPVn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xn//l5Y7ADki+EL0qD/yvdr8dWCyYxSRjWxieqcN12MWL23Lhuot0oUMyha6D9JNx
	 alj0AxfVrX/aY/QERfxN1tpUc4HhfOC/N8gZJXxPg/ZHgEjZh0anzDyn7LU9qIqs9C
	 qrEGSJ535FLMLQgtYew2wuM+hhJudXqe/seMDt/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 096/215] libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()
Date: Mon,  4 May 2026 15:51:55 +0200
Message-ID: <20260504135133.663286169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 5199c125d25aeae8615c4fc31652cc0fe624338e upstream.

If a message of type CEPH_MSG_AUTH_REPLY contains a zero value for both
protocol and result, this is currently not treated as an error. In case
of ac->negotiating == true and ac->protocol > 0, this leads to setting
ac->protocol = 0 and ac->ops = NULL. Thereafter, the check for
ac->protocol != protocol returns false, and init_protocol() is not
called. Subsequently, ac->ops->handle_reply() is called, which leads to
a null pointer dereference, because ac->ops is still NULL.

This patch changes the check for ac->protocol != protocol to
!ac->protocol, as this also includes the case when the protocol was set
to zero in the message. This causes the message to be treated as
containing a bad auth protocol.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -245,7 +245,7 @@ int ceph_handle_auth_reply(struct ceph_a
 			ac->protocol = 0;
 			ac->ops = NULL;
 		}
-		if (ac->protocol != protocol) {
+		if (!ac->protocol) {
 			ret = init_protocol(ac, protocol);
 			if (ret) {
 				pr_err("auth protocol '%s' init failed: %d\n",


