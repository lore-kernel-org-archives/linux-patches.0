Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C0914267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EDDC433C8;
	Thu, 29 Jun 2023 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064370;
	bh=SBpJEaxIBW27NpG4jj49S37Xo0TdoWjAdQJZDZWp6LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqAmdmGT6EqA4xOWMnkRETW3pqAU6MHhy64LN729SEmi9yz38AYgTTSl0/czWXPZe
	 4eu+bfwaMJKnsxGwY2fQ0iWqektqmF2pIuQUUUnPIGbO4t02Sbo2b/aJb5zmv92rDe
	 GurjZuzpVdaiWNSxJVzgv/ptE1M1WOPyMlt9pxoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carsten Schmidt <carsten.schmidt-achim@t-online.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.3 10/29] can: isotp: isotp_sendmsg(): fix return error fix on TX path
Date: Thu, 29 Jun 2023 20:43:40 +0200
Message-ID: <20230629184152.163425483@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit e38910c0072b541a91954682c8b074a93e57c09b upstream.

With commit d674a8f123b4 ("can: isotp: isotp_sendmsg(): fix return
error on FC timeout on TX path") the missing correct return value in
the case of a protocol error was introduced.

But the way the error value has been read and sent to the user space
does not follow the common scheme to clear the error after reading
which is provided by the sock_error() function. This leads to an error
report at the following write() attempt although everything should be
working.

Fixes: d674a8f123b4 ("can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path")
Reported-by: Carsten Schmidt <carsten.schmidt-achim@t-online.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230607072708.38809-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1079,8 +1079,9 @@ wait_free_buffer:
 		if (err)
 			goto err_event_drop;
 
-		if (sk->sk_err)
-			return -sk->sk_err;
+		err = sock_error(sk);
+		if (err)
+			return err;
 	}
 
 	return size;


