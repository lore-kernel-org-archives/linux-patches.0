Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D886212F00;
	Tue, 12 Nov 2024 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408120; cv=none; b=Uh15lREOpcl2ZR3oadJ7xlyssBg6cf1S3eWEh+F4W41xfpmNfsFcJCZ4yhSB1uT8wq5rNRrEjb96VI0/uo02V5jYjTPZtReU0Tl2OqsbuwFaLF+uMeFvUl/8RnxorpsUzI7KMcRBR4uWyXLvNqA0a5jU/zQINazaW2tv7JvIuZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408120; c=relaxed/simple;
	bh=Mo/ZRE10DG5mJd7Z8aAAGqUG1/Xb1MtLUCJBJRA8AlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSHHvIuGAs35vmcNIHAWEa81imPOOJznaruoJVDdJEY+F5nS3UxUQ+1xbUYLBVGXC1Ze3DcQ0ZG0OGJuwrLHcirVH0n8bFcX3qeMK5N6HkRV/421DNyefnHcem9K2nsFpctAF4rLsqddlhhQR9MpiTf5CDVtZlQlXoxs1ClvDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsRPsjhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsRPsjhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96857C4CED4;
	Tue, 12 Nov 2024 10:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408120;
	bh=Mo/ZRE10DG5mJd7Z8aAAGqUG1/Xb1MtLUCJBJRA8AlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsRPsjhHoALbJA/azktv+z/SubKGlbYxP0JtVn8unRstaYhJ4g0CiSQhJifkci4bu
	 0ZWBIWjBIrbZGaKJrshl113nvk35cYFbpBRuD6VSayLC/8hzB1dv8b6LnGkPcwztMA
	 vloTtZqRXH7YpHCONTfQOk1QfFW5EWee0KiA8PDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/184] sunrpc: handle -ENOTCONN in xs_tcp_setup_socket()
Date: Tue, 12 Nov 2024 11:19:52 +0100
Message-ID: <20241112101902.175930579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 10f0740234f0b157b41bdc7e9c3555a9b86c1599 ]

xs_tcp_finish_connecting() can return -ENOTCONN but the switch statement
in xs_tcp_setup_socket() treats that as an unhandled error.

If we treat it as a known error it would propagate back to
call_connect_status() which does handle that error code.  This appears
to be the intention of the commit (given below) which added -ENOTCONN as
a return status for xs_tcp_finish_connecting().

So add -ENOTCONN to the switch statement as an error to pass through to
the caller.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1231050
Link: https://access.redhat.com/discussions/3434091
Fixes: 01d37c428ae0 ("SUNRPC: xprt_connect() don't abort the task if the transport isn't bound")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 0e1691316f423..1326fbf45a347 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2459,6 +2459,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	case -EHOSTUNREACH:
 	case -EADDRINUSE:
 	case -ENOBUFS:
+	case -ENOTCONN:
 		break;
 	default:
 		printk("%s: connect returned unhandled error %d\n",
-- 
2.43.0



