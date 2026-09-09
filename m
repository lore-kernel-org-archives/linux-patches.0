Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180A55867DF;
	Wed,  9 Sep 2026 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964331; cv=none; b=FmeUohHex7GgDbazz6YlzooXgUdL6U7TvMec6YITIbZadHoZnVRNDq/qQJLnbdiwm1BgUW4/IMG1if+iyidKOshmUxGY+iG0esgRl4A3+9jk60+5v+/nhqeF0fkXjAORwV9cBoa2fLAe5rUx0lNGgM5cAyTTVMNJ7kk0lsNO79s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964331; c=relaxed/simple;
	bh=pgtNT01hu69X+LSUK2ikHpjFPuTXwc6P/oldaMOlKjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueNf3lyLvQWmZwZWyqH48IjPO5SgaYClBWCzuVABzBzUundcyyk5sMLMn7g1ahb35+INYwOL1zwIjRIsIPSbRdgKTq/Rpr0dTz02NWLjHF0AzbcpY4d488qFTqIviHMDxfnJMW4PNcosvItnPuSHKORtlhc1mEIdyCpLrjoSfBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5Z7keNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5Z7keNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6148F1F00A3D;
	Wed,  9 Sep 2026 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964329;
	bh=ks8NcuYOZs53H7FBlXPpoqGSFy4orAfy2IgPulD9RWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5Z7keNzEP9/FDAQ6WhjbaNNLx6ikJ/0N5CGz8j8Z3U6cEWbwxNxWO4krDih0/1zC
	 YQz0wRSIrLW9yTzDMavXszy7ZtRDla5OjIfjO2wMXSBugT2ZpAmQB/BQ52SEtYK4Zf
	 cfqX9yI1Ky5iL9bSY/tYTxZ3NivUWUODGd+hJLV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Guanghui Yang <3497809730@qq.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 359/583] f2fs: fix dentry folio leak in find_in_level
Date: Wed,  9 Sep 2026 15:40:44 +0200
Message-ID: <20260909134250.439562375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

commit cca7d3e30bf30333314e31bc70b9a739f1342167 upstream.

find_in_level() gets a dentry folio with f2fs_find_data_folio() before
calling find_in_block().  If find_in_block() returns an error, the
function stores the error in res_folio and breaks out of the loop without
dropping the dentry folio.

This leaks the folio reference on the find_in_block() error path.  Drop
the dentry folio before returning the error to the caller.

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -313,6 +313,7 @@ start_find_bucket:
 
 		de = find_in_block(dir, dentry_folio, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
+			f2fs_folio_put(dentry_folio, false);
 			*res_folio = ERR_CAST(de);
 			de = NULL;
 			break;


