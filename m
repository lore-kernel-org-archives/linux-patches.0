Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E332C94B;
	Fri, 17 Oct 2025 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714404; cv=none; b=j9Ox+LVDA//WkN4yCG7Js8n3ch+Gnq6ejAMINHPm4ZZe+9aDO9WCJFDs+tSz+iZzSM2ZT5teoBR0WSO4HXRoC4LykOu9ueLhTzEKUiFdITkT+R15VnQ0cLkSKuoZM7j4cC/Pw2TtrNTqYW4TOu5WDnjdkt46DsRQJFTz1T16tkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714404; c=relaxed/simple;
	bh=mEV7awBIDbr3o+PH4lU0K4Au74v8kW8onGvHomewJm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=me5oPyoYDbcIICoDrLxiTJo0vBAKs4qod7JcbPMF6NXE3RFip3QGJ0D/NUWKWVvbqnwPVLX3US9aWInFw5TxwO/uWrbuCeuWHnysgADXHsZLFcU6PgM+dg/xBT6vwlfOaY+iC+Xr7g0kvlnq/Ikil680JUVtFNFGySvhf+zYVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFebdp7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFebdp7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD7CC4CEE7;
	Fri, 17 Oct 2025 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714404;
	bh=mEV7awBIDbr3o+PH4lU0K4Au74v8kW8onGvHomewJm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFebdp7+zqm15O6Lv4y2MzeDn9pG34/xSuBtGID9B+QFBQjb5zqX92Ickultnkxjh
	 nsh+9sTS+3V1x/GTsGK5G2YmEjXWG11fcgtb1xzdYOBz4PeqlZW//3l0hsLDDUVMkL
	 QV44nGFjxwobVzFDrCI1wWusuPqTcho8nSuFDJ/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 132/277] fs/ntfs3: Fix a resource leak bug in wnd_extend()
Date: Fri, 17 Oct 2025 16:52:19 +0200
Message-ID: <20251017145151.945614221@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d68318471aa2e16222ebf492883e05a2d72b9b17 upstream.

Add put_bh() to decrease the refcount of 'bh' after the job
is finished, preventing a resource leak.

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1399,6 +1399,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		/* err = sync_dirty_buffer(bh); */
+		put_bh(bh);
 
 		b0 = 0;
 		bits -= op;


