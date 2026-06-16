Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF81644CAC9;
	Tue, 16 Jun 2026 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624361; cv=none; b=hWfapqREDHI13jLVZwCZ4mLT/ypIApZIkNCKlHJMMCr84troyZuUrRiAe6eMB9dd8rCw3Rv6dxusfqoUbpWdQrzg07MtQg3Xn3G9KVE5O+aYA1wy5Hwm01GZHKPkNxhPNimXm12ZWXfwOe+HeQzl5o5pk8nPkJlGQ7sQIq+QjEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624361; c=relaxed/simple;
	bh=QFzTNt46SXtP6xrwfZQ7RktYwnxTJe7Eg7Y0AfCxjMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFohg2QEd7zIyg3EqrEIawwpP18Yu9ezH8gV0Hdyipy8696tymnn/4nkcrfGVNX2RRtZw/Jlk7c/X+N5y9Ol6xVBgH2KklS1ad3nZwiANAt/ySxAk3+UvS0D7EVdOrY5JMt5EwEVTX+YBfChd0YULrdfeU+qL54ZnV1buwIfCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRS1cQ72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRS1cQ72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA711F000E9;
	Tue, 16 Jun 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624360;
	bh=LDoqt/ia1Xsvzye+TZCaevp0crLTgFjZSLG+f3jLI50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRS1cQ72taRldkxg58vLRpJivG1gNrMm9FIl5iqr2odfiS2MzwHJn5LteTYDBgmtk
	 gLdR7wQM+bzPy9GCOXDpYeiTs77VmoGq6c4IQ1D0zheX/xM4Xv9hs5TZIzcYzucFL2
	 q5v8J2jMfWNLoAMD9dwebz/Y+gSS5jtbybPm6evY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.0 321/378] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:29:12 +0530
Message-ID: <20260616145127.142816250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 65423079c7420e3dbf9a7aa345c243a3f5752e5d upstream.

__tb_property_parse_dir() does not check that content_offset +
content_len fits within block_len for the root directory case.
When rootdir->length equals or exceeds block_len - 2, the entry
loop reads past the allocated property block.

Add a bounds check after computing content_offset and content_len
to reject directories whose content extends past the block.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -187,6 +187,10 @@ static struct tb_property_dir *__tb_prop
 	if (is_root) {
 		content_offset = dir_offset + 2;
 		content_len = dir_len;
+		if (content_offset + content_len > block_len) {
+			tb_property_free_dir(dir);
+			return NULL;
+		}
 	} else {
 		if (dir_len < 4) {
 			tb_property_free_dir(dir);


