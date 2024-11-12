Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54520FAB3;
	Tue, 12 Nov 2024 10:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407247; cv=none; b=TRZOkNTRMHlQLku7pxyUNf1cfpQpC5poijt0s/kJChaFbAwoZF94dQJ3Vp3KIejFoUn3zh08tl3n+VMub+iu6eHbd8q8bk/MrFPq0z3pz/DsLTbYXBCt07W198Aj9PpLcRC7SxbPKmhydABYENdxN8ANWDWltDuydI6xPNLvRnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407247; c=relaxed/simple;
	bh=C3UJb6S3lENqqcu8lqWzw7GI+absJyAg7duXsZRmNTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcRmUQscP8dNQfUg3WuilnroFhLRZcqnSjCOs+L0aAbwmsTJOIORXi1o1nfUGjnlRRQudh90YZyOVmxqy7SBPoaq/rIAq2wWg1mlbXa1nwQJ7jmLW6A89nzvIWnmZ4Ch3iTdz5eNCuczZ3aqlQmn8MSbRy1AXRXihLjNwHSBBhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udQs9bOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udQs9bOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D876C4CECD;
	Tue, 12 Nov 2024 10:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407246;
	bh=C3UJb6S3lENqqcu8lqWzw7GI+absJyAg7duXsZRmNTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udQs9bOJ/qN9UIEN3Gf/e/q8UnfLC5JR/QPF9gAzxaxTmAQF5Kyz6AbPjh+XL4+Z1
	 qhh/buvS68WCM+JbMiVBt3c3ydztZe/U9OGh1iAx2zTn8EufZBjAXFi2XHjA6Tfe7A
	 /6sUnEt58oK4ThNmRzEj/E/TFZcvK+e7p2Vtvsa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/98] sunrpc: handle -ENOTCONN in xs_tcp_setup_socket()
Date: Tue, 12 Nov 2024 11:20:33 +0100
Message-ID: <20241112101844.965214126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02f651f85e739..190dae11f634a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2351,6 +2351,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	case -EHOSTUNREACH:
 	case -EADDRINUSE:
 	case -ENOBUFS:
+	case -ENOTCONN:
 		break;
 	default:
 		printk("%s: connect returned unhandled error %d\n",
-- 
2.43.0



