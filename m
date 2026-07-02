Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07927349CE8;
	Thu,  2 Jul 2026 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010657; cv=none; b=j8OMTpxGzFFTC3rdOW/GMXlh7E/LpOTRq/cRAG/KX/xt1oHCKqhk505Wwfv40Lg97ldGw0Thk3kmYdTM0vniuwDJfhLGt3GO+z6zNu6IBopOKK+4vCzOAfbQIBaC0YZ4ocGa4Vc+HFvm1zMAxcWSlKVNImcCgSRcJdIK7n2HP4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010657; c=relaxed/simple;
	bh=lUFjvK9dkErmPU+9FAA+wG410XOFht8Pz23cnxuKyKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6m2c+fE9L8a+ShFrXJ7j/jmJOz+qsdgAn2FRybxnChEAQHvesCvckEXxM5Zg5fvJguxqqdGJlfX5Of3ZI2m7l5DenYdgKOOzVOV1H+PdYd3de19HCtG8ZQtAyL6Y7ziVpX+pNts8AGdQ/qsxSm58lbw0meecCUkt3whlHe3V2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x++Rs8XU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x++Rs8XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8991F000E9;
	Thu,  2 Jul 2026 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010655;
	bh=wRjp1iyDMNfaLI8YFJhiqXdsbpf5JV2GcJ6NOvpNklE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x++Rs8XUgloTkE2/lcwkHNS/cdOPNXd+JORBFCqfZWtZjr+FwRowTGdbmlTxdyDdF
	 xY9gC2yum/3i/DRRAae6YIlIJWFAFMQ0S9t0ANczgijPamzWEiQYSH5FbrKyLP8Rk9
	 zGP45bSddbCbX5WjFZTgddjr73bNuMwx3vvBHKBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.12 191/204] NFS: Prevent resource leak in nfs_alloc_server()
Date: Thu,  2 Jul 2026 18:20:48 +0200
Message-ID: <20260702155122.663404382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1054,6 +1054,7 @@ struct nfs_server *nfs_alloc_server(void
 
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {
+		ida_free(&s_sysfs_ids, server->s_sysfs_id);
 		kfree(server);
 		return NULL;
 	}


