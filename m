Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECA7BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD25C433C8;
	Mon, 19 Jun 2023 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171822;
	bh=2+N8B/NQLrP9utTMbxYa1LUZDM4rvFGPlMdOGNjBeXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiXp1wuGhPN+dGnt55oTXnlqMYpxy4aSJl8EcY9BB3w0OTOOVBSGl8EjENHlsWfa+
	 Va6XZVVoSzy5oILtS6AeVGTX4nBZ7Ns5WoARg/LK2PishNblPsMzVaVaqN3qHuj2Mk
	 XqQ9N/s0KLmOPd65tAf2mSHg/jWzeYvtcL38jZLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 162/166] scsi: target: core: Fix error path in target_setup_session()
Date: Mon, 19 Jun 2023 12:30:39 +0200
Message-ID: <20230619102202.540925738@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

commit 91271699228bfc66f1bc8abc0327169dc156d854 upstream.

In the error exits in target_setup_session(), if a branch is taken to
free_sess: transport_free_session() may call to target_free_cmd_counter()
and then fall through to call target_free_cmd_counter() a second time.
This can, and does, sometimes cause seg faults since the data field in
cmd_cnt->refcnt has been freed in the first call.

Fix this problem by simply returning after the call to
transport_free_session(). The second call is redundant for those cases.

Fixes: 4edba7e4a8f3 ("scsi: target: Move cmd counter allocation")
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Link: https://lore.kernel.org/r/20230613144259.12890-1-rpearsonhpe@gmail.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -504,6 +504,8 @@ target_setup_session(struct se_portal_gr
 
 free_sess:
 	transport_free_session(sess);
+	return ERR_PTR(rc);
+
 free_cnt:
 	target_free_cmd_counter(cmd_cnt);
 	return ERR_PTR(rc);


