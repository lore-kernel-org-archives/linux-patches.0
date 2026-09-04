Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815063B7B7B;
	Fri,  4 Sep 2026 05:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499138; cv=none; b=YCvqxP8s5eZ76YthOgItQH9g/Q4LoDAGSLJTNZ1GFp862aJHF6Y39mwykOS8DECVfz7WYHbk72eTYtZdSxhy3uCowHclql33oYcaOG2xc+2A3soxNzUQHwYEO3SV/lcWF+xKVRJeVK8HBGUqzYAcwq8R/0wV+RS1hl1kQ+5c+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499138; c=relaxed/simple;
	bh=gGgQVaRMxHSGhbmugf/6wTIe2dhlyuiFh0OsTKn9O2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHrZ+RUjRsS5NB3ElGgqgTMB/F7uk82gZlKQnjyd8bnq/W6FluM8f9Wt13GuTLRV10QBV3FWQ9Q1lfbaxZixA5E536qED5OputlJwXp39hM+fIYF2de5nVL4r34I+ZIZITRMphdSDIDgD/8LUQIl+3PNT8bPOP61xBUYs3eRPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8MQGzRi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8MQGzRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC85F1F00A3D;
	Fri,  4 Sep 2026 05:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499137;
	bh=DWKhB15tDo9J+1+vZDEthM6+dRxBBwA8z6DR3NoVNuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8MQGzRiHknpyO0LjkqR22Fr5UysFcQIjC7WjmMbuNAc0BS14GJq9HQV8Zv946c0J
	 HNnSVVcUPs0BVw7AOkQhwVywLFN4n1t6KG2TN+at9SFw1nvuT2rVPH8F+EvDkvOZ85
	 YMmnygIOs6sm/uGnVaeQsCTJjCbHitP6NrlIpzAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 268/713] ntfs: verify run length exceeding volume boundary
Date: Fri,  4 Sep 2026 06:53:56 +0200
Message-ID: <20260904045809.844311824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit fea9e4488f384c0ef1c0e3d96b565127c1b98447 upstream.

The mapping pairs decoder validates that the starting LCN is within the
volume but does not check if the run extends beyond the volume boundary.

A malformed NTFS image with a crafted mapping pairs array could cause
the kernel to access memory beyond the volume boundary, potentially leading
to memory corruption and privilege escalation.

Add validation to ensure lcn + length stays within nr_clusters.

Cc: stable@vger.kernel.org
Fixes: b4be3a47f8ba4 ("ntfs: bound the free-cluster bitmap scan to the volume")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/runlist.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -916,6 +916,28 @@ struct runlist_element *ntfs_mapping_pai
 				goto err_out;
 			}
 
+			if (lcn >= 0) {
+				s64 run_end;
+
+				/*
+				 * Ensure that the run stays within the volume.
+				 * A valid starting LCN is not sufficient because
+				 * the run length comes from disk.
+				 */
+				if (unlikely(check_add_overflow(lcn,
+						rl[rlpos].length,
+						&run_end))) {
+					ntfs_error(vol->sb,
+							"Run length overflow in mapping pairs array.");
+					goto err_out;
+				}
+				if (unlikely(run_end > (s64)vol->nr_clusters)) {
+					ntfs_error(vol->sb,
+							"Run extends beyond volume boundary.");
+					goto err_out;
+				}
+			}
+
 			/* chkdsk accepts zero-sized runs only for holes */
 			if ((lcn != -1) && !rl[rlpos].length) {
 				ntfs_error(vol->sb,


