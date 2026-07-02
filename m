Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E9C1FA859;
	Thu,  2 Jul 2026 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011747; cv=none; b=QdgJgahhQRNDzFl6WUgmBeJ9VeP5+a4ctZZ7Chl/EYEdsYEiBnQXQZYqSv26MtEMnUxoIRP7gHLWIdgmGXIpjDoH4rjTRYgjFsoIiI4iXm6TiZj8M8CO6vJrsvg0nClujM+euafbSq2UrJGxAzCaWgj/6pgoU7oUUk9PG6tMGAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011747; c=relaxed/simple;
	bh=U3ZVO9hpU5+THjMxo0FwOPElPuI9EEwiaT+Db9aMvMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UV0bjfWqEGsUzF+r9rUeW2RulPBEc+itsY21t8XHDiv8NKKUKQMjzufMnfsygYuX9nP7pkMXNkbhWaSA8zSk3GuYF8eBbZFJ3tlIJmGDeqs9hZWN8Qt7hPJbFJMv1jo+zeoyPMPVjnSUOHwMdZENy4Gw0FiFbHZBrunk2WTv+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmbYMVzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmbYMVzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC961F000E9;
	Thu,  2 Jul 2026 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011746;
	bh=72nSTPrl30qdpY5BG9A0wMUTscVXxSINo4WEB8iYwzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmbYMVzhw97k3pymlphhIhe7D0Mm2Ka8H/LG/0GuUuw2a0sOvQuqeTB1zlTniCQDo
	 K5AzjAejyixGfa6B6K7cs2FoUC4fjUn9/VZmr5C2cJ5b9ONDAMA4JHhIfQxs+arfqw
	 wsXh4UMEGPb1DpXcGL44KvqtBBQJs58lXyW8fBlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.1 117/120] NFS: Prevent resource leak in nfs_alloc_server()
Date: Thu,  2 Jul 2026 18:21:53 +0200
Message-ID: <20260702155115.379621308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

From: Markus Elfring <elfring@users.sourceforge.net>

commit d189f224308c8ac3feeea8e442c99922bd18f1b2 upstream.

It was overlooked to call ida_free() after a failed nfs_alloc_iostats() call.
Thus add the missed function call in an if branch.

Fixes: 1c7251187dc067a6d460cf33ca67da9c1dd87807 ("NFS: add superblock sysfs entries")
Cc: stable@vger.kernel.org
Reported-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Closes: https://lore.kernel.org/linux-nfs/1c8e10c9-def7-4f0d-8aa1-23c8035a38c8@wanadoo.fr/
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1074,6 +1074,7 @@ struct nfs_server *nfs_alloc_server(void
 
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {
+		ida_free(&s_sysfs_ids, server->s_sysfs_id);
 		kfree(server);
 		return NULL;
 	}


