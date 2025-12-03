Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A31C3446CE;
	Wed,  3 Dec 2025 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779702; cv=none; b=OE1xjzTCRESE6lAtYCJD5N+rRzjStuM4TULMhF8PEZPNS1CzxRXKOUjBk7n2qn0hlBN0U2l17/BR7MQCNQQMyJtZ5LpgTY54uqiEcPLzuaVAJIhVNAh9tyI1uQGsMCKHb0x/dVdGFOADLI89tsN4zFp9JraqBznfxvADwjPsIF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779702; c=relaxed/simple;
	bh=36ISm4nlkPAud1J38ihs+5B+w6q8p+8yirQCSjqWWEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVJSbtuxCCU1PWRr7u1OQTgOCPSKo/3T6XpsXAgaE2bf24pFGYTQQy5SYScjLieo3USmMey42LZNf2XDGxbgPnAe+yJv08nnULp2vLUN/0hc3WW66m9h/4Mz4Ku6QovTMi6eOojho2YUBVHu2XQihyW7r6nhJEAciX5xQTqqcNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et3g/4MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et3g/4MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9A2C4CEF5;
	Wed,  3 Dec 2025 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779702;
	bh=36ISm4nlkPAud1J38ihs+5B+w6q8p+8yirQCSjqWWEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et3g/4MMmSkvb+vTyTxOB53zYsdbJZNGXL0kHOMtnczjwqwz05oJBv4QM2UotDXEU
	 f0uV9stCyJNk4IvD+MHiggz4GkXAsmWwlPzsrOi9keNlB/C2N1BauLqAapxdrB/21y
	 q5l1zoe4sdKvZDzS7W4m/IdAnfMnv/R9aadkOQcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 335/568] smb: client: fix refcount leak in smb2_set_path_attr
Date: Wed,  3 Dec 2025 16:25:37 +0100
Message-ID: <20251203152452.979666443@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit b540de9e3b4fab3b9e10f30714a6f5c1b2a50ec3 ]

Fix refcount leak in `smb2_set_path_attr` when path conversion fails.

Function `cifs_get_writable_path` returns `cfile` with its reference
counter `cfile->count` increased on success. Function `smb2_compound_op`
would decrease the reference counter for `cfile`, as stated in its
comment. By calling `smb2_rename_path`, the reference counter of `cfile`
would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.

Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 7d3685cd345fd..452a60e09cbed 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -721,6 +721,8 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
 	if (smb2_to_name == NULL) {
 		rc = -ENOMEM;
+		if (cfile)
+			cifsFileInfo_put(cfile);
 		goto smb2_rename_path;
 	}
 	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
-- 
2.51.0



