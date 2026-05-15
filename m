Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA33FF1CD;
	Fri, 15 May 2026 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860782; cv=none; b=lflpTw2wrerPlbj3gh5KYCx+GTBBPgZZnKHXwUv+WlmgUOQtiyC0xxqPcKQvKnmZW6oEKY5rVwTGR8oSozrr2VyFBXDH42aCeWjip7NNfTG5meNbD1SdCD3j5de76IPkEYDGdj8UOjYrm1/k7yebAOZfRDtWFvSsb8+QFE5kfPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860782; c=relaxed/simple;
	bh=3naF8abKKZLVmbiZyG+vLOyOZnhlhuKFgyw66hugP0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMPIVjI2IqqsHZ+HIy/5FnOx27IYo6kMWcMaWJ2E1fRgRPbp1UnqeLVRyJUGWfz2XA+HUDCEFleVf95fnOuYr14IxTkIgLmGwMQkJj4zuI42aNRRMEj1yXXZPm6RnfGzBMbWYgm57XpLLxSx0U5RlZsK+86w4kaKSFTDwU9v6+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uO6NRLu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uO6NRLu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8653C2BCB0;
	Fri, 15 May 2026 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860782;
	bh=3naF8abKKZLVmbiZyG+vLOyOZnhlhuKFgyw66hugP0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO6NRLu+lMmnVozd0bH3q40nhA/z132JfnXKfoGL4vGfybkKZ7ShNn91UGpSHQIrw
	 ZKsNVYXu3YI+qfC7QQsiPfIALQBgEWvrjj5WrgHUvEgm+v0pTo+UErkuMfzhQLhcSG
	 /Ek9zw8afyYfuuY5hpa7hRXR2/l8nf92CT1mPTjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 078/474] libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()
Date: Fri, 15 May 2026 17:43:07 +0200
Message-ID: <20260515154716.726195747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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


