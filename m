Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC89314A4D0;
	Tue, 25 Jun 2024 09:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309277; cv=none; b=aSlyxsu0yFBjM2TiGK56fdInpU/8UH9n7NdtoErqDNBSjXWdrqTbReqKTLFPaPRqzpGy51tXW9BFdGVhgBI3U3TGir6vcN9/0BEqKRbJlKTFx5NfoN2emGuL4XYiyrecldOLldiExmmcwhU5u81gL0PFUP4AbYGQYvrU0M1sqBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309277; c=relaxed/simple;
	bh=GRhW53EAh9gzndTV6sb34M6h1tzdzyPLc9ErhJlYpDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsy+8ZughZD0EsI2hPELMW+6qn8apejGxSH0lGvfKjI98ZM4SaB8Qlexm6Zj+xxjkrPUusKKQ/17I5Bnsd1TbH1ZbWWdT3inE5FvlmXpkC6SeTXeRMAoIPJtWL2L2sMGzxnsl1IRvRuwxfqAIsnZuC2jYuLftqc3irKiVdlhJSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKvRjssQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKvRjssQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40733C32781;
	Tue, 25 Jun 2024 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309277;
	bh=GRhW53EAh9gzndTV6sb34M6h1tzdzyPLc9ErhJlYpDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKvRjssQrGoxwRvfASFWEc6yxA62TtnPHLrGsUFNwor9JRNZ5tiVVQgT+zKEC8jqb
	 IKBtIgrgC+Aex5JHWCLr22f49vjMn4HVwhMTfWRuObfj1dQVEk9186qjDoACbShck5
	 0NBAxgU+XGR+mlAjCjYALExni2jLKqoaFoaFDVnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Youzhong Yang <youzhong@gmail.com>
Subject: [PATCH 6.6 148/192] ovl: fix encoding fid for lower only root
Date: Tue, 25 Jun 2024 11:33:40 +0200
Message-ID: <20240625085542.839404923@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 004b8d1491b4bcbb7da1a3206d1e7e66822d47c6 upstream.

ovl_check_encode_origin() should return a positive number if the lower
dentry is to be encoded, zero otherwise.  If there's no upper layer at all
(read-only overlay), then it obviously needs to return positive.

This was broken by commit 16aac5ad1fa9 ("ovl: support encoding
non-decodable file handles"), which didn't take the lower-only
configuration into account.

Fix by checking the no-upper-layer case up-front.

Reported-and-tested-by: Youzhong Yang <youzhong@gmail.com>
Closes: https://lore.kernel.org/all/CADpNCvaBimi+zCYfRJHvCOhMih8OU0rmZkwLuh24MKKroRuT8Q@mail.gmail.com/
Fixes: 16aac5ad1fa9 ("ovl: support encoding non-decodable file handles")
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/export.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -186,6 +186,10 @@ static int ovl_check_encode_origin(struc
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	bool decodable = ofs->config.nfs_export;
 
+	/* No upper layer? */
+	if (!ovl_upper_mnt(ofs))
+		return 1;
+
 	/* Lower file handle for non-upper non-decodable */
 	if (!ovl_dentry_upper(dentry) && !decodable)
 		return 1;
@@ -214,7 +218,7 @@ static int ovl_check_encode_origin(struc
 	 * ovl_connect_layer() will try to make origin's layer "connected" by
 	 * copying up a "connectable" ancestor.
 	 */
-	if (d_is_dir(dentry) && ovl_upper_mnt(ofs) && decodable)
+	if (d_is_dir(dentry) && decodable)
 		return ovl_connect_layer(dentry);
 
 	/* Lower file handle for indexed and non-upper dir/non-dir */


