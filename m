Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640A8275B18;
	Fri, 21 Nov 2025 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731387; cv=none; b=SnVkPY2lBaLK9OM1+rANUdNOzJMCLnyGNKOkcz/7TrNHRqaavsDp5B3beCYPPtcH2hnj+xb2Jx5EwpLUcPepCTt1CANLI9O9yC48MWVFr4YmR2bzUllVScaxIF9KZx9pqsa7Lid4F+jtimyyL8PUm32pNdCJELlaaZ9DiSyG5yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731387; c=relaxed/simple;
	bh=ppFpRN69lDXCKu+LtDjvR5IZU8/H8qhEUb7Iypt7h8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOVQulW6wlS++fzPm8iVNuhBKYHZU/m/pKcg6cCual2c81Rc+xXjUKKGzqRgfPUkroNq05kQoH7Gp2pFMbJc3klUp9FuKsdty2yScpVy3/mdvWVg+49LT/VDtP+VaIUQPzxrK2rJF/MSKNiKYwgMjn+/2Y9jqGxMSMvCIaQcA/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcb3z1zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcb3z1zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D476AC4CEF1;
	Fri, 21 Nov 2025 13:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731387;
	bh=ppFpRN69lDXCKu+LtDjvR5IZU8/H8qhEUb7Iypt7h8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcb3z1zFccpxtUit1A+O70a+2m0w2Hi+8INBzlea5iD1lSW3HfoGL53FneNpCiDD3
	 4FQrX/n5ET1gGlmj7It7dCRjfbPTVxIcKciDkvCdVAUIZQa+XMsTqnnkqkgdqOQyg4
	 gyGDMgsrub4cH2ItiV8rpVS41wZzEjA+A9RJIHQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	tianshuo han <hantianshuo233@gmail.com>
Subject: [PATCH 6.17 158/247] nfsd: fix refcount leak in nfsd_set_fh_dentry()
Date: Fri, 21 Nov 2025 14:11:45 +0100
Message-ID: <20251121130200.393218648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -269,9 +269,6 @@ static __be32 nfsd_set_fh_dentry(struct
 				dentry);
 	}
 
-	fhp->fh_dentry = dentry;
-	fhp->fh_export = exp;
-
 	switch (fhp->fh_maxsize) {
 	case NFS4_FHSIZE:
 		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOATOMIC_ATTR)
@@ -293,6 +290,9 @@ static __be32 nfsd_set_fh_dentry(struct
 			goto out;
 	}
 
+	fhp->fh_dentry = dentry;
+	fhp->fh_export = exp;
+
 	return 0;
 out:
 	exp_put(exp);


