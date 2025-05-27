Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B711253F13;
	Tue, 27 May 2025 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366105; cv=none; b=asKrpjK9jr6aABgEA7SZ4WxwMWemKccrlJOpKI8asy1LGxMQ8Y7mNAVv3iYACcZAj+ok6UjWouaYhZ+FXEK7JFYWAkmnK8vPidhtNWta9gssXmbXemHN8m6Lc1W3/tsRfuiwMVhi7qfeH6hIlOTmHI0jAtTESeS/8ZFJbZ1IzqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366105; c=relaxed/simple;
	bh=wml5oamJbGcsUNUgbxYcB0gyrJGvu391AMieSTfa4b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkd5NJSPmgY3eRi7Atimk2uu61LJbZhaNTdRFXV3M5etMx7Bfo7d1upV30IAtw0856eJX1eJF2z7uzguhpbHiCX2j1aUaXAxd6F+AdS/OcYBbdG8pebfHeZqm4+kiAw2wIzXMx8YKxBgyDYcTQWVMXvUDaXhe10JnQsse9IG6XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdEWbGSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdEWbGSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECEDC4CEE9;
	Tue, 27 May 2025 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366105;
	bh=wml5oamJbGcsUNUgbxYcB0gyrJGvu391AMieSTfa4b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdEWbGSbAHSQqqtprGxCsBh7M4GPdB/s0fzjtv29iQU1JuIRKWTXz3Rkx2Y1FNMLp
	 16JSfRF3bjWQQqVdY7ymdVwXJ3TvPZsO3G/HFUBHq5ZB4xl6+Fz2ogeKx/ulWqPB7N
	 t5PRyKBSFC0Ycq1oS8jjUJQ6MgDLfr0DCBpvAT4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 593/626] smb: client: Reset all search buffer pointers when releasing buffer
Date: Tue, 27 May 2025 18:28:06 +0200
Message-ID: <20250527162509.088534793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Wang Zhaolong <wangzhaolong1@huawei.com>

commit e48f9d849bfdec276eebf782a84fd4dfbe1c14c0 upstream.

Multiple pointers in struct cifs_search_info (ntwrk_buf_start,
srch_entries_start, and last_entry) point to the same allocated buffer.
However, when freeing this buffer, only ntwrk_buf_start was set to NULL,
while the other pointers remained pointing to freed memory.

This is defensive programming to prevent potential issues with stale
pointers. While the active UAF vulnerability is fixed by the previous
patch, this change ensures consistent pointer state and more robust error
handling.

Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/readdir.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -733,7 +733,10 @@ find_cifs_entry(const unsigned int xid,
 			else
 				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
+			/* Reset all pointers to the network buffer to prevent stale references */
 			cfile->srch_inf.ntwrk_buf_start = NULL;
+			cfile->srch_inf.srch_entries_start = NULL;
+			cfile->srch_inf.last_entry = NULL;
 		}
 		rc = initiate_cifs_search(xid, file, full_path);
 		if (rc) {


