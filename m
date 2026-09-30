Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDC14F7CBF;
	Wed, 30 Sep 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787948; cv=none; b=CISQdP7o6cjLTQJmDXsq12g2hOBTU9I2c/dCx6RKZQMcNtRXXDZn+PHI7O9ZKF4ClSgGEYlmFpchcVC4VBI3g8y3NM9hOwYSLedHAmNyP+hcScSegPe/4rba4nerR4FarUlYiM9/7VTfsajP7Zge/CmltM9oGwkiCXzwQkh1v+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787948; c=relaxed/simple;
	bh=OYSRCC3MB9EUQORme9bqWwzOiayF3KuwySw35aF/zgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/8MDsovPiQMEpoATJg1VVclJP0HE12TnIEAXCCl6h5Z8xFgff3jBCGolixvdctlM7GiUmQ7fKy49lCODwkmFWMOTvIfP4bDsD8gwwDrzg9AGcJhUW/tHaCGlnBrO2NV/hxQHlKPSLLnoLkTAODYonaI5jFmaaxuScHoWgRQ2DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxJYpA0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxJYpA0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CFF1F000FF;
	Wed, 30 Sep 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787947;
	bh=ZmB2hsysAy4qXU4dzovnHc1abuc4RgzlC/K316GybJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxJYpA0lEjS50nyU8DfCbYZSWywrXhieUw3XL5psnDMxYSffVJukmIovKxdooyd7+
	 LWGJI9I/5UISuMZ5pKco9jJJ8LEn7VVNzPTNqmpz+VwcQe7sS0cCWPxCgUltLNQmyn
	 Cb0WqLuzj5KM3vWZKYkcfneJ+IX6M2680YvlKBWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 411/457] smb: client: preserve create-context parsing errors
Date: Wed, 30 Sep 2026 17:28:36 +0200
Message-ID: <20260930152354.859714430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 2e828035d5d736d904c238ae7ec3f77c0d6270bf upstream.

smb2_compound_op() saves the result from compound_send_recv() in
tmp_rc. For SMB2_OP_OPEN_QUERY it then parses the CREATE contexts, but
the final assignment of rc from tmp_rc discards a parsing error. A
malformed create-context response can therefore be reported as
successful to smb2_query_path_info().

Keep a create-context parsing error in tmp_rc so it survives per-command
response processing and is returned to the caller.

Fixes: b07687edee99 ("cifs: Improve SMB2+ stat() to work also without FILE_READ_ATTRIBUTES")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -596,8 +596,10 @@ finished:
 		/* smb2_parse_contexts() fills idata->fi.IndexNumber */
 		rc = smb2_parse_contexts(server, &rsp_iov[0], &oparms->fid->epoch,
 					 oparms->fid->lease_key, &oplock, &idata->fi, NULL);
-		if (rc)
+		if (rc) {
 			cifs_dbg(VFS, "rc: %d parsing context of compound op\n", rc);
+			tmp_rc = rc;
+		}
 	}
 
 	for (i = 0; i < num_cmds; i++) {


