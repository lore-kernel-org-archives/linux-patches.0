Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71479225397;
	Mon,  2 Jun 2025 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874966; cv=none; b=At5wqxbfAdyis/OHwKIR7Hz7bNkNJvmKjKAbqqMEmJ35fstRCrjSiJMwJz6ZIm7yss5pP6h/xVLYYUXOn25ss1ERf4QcaVY70mJhu1iSUf4xFyeDaQuDgpcBK6L0rAg0MGwUFgJazPxkejM6H0Z+cg8o+Xz4wobZr90Dx59WBA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874966; c=relaxed/simple;
	bh=lJgbogWZx28G0Vp56DO/lyDPR4avV3j1b7Igw8YC4To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYbRgA7t60x4qRpO8Ni4rJr2trlgS0DMkqDOhBHSzCWF8cMT6sEudycn/BVtLa+7RwyL4Y97bx3mSbnizGJ+lGvTOVT9IveYeR3L+HDAuEX+pMQEjxcxbv6zUFGadIVvQyDzLJs1auo+5fZjlqUYtiJmsd1EbNa7vRcxeJL7fWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17PNx1HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17PNx1HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80993C4CEEB;
	Mon,  2 Jun 2025 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874966;
	bh=lJgbogWZx28G0Vp56DO/lyDPR4avV3j1b7Igw8YC4To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17PNx1HJNHAotGnz+Nf3uQgX7iJVG8VpsmeJNAY1/IqMoJhGXEEE5U09VQg9N96Ks
	 PQOje13jspDjNxiqN1E9r1zLblSyMST8l2LB/q3jWyxQxKIIsX0MCYRmdotyWj34Ts
	 riWY4iNBjtVnsoaqXBLEnvLjTPaLl7a+VbJhQvmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 190/204] smb: client: Reset all search buffer pointers when releasing buffer
Date: Mon,  2 Jun 2025 15:48:43 +0200
Message-ID: <20250602134303.145661621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,7 +621,10 @@ find_cifs_entry(const unsigned int xid,
 			else
 				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
+			/* Reset all pointers to the network buffer to prevent stale references */
 			cfile->srch_inf.ntwrk_buf_start = NULL;
+			cfile->srch_inf.srch_entries_start = NULL;
+			cfile->srch_inf.last_entry = NULL;
 		}
 		rc = initiate_cifs_search(xid, file);
 		if (rc) {


