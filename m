Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1AD36CE0F;
	Wed,  3 Dec 2025 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780510; cv=none; b=FRzRAFniIx/gXTNYrHvfRs8WllsNwjy8xiEJu2GQhWLD+MKZS3cjPQyEz4YOrHS7Hv5AiF9i2qBMUQziktGVpcOhZKsEAuIi09ditunas1h5dKqA8OH/kqxxqBOpZFa6Smvh7cu8NHAhi+j54X6eACVkRbsmBmG1kfIDm7kMKYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780510; c=relaxed/simple;
	bh=fPMG5KGNE/EgjNRVQEAUi/WXSI565X8IEvmzvzJun3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2G9HJilb5NgaiVueQhi4O/eex5nI+Mf6gO2aI//fmYI0MsusWMgFFRRFQ5Hq2n00Z1A1UhB7o72M8cSNHXvo2F+ifASRDgqWjAZRkdqFuHaHkRMRAJOZDY0hNWbJ4jDTnSROo0zukzUiXAdoxNvyrFAOOrUZz5QdMMqF0e8Q1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKeBk5Hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKeBk5Hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16EBC116C6;
	Wed,  3 Dec 2025 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780510;
	bh=fPMG5KGNE/EgjNRVQEAUi/WXSI565X8IEvmzvzJun3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKeBk5HpcPa4jj2dTUDZy2nR9VzSAUWUQ3omNhTAhxxqFCvbA/BF1RhuuG+fVLvAb
	 kAoAiao0n7SdVThYUwF6ZxEpw8anHzNNlBXr0H4QjmG1lajo1exeEzxt9vHGKxToVM
	 7wBQR77SYKLrlaM+RMHIf+38p956CD0BXINALXJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Nazar Kalashnikov <sivartiwe@gmail.com>
Subject: [PATCH 6.1 562/568] ksmbd: fix use-after-free in session logoff
Date: Wed,  3 Dec 2025 16:29:24 +0100
Message-ID: <20251203152501.328236895@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Sean Heelan <seanheelan@gmail.com>

commit 2fc9feff45d92a92cd5f96487655d5be23fb7e2b upstream.

The sess->user object can currently be in use by another thread, for
example if another connection has sent a session setup request to
bind to the session being free'd. The handler for that connection could
be in the smb2_sess_setup function which makes use of sess->user.

Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Fix duplicate From: header
Backport fix for CVE-2025-37899
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2253,10 +2253,6 @@ int smb2_session_logoff(struct ksmbd_wor
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_NEGOTIATE);
 
 	rsp->StructureSize = cpu_to_le16(4);


