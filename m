Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558A01F03D7;
	Fri, 21 Nov 2025 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731872; cv=none; b=rnxf1/bUPGY3foGJUjE9/C6brN/FIiED8IenejrDWk/7W5MLnEp0j6MTe3V+Rw/aPFu1xbq/sq1XSqmyHWOHdQcgtKCWsHdiFfPXrwgOg9/ti2upigNHGHQxZvFhRMnEPj/xK7V/hRGu6JRwB1kVxlSwo0yz6KtW19xMfUpAnIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731872; c=relaxed/simple;
	bh=nbxOrZ/26BUZTJK3yIuJeM+nrB1PsTUhL1bv/T20g7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggHTQfcI7wNQHK3ArqU3mdWsoxAJO/lY2qDDIQZyfL1TlWGsbig2VBth8pdXczN3TOCiLK6nUfP4zlD/ilM4z2dfYkL/Cy3O9yo2oLSykp0pwjnQ+7xDknjFZ1wkEoY2OaJ2VWKfls7qINWFItzFv/o26cwFgjUSl2iinEtXj7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGUpDjuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGUpDjuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB63AC4CEF1;
	Fri, 21 Nov 2025 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731872;
	bh=nbxOrZ/26BUZTJK3yIuJeM+nrB1PsTUhL1bv/T20g7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGUpDjuoEgEz8ZT9C0EWg8DKU0MX04ZQEPIVkozpF1uKn4qnOVfibWAYXup5aV9Ll
	 s4pSjuj4z3PkgKBk+7pLOqRd31aGpMWPXW95jgUwJQPdfU/SPAqcV7nKw2s4lljXcs
	 F+FeiQN5vVXtVSdTYBjGUEp1YsviX+DXEdpx/JHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	tianshuo han <hantianshuo233@gmail.com>
Subject: [PATCH 6.12 110/185] nfsd: fix refcount leak in nfsd_set_fh_dentry()
Date: Fri, 21 Nov 2025 14:12:17 +0100
Message-ID: <20251121130147.844096582@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: NeilBrown <neil@brown.name>

commit 8a7348a9ed70bda1c1f51d3f1815bcbdf9f3b38c upstream.

nfsd exports a "pseudo root filesystem" which is used by NFSv4 to find
the various exported filesystems using LOOKUP requests from a known root
filehandle.  NFSv3 uses the MOUNT protocol to find those exported
filesystems and so is not given access to the pseudo root filesystem.

If a v3 (or v2) client uses a filehandle from that filesystem,
nfsd_set_fh_dentry() will report an error, but still stores the export
in "struct svc_fh" even though it also drops the reference (exp_put()).
This means that when fh_put() is called an extra reference will be dropped
which can lead to use-after-free and possible denial of service.

Normal NFS usage will not provide a pseudo-root filehandle to a v3
client.  This bug can only be triggered by the client synthesising an
incorrect filehandle.

To fix this we move the assignments to the svc_fh later, after all
possible error cases have been detected.

Reported-and-tested-by: tianshuo han <hantianshuo233@gmail.com>
Fixes: ef7f6c4904d0 ("nfsd: move V4ROOT version check to nfsd_set_fh_dentry()")
Signed-off-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -268,9 +268,6 @@ static __be32 nfsd_set_fh_dentry(struct
 				dentry);
 	}
 
-	fhp->fh_dentry = dentry;
-	fhp->fh_export = exp;
-
 	switch (fhp->fh_maxsize) {
 	case NFS4_FHSIZE:
 		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOATOMIC_ATTR)
@@ -292,6 +289,9 @@ static __be32 nfsd_set_fh_dentry(struct
 			goto out;
 	}
 
+	fhp->fh_dentry = dentry;
+	fhp->fh_export = exp;
+
 	return 0;
 out:
 	exp_put(exp);


