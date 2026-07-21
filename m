Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB2440096A;
	Tue, 21 Jul 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654379; cv=none; b=CHwXUQkQEcntRlLY+woCXDkwV2MUXZGc5Hzk5gcbFRSGU2l5hPqauch9pc8rzRiowAYHcIdZKwFpoGGyIz/SsgHuHeBdEBNmBBbuLKQE2sjZVOIEK6xvWpaxw3UtMwG8Y/Uw5IsLmQXEE/LjFvJfdnO0emZPnj5NrnT9EffA8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654379; c=relaxed/simple;
	bh=JZA01XTK99+rf7FvKrfY1L3DdO0Pd/AR0KdxlB9oYJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdc+LoEAOeIvMcClS8w7bS2YdnH4a0cuKP95paOz1rn7YPWEh918c8sfAt8qiasx/+wWIWCUPu4j5B06cbsTG+aDPUQwBQ5PIhj9aX+u23izeiuaimM2RTXosqg9qhlwHs/SOH8yGRSI1wWuxQYDmCseA+F+3JGR4zGrZR9zBPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW/AjNUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW/AjNUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C6B1F000E9;
	Tue, 21 Jul 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654378;
	bh=VAQw8gWGF28mN14xBRBkJnM+1LK7dxCMJH7akxo6cHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rW/AjNUoLBB/JSmVnrY6YQxdZZl8W0dJG3m16zluoubwnMiJ7pZedeDK9BBWkCLxT
	 w7NzP3MfcYp1UznGbWGXnQM8k9yz2wLP0LqKXdGEHSATHeDCKFoBvqyGIjS/xQbe85
	 fjiV6VOfw0By7AY76DfCkl+FcaRN2Dc4oCYzijwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ron de Bruijn <rmbruijn@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1682/2077] ntfs: fix off-by-one in mapping pairs decoding bounds checks
Date: Tue, 21 Jul 2026 17:22:35 +0200
Message-ID: <20260721152632.421242284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ron de Bruijn <rmbruijn@gmail.com>

commit 18760a74ef7c28df93726445b5595162e62ed341 upstream.

In ntfs_mapping_pairs_decompress(), attr_end points one byte past the
end of the attribute record:

    attr_end = (u8 *)attr + le32_to_cpu(attr->length);

The two bounds checks validating that mapping pair data bytes fit within
the attribute use strict greater-than (>), which allows a one-byte
out-of-bounds read when the data extends exactly to attr_end:

  b = *buf & 0xf;
  if (b) {
      if (unlikely(buf + b > attr_end))   // off-by-one
          goto io_error;
      for (deltaxcn = (s8)buf[b--]; b; b--)
          deltaxcn = (deltaxcn << 8) + buf[b];
  }

When buf + b == attr_end, the check evaluates to false and buf[b] reads
one byte past the valid attribute boundary. The same pattern appears in
the LCN delta bytes check.

Fix both checks to use >= so that buf[b] at exactly attr_end is
correctly rejected as out of bounds.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Ron de Bruijn <rmbruijn@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/runlist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -763,7 +763,7 @@ struct runlist_element *ntfs_mapping_pai
 	buf = (u8 *)attr +
 		le16_to_cpu(attr->data.non_resident.mapping_pairs_offset);
 	attr_end = (u8 *)attr + le32_to_cpu(attr->length);
-	if (unlikely(buf < (u8 *)attr || buf > attr_end)) {
+	if (unlikely(buf < (u8 *)attr || buf >= attr_end)) {
 		ntfs_error(vol->sb, "Corrupt attribute.");
 		return ERR_PTR(-EIO);
 	}
@@ -811,7 +811,7 @@ struct runlist_element *ntfs_mapping_pai
 		 */
 		b = *buf & 0xf;
 		if (b) {
-			if (unlikely(buf + b > attr_end))
+			if (unlikely(buf + b >= attr_end))
 				goto io_error;
 			for (deltaxcn = (s8)buf[b--]; b; b--)
 				deltaxcn = (deltaxcn << 8) + buf[b];
@@ -855,7 +855,7 @@ struct runlist_element *ntfs_mapping_pai
 			u8 b2 = *buf & 0xf;
 
 			b = b2 + ((*buf >> 4) & 0xf);
-			if (buf + b > attr_end)
+			if (buf + b >= attr_end)
 				goto io_error;
 			for (deltaxcn = (s8)buf[b--]; b > b2; b--)
 				deltaxcn = (deltaxcn << 8) + buf[b];


