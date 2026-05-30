Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9B93191D0;
	Sat, 30 May 2026 18:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164535; cv=none; b=nf/uFpvpSHqN7gApe1+lwlt/iYZWvNgqBEymw4O7MshBOJh9AlZ6yaTuCTXyB8ziDdmsfFX2csHftDPes8xFw6mjKNxuzyAx7a+ybmd9KQAHbuuxq2rZO9yvsG3JZBgqbmgsoSMgQSLgHWrBLKT6GLGsfvlXHe14h5hl1SbYVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164535; c=relaxed/simple;
	bh=p671LR28dbrt0TD0MTJXYK5uu4O/KnkcLbX6/Ih3n1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUhkpSy0ZqFIenfsegr4C0eqMlQtbV2Oa/PYwaguxNwWjCKA+qySe5Eb8zHdQSGnRMfBIyjXXIX7uXPfh5Gg5yQ898UGzJ1mY/wK8CTTDgBqAJqpbZY8mu09qV2ioD08gVXXz4YDQdEZg4yBp1E0VA3Vk6c0RybzpNuFFr1oEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5LLF4JG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5LLF4JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909701F00893;
	Sat, 30 May 2026 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164534;
	bh=BbyE6iEFmsLqBv/MPTxq+/w8cO0yvRXZFRz6iYcdpIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5LLF4JGa9IztVrZ9YHREqbeHspAyDo1deXFBpWpXk+pt45DGTeJE5iYKvpHPpbvA
	 RGUHuVtJeIdR+cZBxyZ7PLdHcekDUOH+ofV2Zm4wk9SSJ/5irYn8czA4/EZkW9Wxts
	 khF4Z4cUXvSfXokWHIM+GTyoy0YdY73d9MZkejiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 583/776] ksmbd: scope conn->binding slowpath to bound sessions only
Date: Sat, 30 May 2026 18:04:57 +0200
Message-ID: <20260530160255.149057278@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit b0da97c034b6107d14e537e212d4ce8b22109a58 ]

When the binding SESSION_SETUP sets conn->binding = true, the flag stays
set after the call so that the global session lookup in
ksmbd_session_lookup_all() can find the session, which was not added to
conn->sessions. Because the flag is connection-wide, the global lookup
path will also resolve any other session by id if asked.

Tighten the global lookup so that the returned session must have this
connection registered in its channel xarray (sess->ksmbd_chann_list).
The channel entry is installed by the existing binding_session path in
ntlm_authenticate()/krb5_authenticate() when a SESSION_SETUP completes
successfully, so this condition is a strict equivalent of "this
connection has been accepted as a channel of this session". Connections
that have not bound to a given session cannot reach it via the global
table.

The existing conn->binding gate for entering the slowpath is preserved
so that non-binding connections keep the fast-path-only behavior, and
the session->state check is unchanged.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/mgmt/user_session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 23a0662bbfd32..b6b6572d402d3 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -301,8 +301,13 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 	struct ksmbd_session *sess;
 
 	sess = ksmbd_session_lookup(conn, id);
-	if (!sess && conn->binding)
+	if (!sess && conn->binding) {
 		sess = ksmbd_session_lookup_slowpath(id);
+		if (sess && !xa_load(&sess->ksmbd_chann_list, (long)conn)) {
+			ksmbd_user_session_put(sess);
+			sess = NULL;
+		}
+	}
 	if (sess && sess->state != SMB2_SESSION_VALID) {
 		ksmbd_user_session_put(sess);
 		sess = NULL;
-- 
2.53.0



