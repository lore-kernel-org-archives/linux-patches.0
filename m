Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961342550DD;
	Thu, 17 Apr 2025 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913204; cv=none; b=Pu6Tvw3HhV2O+MpB9qNHa2gl+BITsChiee4WaaE3FnBR6IGJftsxg8eM7sT1UPr6Md3bewbUfFQIv37C63rd/l0x4Ecyj4URkce6EmWVhSLtM/BF+430h0xWgJwkkWIHQCdz5SSibcqsbwxVGns3tZdx8yg97d1TAW5TGfdPCWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913204; c=relaxed/simple;
	bh=EqxtXN5dtpzLTvCZtK1byL1xhTgea4nti74FCBdmj+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv9T9jCA+8uWCtdRxbygYv3ScLTujNtXaphukFrfm3/PU040w95yP0nsadu1asKqryfvMfmWezQPqQ46chiBTZJxsvTS3YjDXaPg+x73Ysjn9Pu9EhCE5pIs5re+rP9NAXRPHYQkFM7OsR89fEG8em2pY8IOFzpjhxVggezSzII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeNVi2Uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeNVi2Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E4BC4CEE4;
	Thu, 17 Apr 2025 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913204;
	bh=EqxtXN5dtpzLTvCZtK1byL1xhTgea4nti74FCBdmj+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeNVi2UyVxVAluqT3OKSk9ytJS9diwpm0mw2VmkGVSaAnS/r3TPh3i8YYOmViOrZQ
	 ZswHE5pxOC6BsMtrTFWUEyBa3SYB/mc/r2ptLEjMCaivZMA6ajDDXtuo8KApHoLw07
	 PorEJuFZVu7ax/zdDUDFsqVMgyf37ZriufJ9U72s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.14 231/449] xenfs/xensyms: respect hypervisors "next" indication
Date: Thu, 17 Apr 2025 19:48:39 +0200
Message-ID: <20250417175127.296702482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


