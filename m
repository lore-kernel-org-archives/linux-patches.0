Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A095143748;
	Tue, 14 May 2024 11:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686099; cv=none; b=CMPvJAIDHNAUiJVaTipYHVdeAi3zHxg1byO0zueUPbHx9d0GtTet6JQ4MFPiWXLahuc6Uka/X1ej9OOzLNtuAIQAjCYneBL/nXeezRZSIYwwK4NPuwSCaFbPvVnflPV8Tg7iCANZIy+8LOBrn+RMxoT4Ywoe+kbf2nDPfPF7PCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686099; c=relaxed/simple;
	bh=c9QmwjSAJooUXDY14N8BbcLV81BAnvl4BPanWNJgJkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4O1X4/2vDDPg9fXhhKzotwTHW1i5d0Eu3pIh4yAcL3MT5B2sT/vgak9LNr7tPJtuoq04aS7pk/14mjMSDWIbCjsxiBYizlYwRH2jx5J/KkDyC+ZP5xi7C2mUoeRy1F0lLNxZBwkaAQB5xuIIsG3GVfa25uhTSmRD4JSN7/JAwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWK4iWKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWK4iWKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D330EC2BD10;
	Tue, 14 May 2024 11:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686099;
	bh=c9QmwjSAJooUXDY14N8BbcLV81BAnvl4BPanWNJgJkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWK4iWKKL6JB/D5NTe9JsR7AIx3a6fauVfYkRARWE4AJwhakq3bpHDBUhN6ROskZB
	 uxz8DbP/psy6FZK7+Dt/btvkyqZiEUjjVEx+03p+Qz+ZCzqDKY4mOaO+QxaVjOId6l
	 vWUpfTV15PG68eUHAy4301QATWGa5jEtiKSHAal0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/236] smb3: missing lock when picking channel
Date: Tue, 14 May 2024 12:16:23 +0200
Message-ID: <20240514101021.139144876@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 8094a600245e9b28eb36a13036f202ad67c1f887 ]

Coverity spotted a place where we should have been holding the
channel lock when accessing the ses channel index.

Addresses-Coverity: 1582039 ("Data race condition (MISSING_LOCK)")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index da2bef3b7ac27..3fdafb9297f13 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1079,9 +1079,11 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 		index = (uint)atomic_inc_return(&ses->chan_seq);
 		index %= ses->chan_count;
 	}
+
+	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
 
-	return ses->chans[index].server;
+	return server;
 }
 
 int
-- 
2.43.0



