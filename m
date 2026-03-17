Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB5318EFF;
	Tue, 17 Mar 2026 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767961; cv=none; b=uDqAiElhku9tjycurChS4ippvmfisqb1Zl1mOzzYIWcUasJKceqKTwKQQIbl52gqWfolLaOyDoPNzHT0TWEPD0ivJkx8Sy4ygasatisvYdBC+QWFZ7j2XzX1c1lQkf0Af/XSGE0vkyQo2jyqZ0ENZugDUKf382PQWFawj5nr2dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767961; c=relaxed/simple;
	bh=tEKhAPgIAmRyfCULTidw2Cor4yS4B0H1+sCE7IhYrSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOLxrpBWau8dX1Unt2lrR6ec/TRnJR6yj7sWsbEneqYMhgklrOifm9oW2eHOwpdcchok4RCzBKa+Mwrby78cUbCSd6ShrUpoAE0lrDUYxOuYGJPYxtNWYWH7uN0DnmfE7AVfbFcDlgmNxvbESrkQL2JltbDbnspBd3v4Pciu440=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7cHNvz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7cHNvz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65BDC4CEF7;
	Tue, 17 Mar 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767960;
	bh=tEKhAPgIAmRyfCULTidw2Cor4yS4B0H1+sCE7IhYrSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7cHNvz3MvuPHGKldW4kjUlMpTse0C7ePRLlAs+L59T1zVykF271EJ5YaubNrs5sf
	 VuPC/MRBPAuZsy7AzdEulfrTfeuTsZuNa86OW2HzRtGBzhZyvY5X7TExR/ZMr4B4uQ
	 k1xG/6FAhHBolQAM6bYfyWu8gZ/rM0b1uB60Ft9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 200/333] nfsd: Fix cred ref leak in nfsd_nl_listener_set_doit().
Date: Tue, 17 Mar 2026 17:33:49 +0100
Message-ID: <20260317163006.773860274@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 92978c83bb4eef55d02a6c990c01c423131eefa7 upstream.

nfsd_nl_listener_set_doit() uses get_current_cred() without
put_cred().

As we can see from other callers, svc_xprt_create_from_sa()
does not require the extra refcount.

nfsd_nl_listener_set_doit() is always in the process context,
sendmsg(), and current->cred does not go away.

Let's use current_cred() in nfsd_nl_listener_set_doit().

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: stable@vger.kernel.org
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1993,7 +1993,7 @@ int nfsd_nl_listener_set_doit(struct sk_
 		}
 
 		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, 0,
-					      get_current_cred());
+					      current_cred());
 		/* always save the latest error */
 		if (ret < 0)
 			err = ret;


