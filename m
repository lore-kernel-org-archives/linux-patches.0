Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD52741CB;
	Thu, 17 Apr 2025 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914441; cv=none; b=GfY+KZHmlWU8wcR3rH/ZBfp6lQcn87iK2fCc/m8S79Rj94weVmVsTthYpP7l66ZtHUDrJlFTB+Tv1MqI2th98d2UbUBFUj0gLo2WX/3QnwRXlYBxHWiEhjaTIkm2wHJgXnrgVp662igjKJsDkKOOG2LHzcngY2ds33RlTgiXd9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914441; c=relaxed/simple;
	bh=biZnd5/WNjVef1o93NFEnmkbs5EQenIY7kmHAeq2U68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V92XXNIU4XdXL8lCFsOZNh+/zRireVWuUwJo3gNDJgIwm1cZcZSJuHgCixYDSG0+/vQuux4KWjdvyhd+ozl0Y2Wa9R8Z+rGT5ylVSeRPUSeASzj0N0faveBWtVDL95cWeM2gK2fPzd4+UDgJMOp3wV9ZWOxqgZNZUtPRkN0Qe4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DD3xZdpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DD3xZdpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C9FC4CEE7;
	Thu, 17 Apr 2025 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914440;
	bh=biZnd5/WNjVef1o93NFEnmkbs5EQenIY7kmHAeq2U68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DD3xZdpu+E2OcB+qfxwxQW87wPsYFTfAl/2JJwpWmEg8E61WB8luXQ0C8Aidw4BnJ
	 M3n+jnFlT+nuBaXRst3b+c8YHMPf10rEdPCVmuTWG2A+12dA3zRpO6/7/FGvtvviWt
	 zhd+etM62cAfVO5ZOPTdGL+a4q7oohlnFgxUCfH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.13 209/414] xenfs/xensyms: respect hypervisors "next" indication
Date: Thu, 17 Apr 2025 19:49:27 +0200
Message-ID: <20250417175119.847644315@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 5c4e79e29a9fe4ea132118ac40c2bc97cfe23077 upstream.

The interface specifies the symnum field as an input and output; the
hypervisor sets it to the next sequential symbol's index. xensyms_next()
incrementing the position explicitly (and xensyms_next_sym()
decrementing it to "rewind") is only correct as long as the sequence of
symbol indexes is non-sparse. Use the hypervisor-supplied value instead
to update the position in xensyms_next(), and use the saved incoming
index in xensyms_next_sym().

Cc: stable@kernel.org
Fixes: a11f4f0a4e18 ("xen: xensyms support")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <15d5e7fa-ec5d-422f-9319-d28bed916349@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenfs/xensyms.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/xenfs/xensyms.c
+++ b/drivers/xen/xenfs/xensyms.c
@@ -48,7 +48,7 @@ static int xensyms_next_sym(struct xensy
 			return -ENOMEM;
 
 		set_xen_guest_handle(symdata->name, xs->name);
-		symdata->symnum--; /* Rewind */
+		symdata->symnum = symnum; /* Rewind */
 
 		ret = HYPERVISOR_platform_op(&xs->op);
 		if (ret < 0)
@@ -78,7 +78,7 @@ static void *xensyms_next(struct seq_fil
 {
 	struct xensyms *xs = m->private;
 
-	xs->op.u.symdata.symnum = ++(*pos);
+	*pos = xs->op.u.symdata.symnum;
 
 	if (xensyms_next_sym(xs))
 		return NULL;


