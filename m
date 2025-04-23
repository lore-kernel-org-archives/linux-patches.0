Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4738226A082;
	Wed, 23 Apr 2025 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420814; cv=none; b=uUIsHNYsRpqMTDhN/IM9tCHcDM812yQMw7NkqnigsuVyYLWZrmU5qrAMCKDur8LqQjlteuGEfYqTGN8AWBGum3XJ+Mb7NmLwl/M7n4AwSsBHxh9tlbX7l9eFY97OCLiPwHI0+QZ2OpMKgdGHq+8Mw0bXYuTgB5CeEcpNE3QBO2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420814; c=relaxed/simple;
	bh=HhMW7h6yPlEVCTIndnZeoqJ4ysJviIg/6VKNf65EkMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrU435R8r2X24PnnhrlymfWR6j4qYSfKfYFBLEhCcxPp7hN4jpfyZQSOoSxp6T2KbHInnKL6qd0EWAg9CsTsHbJoDfQOvc0H/NlRoJSxO5BZoxQ0Sx35DRRhx6AfhRS2dhOywKR6pohygZ/ohJ+ymCz21MSD9/64ZX1XPuEO2qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKQAD4sR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKQAD4sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD6DC4CEE2;
	Wed, 23 Apr 2025 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420814;
	bh=HhMW7h6yPlEVCTIndnZeoqJ4ysJviIg/6VKNf65EkMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKQAD4sR90za/XrcixLt5ITARhdJL7U2YgQzZ59OouJs9DZpuadZAcsM0LbGDemyb
	 eiDF+DsVnGXXYpVG13LT2VglQnYW/77bVQ5+EYEVqYSgMc4frsAFq4o2sG+A9EMv/4
	 6gZ97bGdB7XyXM9h3ZkHQFI5aTyi1Htj+NpTBjvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 083/291] xenfs/xensyms: respect hypervisors "next" indication
Date: Wed, 23 Apr 2025 16:41:12 +0200
Message-ID: <20250423142627.758951997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 	struct xensyms *xs = (struct xensyms *)m->private;
 
-	xs->op.u.symdata.symnum = ++(*pos);
+	*pos = xs->op.u.symdata.symnum;
 
 	if (xensyms_next_sym(xs))
 		return NULL;


