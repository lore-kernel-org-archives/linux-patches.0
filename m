Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA2E2F1FEF;
	Thu, 28 May 2026 20:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001174; cv=none; b=mCYfeOcf6srvHxKcje8L2QJj4Gh+y9Aa/VKwCCScoHhGR8HZB+QM7dRIj/+loO75tiP1L84zZklBKxwTEw27CEW07OWpbzJ/NqvzBPiUVDIbNiWIr4HAnu1JL7Pi9p2wzhFzamgLMbVdaGwPLoCjNe6Rg3qTtTGHzOE3QniUpus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001174; c=relaxed/simple;
	bh=jsWDyvYQm0gfSxQMPj4WAv/y5V/dDDdS6aC86J0C8J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0bxbFLxYsCph3KyJvp2T9+KTifv8UWjNm2fxeOcLITr7hkugY+kYOcKHTwMpDCEgB2jJ3DpjCfZa2FdjF4j03P7VOJN2b4DBKblJO1yJ34TVdfAbZlNjyYIg7EmpUtE31FF/5QdUdMJQIiSyalCVNgahKud0V8602snrcHo09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCjKG/tY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCjKG/tY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8F51F000E9;
	Thu, 28 May 2026 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001173;
	bh=Mm/G9ZnCTn39QWJLHbRk3aUBUK+aRDNP8CCP0R5hx90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCjKG/tY6TaeJDZfybOGE5I1d4mM7M8vmXenwLw0GKI409VW7ybMDpN+qv4vua1cO
	 5c4wuoUMwxKmeGlMk5EIJH5FSayn03PEeQLzmbieVP4p7X9colqFGD7REoC9K+WKSS
	 7GbJLW+L7s6XXXTGbyPkb/vMzaNW1nmITozXC+JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 034/186] net: wwan: iosm: fix potential memory leaks in ipc_imem_init()
Date: Thu, 28 May 2026 21:48:34 +0200
Message-ID: <20260528194929.883427695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit c5d93b2c40355e999715262a824965aac025a427 upstream.

The memory allocated in ipc_protocol_init() is not freed on the error
paths that follow in ipc_imem_init(). Fix that by calling the
corresponding release function ipc_protocol_deinit() in the error path.

Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260519062815.55545-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -1430,6 +1430,8 @@ imem_config_fail:
 protocol_init_fail:
 	cancel_work_sync(&ipc_imem->run_state_worker);
 	ipc_task_deinit(ipc_imem->ipc_task);
+	if (ipc_imem->ipc_protocol)
+		ipc_protocol_deinit(ipc_imem->ipc_protocol);
 ipc_task_init_fail:
 	kfree(ipc_imem->ipc_task);
 ipc_task_fail:


