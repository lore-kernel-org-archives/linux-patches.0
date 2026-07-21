Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B2F19049B;
	Tue, 21 Jul 2026 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654440; cv=none; b=e+GQ8gJ/xPvuxCngR50AW5FliLJHbYc7KQAA0jOio1s8yhmHTXrDwAVesjsCCGnx/usEbGYrv+gzNhng0uvC9P9cKPubD0tvrrA3L/9dMkXdelsmRM8WxNUTtib+Ga+P7q8PoBUxGDRcHirBQucO6hyqFW/7FpPMmmhV/h1h5TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654440; c=relaxed/simple;
	bh=hLlQAkk37Sd3QYvRp0zLLxpAXECoP42sd5puW6NQoz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm60oZpg2TnSeqpKasypIqttFq0zWLcnzlbWFrcezhKakkF8OopGLApNITaq9jV9P/LrAhAp0phWTjXLLNg+ANEDcK25OEipOkuDxnd4FrlFdocG5584x+3S3bCuVVddBou/U+eDA5qliU9MaPDJh47sVPyAPKbvQ5XgaL1LM5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6t0Fjrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6t0Fjrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CBB1F00A3A;
	Tue, 21 Jul 2026 17:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654439;
	bh=QJRdd4dYZz8t6ldptIuStPBc9dyI55OUbGI3HC2Jg2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6t0Fjrw96Wsa+kszDDAiouyUHoGzG0XU7Ytgc7kJUsz27Ymo7KQqTh7Uhl1R0lwE
	 IdudKy+DTqhvsDctC2RB/HZTRJEl2BF/Qh+/qrdJNZm1UNn0LnBhXb50+8gY78L8rR
	 Efl15gTV/gntbKZ3YDY+s5QBuI8I9KsKtrFNNhNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.1 1703/2077] fs/ntfs3: bound copy_lcns dp->page_lcns[] index in analysis pass
Date: Tue, 21 Jul 2026 17:22:56 +0200
Message-ID: <20260721152632.928048901@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 5e7b598660cfa8e5af172cf4c65cffc126333307 upstream.

In log_replay()'s analysis pass, after find_dp() returns a
valid DIR_PAGE_ENTRY for the (target_attr, target_vcn) tuple,
the copy_lcns block walks lrh->lcns_follow further entries:

	t16 = le16_to_cpu(lrh->lcns_follow);
	for (i = 0; i < t16; i++) {
	    size_t j = (size_t)(le64_to_cpu(lrh->target_vcn) -
	                        le64_to_cpu(dp->vcn));
	    dp->page_lcns[j + i] = lrh->page_lcns[i];
	}

find_dp() only validates that target_vcn falls within
[dp->vcn, dp->vcn + dp->lcns_follow), i.e., that the FIRST
cluster is covered.  The walk through the further entries is
not bounded against dp->lcns_follow.  For a malformed LRH
where target_vcn = dp->vcn + dp->lcns_follow - 1 and
lrh->lcns_follow > 1, the i > 0 writes overflow the dp's
allocated page_lcns[] array.

Add the missing j + lrh->lcns_follow <= dp->lcns_follow guard.

Reproduced under UML+KASAN on mainline 8d90b09e6741 as a
slab-out-of-bounds write of size 8 from log_replay+0x68d4 on
the mount path.

This is distinct from Pavitra Jha's 2026-05-02 patch
("fs/ntfs3: validate lcns_follow in log_replay conversion",
<20260502154252.164586-1-jhapavitra98@gmail.com>) which
addresses the separate version-0 dirty-page-table conversion
path's memmove(&dp->vcn, ...) call.  The two fixes are
complementary; both should land.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
[almaz.alexandrovich@paragon-software.com: clang-formatted the changes,
fixed conflicts]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3369,8 +3369,8 @@ move_data:
 
 		if (run_get_highest_vcn(le64_to_cpu(attr->nres.svcn),
 					attr_run(attr),
-				        le32_to_cpu(attr->size) - 
-				                le16_to_cpu(attr->nres.run_off),	
+					le32_to_cpu(attr->size) -
+						le16_to_cpu(attr->nres.run_off),
 					&t64)) {
 			goto dirty_vol;
 		}
@@ -4579,22 +4579,34 @@ copy_lcns:
 		 * whole routine a loop, case Lcns do not fit below.
 		 */
 		t16 = le16_to_cpu(lrh->lcns_follow);
-                t32 = le32_to_cpu(dp->lcns_follow);
-                if (le64_to_cpu(lrh->target_vcn) < le64_to_cpu(dp->vcn)) {
-                        err = -EINVAL;
-                        goto out;
-                }
-
-                for (i = 0; i < t16; i++) {
-                        size_t j = (size_t)(le64_to_cpu(lrh->target_vcn) -
-                                            le64_to_cpu(dp->vcn));
-                        if (j >= t32 || i >= t32 - j) {
-                                err = -EINVAL;
-                                goto out;
-                        }
-                        dp->page_lcns[j + i] = lrh->page_lcns[i];
-                }
+		t32 = le32_to_cpu(dp->lcns_follow);
+		if (le64_to_cpu(lrh->target_vcn) < le64_to_cpu(dp->vcn)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/*
+         * find_dp() only validates that target_vcn is the first
+         * cluster covered by dp.  The walk through lrh->lcns_follow
+         * further entries must stay within the allocated
+         * dp->page_lcns[] array, which is sized by dp->lcns_follow.
+         */
+		if (le64_to_cpu(lrh->target_vcn) - le64_to_cpu(dp->vcn) + t16 >
+		    le32_to_cpu(dp->lcns_follow)) {
+			err = -EINVAL;
+			log->set_dirty = true;
+			goto out;
+		}
 
+		for (i = 0; i < t16; i++) {
+			size_t j = (size_t)(le64_to_cpu(lrh->target_vcn) -
+					    le64_to_cpu(dp->vcn));
+			if (j >= t32 || i >= t32 - j) {
+				err = -EINVAL;
+				goto out;
+			}
+			dp->page_lcns[j + i] = lrh->page_lcns[i];
+		}
 		goto next_log_record_analyze;
 
 	case DeleteDirtyClusters: {


