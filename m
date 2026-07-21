Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED3419049B;
	Tue, 21 Jul 2026 17:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654408; cv=none; b=EwuLrSYBf0yBI9HqtdP27F8wU8/SHHsI7Tl5wKLbtBsMpJfqlEab3Y2/1j6f5YdxcXvFt44FcPg+iptJPZwqJhfqIS5J/XykwOGDWrWdeC+X+o4vxtwlN+3jJux5WAdE7Tjs2jsSSlyCesAyhNJxI0ZOqI0mX2qWbFzLWfT8h3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654408; c=relaxed/simple;
	bh=1Vs/gCFoz5UZS+d0wSxCCzjs4LPQgZDnOeugxYCZhWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeircWa6oM1nZd1jlCW/KZ3yHTvQKp8JOOr/YJ8VogLg8UKZSy9jbouluAqkhaFpERDlQSY7bc1n0ocn7qU8JoixxIpM2rhrVuqO8HWOipSxmSLd5lzgaAs1upprcGFazh9dgK94FiMQCnIFZ5owcw+lpZvMovtMffxSPBTdM3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHYQqXJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHYQqXJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182751F000E9;
	Tue, 21 Jul 2026 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654407;
	bh=tjOTa14Ap+tpJ9+m63Grc+1m+1dnCI7jtYyVlWuWpXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHYQqXJIDbPO/PGMDG94RtThDUp1EJ13ZXEWYs/3te3dQFvikUeXfODVyovTXRxmW
	 6rLoB9iTb14O85Xc7woOd1Ap3fMrlTbbXsavsLMDEloX3SgBZqQ1S1b9gG1HVerYyE
	 cA0tsjPcHsaSDhkfPS3n9BOyX9S+IcKb9h0am63E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1692/2077] ntfs: reinit search context before volume information lookup
Date: Tue, 21 Jul 2026 17:22:45 +0200
Message-ID: <20260721152632.663984742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

commit 45dd046ced0f5982a6d64ca449de3a61f5f15669 upstream.

On mount the volume inode is searched for $VOLUME_NAME and then, reusing
the same search context, for $VOLUME_INFORMATION. The $VOLUME_NAME lookup
is optional and its result is otherwise ignored.

Once lookup-time validation can reject a corrupt $VOLUME_NAME with -EIO,
the search context is left in an undefined state: ntfs_attr_find()
documents that on an actual error @ctx->attr is undefined. Continuing the
$VOLUME_INFORMATION search from that context is not contractually valid.

Reinitialize the search context before the $VOLUME_INFORMATION lookup so
it always starts from a well-defined state regardless of the
$VOLUME_NAME lookup outcome.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1537,6 +1537,7 @@ iput_volume_failed:
 			vol->volume_label = NULL;
 	}
 
+	ntfs_attr_reinit_search_ctx(ctx);
 	if (ntfs_attr_lookup(AT_VOLUME_INFORMATION, NULL, 0, 0, 0, NULL, 0,
 			ctx) || ctx->attr->non_resident || ctx->attr->flags) {
 		ntfs_attr_put_search_ctx(ctx);


