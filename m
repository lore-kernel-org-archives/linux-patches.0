Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8933101DC;
	Wed, 28 Jan 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615116; cv=none; b=AldXzJqQeyhFHjLeO4RvpO4siEjMqFb8ulq64Sw3DVo0HhrKfRb2yS38au0VsXX8KVo+qGMZIjRwL4ogwXvy/b0TulKM8aXt6oZ2n1u2OgUGR8Lr8TnqbaOEwNLPK8lny/bbIlQ8/Y1SDV6lRKeSS58j1iEqwL8yaEzbUjWcdPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615116; c=relaxed/simple;
	bh=nqFOmkLJa2hMtm56oBWm+VWv3FVXI15XPKYalmZKcTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5s0Q6RNutaaDQp+PcgysON64aQEbfQ6YNMCK2C/3sgqjc45NTfAZ+2aZNXs6OE0HnpBZjXUnqqv095p3mWWjaaO18LcToj/tl8OrU+fOr5m5Zbbu622r38JAfzE+boIwckxJTkZb7NgGWCOPb5wRYBjr7lj3hguCD3nm42QE0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrimUqcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrimUqcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF36AC4CEF1;
	Wed, 28 Jan 2026 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615116;
	bh=nqFOmkLJa2hMtm56oBWm+VWv3FVXI15XPKYalmZKcTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrimUqcQQcZ5MPuRuDjQeLYTQ4TGScv4lF9dYhyj3wo6IWqCL8IjI1/tDSamofsjS
	 NqYNItcqJREbgCl4jM+M3M5xnU20rdGYu4Tooe/6BVXZRZU6P8fB5zrwehsZBPVsOo
	 hz+cJy3R4M7mJfvV9Kt1aUEFZuuXUQ7ur9MekQM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 051/169] scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()
Date: Wed, 28 Jan 2026 16:22:14 +0100
Message-ID: <20260128145335.852662442@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 901a5f309daba412e2a30364d7ec1492fa11c32c upstream.

Memory allocated for struct vscsiblk_info in scsiback_probe() is not
freed in scsiback_remove() leading to potential memory leaks on remove,
as well as in the scsiback_probe() error paths. Fix that by freeing it
in scsiback_remove().

Cc: stable@vger.kernel.org
Fixes: d9d660f6e562 ("xen-scsiback: Add Xen PV SCSI backend driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20251223063012.119035-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1262,6 +1262,7 @@ static void scsiback_remove(struct xenbu
 	gnttab_page_cache_shrink(&info->free_pages, 0);
 
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 }
 
 static int scsiback_probe(struct xenbus_device *dev,


