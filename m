Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C99223DD4;
	Mon,  2 Jun 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876570; cv=none; b=pmDYZrHNgkf8rt1vAiKOmSKyfepQXcrw85Zfen7e1l0FTDOiBx5imF+ZuGp9vMPMQzvy32QmaFxOE8jHD3uTfRIVz9o8hwk9yKMi1cYO/aTl3yqTAe4XD8HiPWQv/5oGp7PJeZHpfFCP5ID8eXf15OBnib2P7x2yhESLuXbnzDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876570; c=relaxed/simple;
	bh=/LZX5G/VECHYyMl/9T+0BhJ8WJjQU0myJhfZRnj8+bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOd/nMYYeC4ACOVc63aeth0OkGdOE3hzHNlbOxSBWOW2rD5zcicGQJiLsqWCVqFBUrfKUABHEeVuXBZ7uh1qUA5vYQG6zqkJYxqil/Y9csLzWaZWMNvlfCsCDAulKFufsUeCn4mUVbpeyK92dljBFvNDjlComlHsf/6eTWBYmo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE0RXooK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE0RXooK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5FBC4CEF3;
	Mon,  2 Jun 2025 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876570;
	bh=/LZX5G/VECHYyMl/9T+0BhJ8WJjQU0myJhfZRnj8+bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GE0RXooKoMGsykbBQW9EUMKCDgPXEkStSeQ5WC1/7ggFSO8p5h4a56qez/I0TF42/
	 hgaDjnAzppYSKe2JleR/upVCIJfYxx1yp4x35oDQdlF3TmwnuEl9OhOjBYywNFhSyI
	 JUNqHHhnGuSyTs/A2w9APu9Q/TOmcUl/879c0RJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 191/207] smb: client: Reset all search buffer pointers when releasing buffer
Date: Mon,  2 Jun 2025 15:49:23 +0200
Message-ID: <20250602134306.258959592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/readdir.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -762,7 +762,10 @@ find_cifs_entry(const unsigned int xid,
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


