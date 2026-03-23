Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACB83BC67C;
	Mon, 23 Mar 2026 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282634; cv=none; b=g8ECoos2CH+5Gu1NsqsDYL7+yZBE+o51ydC8HHVpliKtEZpND6V36s6kFNK5v3/SVEgEBKvwDMa8ra2Ccl5tnnpJtUVsBw7IjHt71VIr58ZDfO5BBPFiclvyordsaxEloOaW6ZQSg8m2HmBF/BBotviZqHWqcOpakZJ/jX7u2sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282634; c=relaxed/simple;
	bh=A105XuOjhOi6IUhNAwvbENd01O8aZrx50pC5s8us5dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drXKDttwC87ZJz3VOVC8+ZjsJ8rxkiCpVEE0ILHDP0aL9nRdqXr8IPyYVWJ5sbTwKkR5q251lxdWYipXP19ktkG5jnQwLME5W2NzehrO76z7e6VWBP66IeiPn3YQDOCGKgGG/SBd0ddzqtuR98RjV8F3oXPu/gKmTacQ1llpjDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOAscp5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOAscp5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71732C4CEF7;
	Mon, 23 Mar 2026 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282633;
	bh=A105XuOjhOi6IUhNAwvbENd01O8aZrx50pC5s8us5dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOAscp5gtJYusm2FbeGoPvynHXSiPPE0j9dBxYwlv7kdAMoIu5/cKzFlDQfiV/fXA
	 pB7RQx9HuSyjHJEiphnzMP6YDTINWtlvzLtz7yOXUZOKjoGq88B9ul9BbxEU63k5ii
	 90T/nNMLXYYPLF95sX2rCL1lqnSAgZ+dAPq9KTBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.1 227/481] libceph: admit message frames only in CEPH_CON_S_OPEN state
Date: Mon, 23 Mar 2026 14:43:29 +0100
Message-ID: <20260323134530.674257917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit a5a373705081d7cc6363e16990e2361b0b362314 upstream.

Similar checks are performed for all control frames, but an early check
for message frames was missing.  process_message() is already set up to
terminate the loop in case the state changes while con->ops->dispatch()
handler is being executed.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2718,6 +2718,11 @@ static int __handle_control(struct ceph_
 	if (con->v2.in_desc.fd_tag != FRAME_TAG_MESSAGE)
 		return process_control(con, p, end);
 
+	if (con->state != CEPH_CON_S_OPEN) {
+		con->error_msg = "protocol error, unexpected message";
+		return -EINVAL;
+	}
+
 	ret = process_message_header(con, p, end);
 	if (ret < 0)
 		return ret;


