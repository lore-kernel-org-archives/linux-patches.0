Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC7F21885A;
	Mon,  2 Jun 2025 14:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874236; cv=none; b=lZXBD2/3H1F4dWWEHaeLhv1VZ0aAw9jSoc4WdsMEPAS9SrprkJ6zGrGvanI9KNr9jFs43tY7X1V7bAXuKZj4KtyEYWbSzH0HR1/j8P2YGKkGpk1MZSvwal+OtFDacjiw7f3erf7oU/GpqppCJaQndR3ahaAEnE6GJcE5V/BP634=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874236; c=relaxed/simple;
	bh=7I8aIwNNmAb1ZkRXY3m8UrG//s+YGm1vyxFopSZFjZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGDPJlcZgW0juJz76Hg6jxW7YgTCRigRWpIOEFMk687hl1CPYujiMGBX2erpfc4aAPuISDpT9xarfTYJEwB3gY1Dt3J8UUO/tiY4I+9uttFguTr3bmHwLFUj2CQDoO82rDlV+7QNMhpX+yYQEjs8F4YKR/FVT0P0ldc0+Q9k4/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP2bUqT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP2bUqT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD53C4CEEB;
	Mon,  2 Jun 2025 14:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874235;
	bh=7I8aIwNNmAb1ZkRXY3m8UrG//s+YGm1vyxFopSZFjZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP2bUqT+yfUST5V0V6sAPSWCPAvYwXo8C9P9AfU6FOWLxCvUYwYADXpBTfpjH9tNf
	 NINZbS5JVT+KG+qW8wXxY2uk3dou3pv4v6OmGcOH0UtAQbeFQp/66QxgKbabrC0i9r
	 iH9VwvfC9B3JL7HCj3grlqRbWG+jGBZBpPiO70tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 373/444] smb: client: Reset all search buffer pointers when releasing buffer
Date: Mon,  2 Jun 2025 15:47:17 +0200
Message-ID: <20250602134356.054231155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


