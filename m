Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F03C1C68C;
	Sun,  1 Sep 2024 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208234; cv=none; b=co305WlSAfTObas614MKHlUxsdi/APQayvDrZ7Wi4oN8J5dHuj2kira5OhnTm3rk4a1m6lxLJUC/xKjmFGm9DIXcGw09qyxqY/z1piyzXaCaOVrxV8bupzTrNmP0S7YcIAzE4lYK00FPzwEKxgHG44R/OOLyrTxBJMJhC7Z0FOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208234; c=relaxed/simple;
	bh=1kzh7LrC7veQMIPT7HM2WpjjMX5oEMyBTPOpZwMLDQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe15rLlNY8W/UwWo43zNxiw8K9qG+Bz1SX77DI7PYto7Kk4eAMt4vQ9Mj49jGvDii7t8wreOkFEYIkCYGQRkx0qUrpMB6BO7thy6kICm8A5abMGaIB2RdTOFxk437S54T4PSMrSCfH5D5iIEBY04NGF+q9YbdVMOZi7HdAjkQB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXfs1OZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXfs1OZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01EDC4CEC3;
	Sun,  1 Sep 2024 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208234;
	bh=1kzh7LrC7veQMIPT7HM2WpjjMX5oEMyBTPOpZwMLDQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXfs1OZ9JDYdg/A58Ay3f38Oq4zYewIRmmrWMbW9vnlHkfpjxEFAO48rr0WOcLcfr
	 givYl7VJfYIi1i4icrK0KJ8t4cy/tjAC9uFzTtqiX+whPeYYndPMh5aCASz1Is7N2W
	 XsCoNTY06Uw99XjcclWBjvunOyG/3K5FrjwMtIAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+242ee56aaa9585553766@syzkaller.appspotmail.com,
	Chunhai Guo <guochunhai@vivo.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.10 002/149] erofs: fix out-of-bound access when z_erofs_gbuf_growsize() partially fails
Date: Sun,  1 Sep 2024 18:15:13 +0200
Message-ID: <20240901160817.557372399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 0005e01e1e875c5e27130c5e2ed0189749d1e08a upstream.

If z_erofs_gbuf_growsize() partially fails on a global buffer due to
memory allocation failure or fault injection (as reported by syzbot [1]),
new pages need to be freed by comparing to the existing pages to avoid
memory leaks.

However, the old gbuf->pages[] array may not be large enough, which can
lead to null-ptr-deref or out-of-bound access.

Fix this by checking against gbuf->nrpages in advance.

[1] https://lore.kernel.org/r/000000000000f7b96e062018c6e3@google.com

Reported-by: syzbot+242ee56aaa9585553766@syzkaller.appspotmail.com
Fixes: d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
Cc: <stable@vger.kernel.org> # 6.10+
Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
Reviewed-by: Sandeep Dhavale <dhavale@google.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240820085619.1375963-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zutil.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -111,7 +111,8 @@ int z_erofs_gbuf_growsize(unsigned int n
 out:
 	if (i < z_erofs_gbuf_count && tmp_pages) {
 		for (j = 0; j < nrpages; ++j)
-			if (tmp_pages[j] && tmp_pages[j] != gbuf->pages[j])
+			if (tmp_pages[j] && (j >= gbuf->nrpages ||
+					     tmp_pages[j] != gbuf->pages[j]))
 				__free_page(tmp_pages[j]);
 		kfree(tmp_pages);
 	}


