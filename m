Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4F83D3334;
	Mon,  4 May 2026 14:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903234; cv=none; b=TCz8nP9Iztg0/M8AW6M6dcnV6BauFb47t6Oqx6fNFvwwhX0P9I0oHaIWbaxrheaPDDxla7nq1zgQlhOyAnSl6fCwRt34j9+d8ky0amlmCGLBcv87JvSwnLK7PlonyWOCp/r/tGvDTjLqhLM9t0/7lGrX+1EhTO6lxTOKWt9lO04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903234; c=relaxed/simple;
	bh=LFkrb7KTtq7jndwvoPgvtMnSCjbk54w++xdjQIpXo9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0mMM+g4jsijXdqXhA5FWif/usZiwJTnWHwHcacbhzLGKn/GcFdcV8M3eyZi3Wp00aJmxatE8y6EcacdYbM47UJ0daYVteJSV1LnPaGtIEWFkakqNaTg9yMuqWHJO2HLqwX/d9QbQbkw/NGaNIK5xCVGYGFWPX0cfSiHzVYex4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxW4bC2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxW4bC2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008E6C2BCB8;
	Mon,  4 May 2026 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903234;
	bh=LFkrb7KTtq7jndwvoPgvtMnSCjbk54w++xdjQIpXo9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxW4bC2bXk0clPCBBtzC4+2FBVKm2ksJu9qi1Rv/IwXsPBqA/bRY50INOFBRRdASS
	 XkBbdVI871/btv7we+suWaY6XWsUQIBGxdfzxrbC3bJa23LrlF5lbsKMtux8UCItke
	 lCl3dkVj4lv3pMreGVgrjxvBvHO3dsZODifHmDJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.0 155/307] libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()
Date: Mon,  4 May 2026 15:50:40 +0200
Message-ID: <20260504135148.620606870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


