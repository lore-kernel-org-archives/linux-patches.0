Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA3C2571BC;
	Thu, 17 Apr 2025 18:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915665; cv=none; b=DX1Wxh8Jcets031YpoLhiDY5f5kHuLlCV/0PcErh9xn5iptGU2S2N3RdMdEhBj+zpjWp31q24KVcdUPVb56pnRTfnzR7CH6KVqYmTHjbylSf0OmPaSBYuodcc8TfDsVV6SIUhpc3vlWwYjoxoe2pJUqQfMfqOAYaaVZXNoFmDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915665; c=relaxed/simple;
	bh=tmuR7LT/CnChGLP0IAxzH6Tp+l/su7xqYyAaautac3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6CpbbsotZP5N4pEJHUbTyE8ETOd2HUavothiMzY+IlRXwxFCuXYC3gB+J9YOhyzmwFOM+MnlyBbhhUVgp8daIDCenMMOmWLriQI5ooUCHZnxLABEeQ+6KJ/FO198ONtF9znxZu57IPmM0QfVyhNysyw143JERF//g7wwuFfGu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5U2T3U1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5U2T3U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEFEC4CEE4;
	Thu, 17 Apr 2025 18:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915665;
	bh=tmuR7LT/CnChGLP0IAxzH6Tp+l/su7xqYyAaautac3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5U2T3U1iJt5v0WQHEoBeTnR69JPM6hK8GnL8CRsZ40ALCmvPf4SUVxGnAOx71lmZ
	 MB0ly8IG453iGZgNP8EILG3k4yEoZMYdzUHw/yJZqswdwiEWgitJuLJdnJajsO6LK6
	 v6gqwscLUlQ6xL1FUPgbokaZwxJxVcq1X3btfYHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 201/393] xenfs/xensyms: respect hypervisors "next" indication
Date: Thu, 17 Apr 2025 19:50:10 +0200
Message-ID: <20250417175115.670641452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


