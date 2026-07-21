Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B3146AA69;
	Tue, 21 Jul 2026 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648024; cv=none; b=JdPNVt3TlCZATyzn6+dwq1/jgUlUby4qvSs6RJc2Ap4lQg4m8MOjmg1rW2cHaRHKrP0qxJ5TYiTA92iGWXsbCJit9yqWhmEavHmsY8hO+Ezu8mb0JCZrtvrXVdeOqIv7sA8O7F0n67ttZX/+VX9HOW/ATv3EL5ZpacTH8NU2p/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648024; c=relaxed/simple;
	bh=gsY0qSR6SywC2OXSrGH8hIaYn6BN4pykq0fYufAxQeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0EB5Ai9OgeNmqnCIwE13eHfWcYB6ARnSuva2XyiGGUbn07DpX3YSNL8+l+xLd7u+xZP/0XpZhGXSJatXF6JYNrbxxq9LPVOTYSZIXwrq90aerdtguX93Olgove4tkoLm3YxoWp+ncGTUvo+Ny4SQP1KCZ/po28VSWQjwUhGu6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI6fIgdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI6fIgdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B701F000E9;
	Tue, 21 Jul 2026 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648023;
	bh=nCUL+RfQQkU5JtDZb4WR+PlpDbU2+qmxdiOsM9CNTTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tI6fIgdC5RZmoHfIXZGEW47PrrhoVReyj36qaufAj/SHjVzLTFY7g7NLqm2SUL2F8
	 BZJlhBocKHyQ/D6gsKu7PahfrQwE2CFMHzTCPS1G/ZQZSUJe+0XaJkFS9RWpZ5M51+
	 FnVZ4+A1pPqt+arprE5iA2A0tLarTCk6N8OU5OBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Nan Li <tonanli66@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 0036/2077] afs: handle CB.InitCallBackState3 requests without a server record
Date: Tue, 21 Jul 2026 16:55:09 +0200
Message-ID: <20260721152553.539180103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nan Li <tonanli66@gmail.com>

commit f3cf725cd284b7912d5522babb44721bf38c8887 upstream.

The cache manager callback path now attaches the server record to an
incoming call through the rxrpc peer's app data.  That association is
not guaranteed to exist for every callback request, and most callback
handlers already tolerate that case.

Make CB.InitCallBackState3 follow the same pattern by checking whether a
server record was attached before using it.  If the peer is not mapped
to a server record, trace the request and ignore it, matching the
existing behaviour for other unmatched callback requests.

This keeps the callback handler consistent with the rest of the cache
manager service and avoids depending on peer state that may not be
available for a given request.

Fixes: 40e8b52fe8c8 ("afs: Use the per-peer app data provided by rxrpc")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-2-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cmservice.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -364,6 +364,11 @@ static int afs_deliver_cb_init_call_back
 	if (!afs_check_call_state(call, AFS_CALL_SV_REPLYING))
 		return afs_io_error(call, afs_io_error_cm_reply);
 
+	if (!call->server) {
+		trace_afs_cm_no_server_u(call, call->request);
+		return 0;
+	}
+
 	if (memcmp(call->request, &call->server->_uuid, sizeof(call->server->_uuid)) != 0) {
 		pr_notice("Callback UUID does not match fileserver UUID\n");
 		trace_afs_cm_no_server_u(call, call->request);


