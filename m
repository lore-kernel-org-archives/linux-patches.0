Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B231434DB4F;
	Tue,  6 Jan 2026 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720447; cv=none; b=GW2aScf62Sl3eDG0SnBQFpheH7C30YIgIDsCavhOMH+cPc5CESZTa7+MRv/TkPLbVejSapumPz40BWL4yO4l2mXlSTBeYPwDcu1nNlcmvY1zwRB651OBBzJD5/+OABGJO6GYJQfY6ZTJQetHBmLbPBPdDTegXng3KIbYvX0WIgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720447; c=relaxed/simple;
	bh=U9OeWTFz+rqpc95rOAW+elB6zqpbkowl8YC3WEO7uUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1GJOmcK8Ujxn+b6pgzmlYCJ8OFdK7IAdGtHv+Vlhq7y82LNSw8YzmgGn/+0DETQaN4pv8t/WrJSMK1vaRghUOgqlbVK+HXMTxCQD2Kn4a1qbiabM3v2wpa5mWif9dK+sk3VoGhUvnxEXhz5cs8iJtN6Wx8b2avj3BYSSYOJ09s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhD0CCLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhD0CCLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD246C116C6;
	Tue,  6 Jan 2026 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720447;
	bh=U9OeWTFz+rqpc95rOAW+elB6zqpbkowl8YC3WEO7uUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhD0CCLTf0PpKMAkW9SA076bAh5eqQIU23Udl/Rc7C+4BQQ6oaiQT3C87Lr7xhnA2
	 ge1Zz20HU38anDgkV+enWd0HM3VyNaAfhYfvBVCvVV6mB67Bb98LGWblZF4fSDBZHf
	 rwMgR6X15VMwqw1SxfnHVqRb4Fxc2+WCWhAexKic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	caoping <caoping@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 238/567] net/handshake: restore destructor on submit failure
Date: Tue,  6 Jan 2026 18:00:20 +0100
Message-ID: <20260106170500.122100278@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: caoping <caoping@cmss.chinamobile.com>

commit 6af2a01d65f89e73c1cbb9267f8880d83a88cee4 upstream.

handshake_req_submit() replaces sk->sk_destruct but never restores it when
submission fails before the request is hashed. handshake_sk_destruct() then
returns early and the original destructor never runs, leaking the socket.
Restore sk_destruct on the error path.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: caoping <caoping@cmss.chinamobile.com>
Link: https://patch.msgid.link/20251204091058.1545151-1-caoping@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/handshake/request.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -277,6 +277,8 @@ int handshake_req_submit(struct socket *
 out_unlock:
 	spin_unlock(&hn->hn_lock);
 out_err:
+	/* Restore original destructor so socket teardown still runs on failure */
+	req->hr_sk->sk_destruct = req->hr_odestruct;
 	trace_handshake_submit_err(net, req, req->hr_sk, ret);
 	handshake_req_destroy(req);
 	return ret;


