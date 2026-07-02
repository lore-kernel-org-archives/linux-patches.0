Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F1A32ED40;
	Thu,  2 Jul 2026 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011423; cv=none; b=L/Co7pbD2ofl8kaaSqdiKfKAo9+qbZyQYSvOniHiwV4ItrAAmBGfXnOIh1/XBV4fbwWkrxDND0cBwV8vUEWRrqKWQZN6WDVBZE1nAU+EnZc+KmzOEzE3HhjCNpUGFDfF202duHPZe8fJiv2HfQICGycu4PvT12jG0QYRaxSkE6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011423; c=relaxed/simple;
	bh=F7bmi8s5S10fJy1Si/YJbZO1b10wNb+DP6lkCI50e38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaIFwRmoTMadazJLorLvwTxpMq/PrKVl7NcjcaJ1/hdfAluJ55m3UkD5R+2I1HP7qbUa1IH8ZgPG35qpSI7jMgUKamOvSpji5/F8ZXa4lmUfoi2Xr9b6alC4jIyGQDI8h4IZbxXbWa6m132yUQMUNVsFT9fBY8OkP/AW5FxHUDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALqbJ/FH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALqbJ/FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E711F000E9;
	Thu,  2 Jul 2026 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011422;
	bh=SmQBJmb7OnwV23tarZaJNCwLawjvwKWFq9YTqLrAhm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALqbJ/FHvUzKEECpU5L1j4K22Cwv0aMDsj6doMov8ld3/SuCxSIUDTBmJkiGJOKlI
	 HtgYUHdEQVz+qwadxnZGciqUPwseoiYSqKaIuM1HzmmZ4clKfbsXsC3gFwow8ELXj9
	 UDbs1u9hnO0Lh+NxojILcDQiEvnAw8WICNyMR2Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 104/108] NFS: Prevent resource leak in nfs_alloc_server()
Date: Thu,  2 Jul 2026 18:21:41 +0200
Message-ID: <20260702155114.268337226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1070,6 +1070,7 @@ struct nfs_server *nfs_alloc_server(void
 
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {
+		ida_free(&s_sysfs_ids, server->s_sysfs_id);
 		kfree(server);
 		return NULL;
 	}


