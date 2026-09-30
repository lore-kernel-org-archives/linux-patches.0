Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C5351DDF3;
	Wed, 30 Sep 2026 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793652; cv=none; b=jRGrJFQMSm5ErEJRYXVO+92mmWG19Wsm7GMfiFUG09dS98sP0RsYp+n+WX08GYD3Jv+5TY35eg6Y66B9uDOkQv+YEde6mqe5wnP2TQgcgCYOsBMnbzTWoN72NHC6eU6ABz5AgMevrjVzeqCqLJ+HYf2E70SN4g/Ho3OFJTkvB5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793652; c=relaxed/simple;
	bh=0azoUUaqZiWKW/YfvHAfDEQ1FHtCzi1vM9k1U6baZDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX3BGxFyWC9T6GeDMzsNNz3Yc5Fn0mZV/XsTnCTPKrhDPG5hNwmAKg5/DXIWdW1ANM3hssbhAHV1P2FCF9USEj+/fjK7ynvr0Zg4LAsk4U1OMP/T8TtZKwYmv9PFyUJOx6xqkg6XodCW94vuqhSivzKL6WoAbmeVXH/DIw1KChU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCjTl0A1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCjTl0A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDC01F000FF;
	Wed, 30 Sep 2026 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793650;
	bh=RiCIb4tt4WvvT5Vl9Vo4K9TjLHZ/Mw4c85K9Kse3MEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCjTl0A1J3+YahCFx0gtvKbAGEW6D8bwH8kG+1IA+SAWV4DHq96z6RV/s8xRRVoS9
	 +vDHdkktAlSIlMBtFHOhUwV3MsLb/gCc6n5ww2uj0TRsYQUa2Gyizjq1/P4WLVGUDf
	 3J4ZySpjdk6J4+N+TvUw4wz/vDP2xUEzN+5f79Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 331/395] smb: client: preserve create-context parsing errors
Date: Wed, 30 Sep 2026 17:29:53 +0200
Message-ID: <20260930152347.841027425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -696,8 +696,10 @@ finished:
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


