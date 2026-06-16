Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB373BFE5A;
	Tue, 16 Jun 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634290; cv=none; b=TvquwpoI1blq5rEl08XjR1oTcYbvWsW584mI5ZH+qdGXVMseg6DexwmIUUvH83mAa423XYfxwAspoLkuhmtrdQy6qbVwBHoOxEP3Y5bPQphcK1DGdnXLWHVVNDFc+4W9a1dRKtbs4RMTXUJ+KyjJLPdbMCIy4uE67o4k+McNzUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634290; c=relaxed/simple;
	bh=5IMemjpgcxfmh+4m7IvY/x10iALAeeJfUlks8QAzYxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI8rFe50HRL3UGbo1HuzyE7DwjAOWGNijY1sbrDnRiJKQbNGJ02NhQkz2l1DxGMK5KSfRgiM52R+yPL2r0FVhtNDF3++8WaT8HKWx0IfeTPoqDOsfIOzmCDLfMlMEW8TXBKgEJ94dZQaNp9ba07FOm5NhOw5v4EocRgnZFBbJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJYEzw63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJYEzw63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C133C1F000E9;
	Tue, 16 Jun 2026 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634289;
	bh=yjzRsMPDU/a0kvANg6/PcPyulI+3mBvMj3nJitOiNd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJYEzw63AoShfmwB8UmJ3jrvkbVONVSzapWVYwrIWuVAMIHTWq4+Hv4L0IQzFkbo0
	 YL7pE2XYmijU+17owlS10+GVnAbbOqWkdgxGzK/bTmA1rI66n4nMnfXcBpSXRvLHaQ
	 Ng2AMXHAwZlV/LKswP72uEwcVIShOFU3qiXyKC6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 238/411] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:27:56 +0530
Message-ID: <20260616145113.502046684@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -181,6 +181,10 @@ static struct tb_property_dir *__tb_prop
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


