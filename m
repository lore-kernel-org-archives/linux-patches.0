Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B422E349CF2;
	Thu,  2 Jul 2026 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011129; cv=none; b=fLSxebzDftqtTn5oac7VOpDHqDyJM2ofLCzjb0dAyM6ruV7S09snNWOxX7fVlcrl2ysNxjZEnnlX6LCW2yfjiZh8O8Hhpq6vr4O4VzJAppyWY8vmPxWu2oe0Dvc7umX2C0Q1pvk+lS9inqVPgkvdeO7Z4boGPrWn+oGEcvUrmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011129; c=relaxed/simple;
	bh=RmCvbz9U4WCN2WnQ33Ej6RYcTDpCxqgyTNq81YyCAVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svXltM54pqeyiB5JKXYYl1jVRB9u19+ZXHA95BePdpoxTPJn+A8qF9oHZkkr+sp64PQ0VlP+JHLg1+qnM5rks/W+LTrLGh5/FqGw9lNZt7WPXHOxZUtPbHHj3LCEkGMqH2uUfBkTaBZGAt4TbQzXHeU40/ER7jC7y8PoxHwNI3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATirxqNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATirxqNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4221F000E9;
	Thu,  2 Jul 2026 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011128;
	bh=x7m7szZ2RU7ua+I3Lvu8WNY2mjDPCpxj8Zxi4yV8Emc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATirxqNuMW2qxtsqF8ZKa20h63Qft0n4v0CqmMLicEnvaLIU+XLTNJ+6xGZu1BC5g
	 O0dTN31jXwBsmdpaAm25DVCEEQ0Ko1GryyJrZhs5RpZY+np9t4ferTqJ6Hr+69+xcs
	 7WL/2Kz+wNMm4A8kI+zAfBXbbsH2jZ1QH5wco/7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.6 167/175] NFS: Prevent resource leak in nfs_alloc_server()
Date: Thu,  2 Jul 2026 18:21:08 +0200
Message-ID: <20260702155119.305514207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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
@@ -1046,6 +1046,7 @@ struct nfs_server *nfs_alloc_server(void
 
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {
+		ida_free(&s_sysfs_ids, server->s_sysfs_id);
 		kfree(server);
 		return NULL;
 	}


