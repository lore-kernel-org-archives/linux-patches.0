Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C549C18CC11;
	Tue, 10 Sep 2024 10:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962588; cv=none; b=GFI19q0UZiqnujhsj7fVfzwW4wvzBX2PgytMhfW1YbohDXGeK+MqXuYc0MqXYnJDOtTT7nYDZeBalrbFhVxRinw+NbRIOCPu0wI37Lu1OuR+VmACYSqAnSFXFJ1iCVBtft/bNEPzSd43it1eH1Hr58o0IDZdlQgevvno4MRmsec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962588; c=relaxed/simple;
	bh=PXF2UyoIoNrAVdnhr/h6Glv4twhjnz4bNtqBcbif/EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5wLW0NL2bMWesp6iwHL/Z0K1JYDCtIVQUdbm/5nHXRObYZidyUSEoNyF6p1htmp+pwdXgkzsgrWGEmbMga37NkinMhEZsrxj42XGimYofU/rihamMzcfm/nPXmHGujS9pyB7lLXFofQ0/D9jq4lgJDh2SviFu8hCCWqJ90Zyvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFZCpqWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFZCpqWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C65C4CEC6;
	Tue, 10 Sep 2024 10:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962588;
	bh=PXF2UyoIoNrAVdnhr/h6Glv4twhjnz4bNtqBcbif/EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFZCpqWZtRr90P+vg0fuWR+y4CcbeELX+D052fBP56c3a57/Klwk8COHsbVjVRBbY
	 FB+8AzjiNXzBAc4e0++AD5kHL2+NtggLzRuX22yYlKR1LnGLlI62y9He9oXAGnator
	 0UBFTIseu9Lg2d7Hse9tvT/0OX5KzOx1vtUJJ1wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/121] btrfs: clean up our handling of refs == 0 in snapshot delete
Date: Tue, 10 Sep 2024 11:32:39 +0200
Message-ID: <20240910092549.888257023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b8ccef048354074a548f108e51d0557d6adfd3a3 ]

In reada we BUG_ON(refs == 0), which could be unkind since we aren't
holding a lock on the extent leaf and thus could get a transient
incorrect answer.  In walk_down_proc we also BUG_ON(refs == 0), which
could happen if we have extent tree corruption.  Change that to return
-EUCLEAN.  In do_walk_down() we catch this case and handle it correctly,
however we return -EIO, which -EUCLEAN is a more appropriate error code.
Finally in walk_up_proc we have the same BUG_ON(refs == 0), so convert
that to proper error handling.  Also adjust the error message so we can
actually do something with the information.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 202e6b6e2add..7e5ac187463e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4684,7 +4684,15 @@ static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
 		/* We don't care about errors in readahead. */
 		if (ret < 0)
 			continue;
-		BUG_ON(refs == 0);
+
+		/*
+		 * This could be racey, it's conceivable that we raced and end
+		 * up with a bogus refs count, if that's the case just skip, if
+		 * we are actually corrupt we will notice when we look up
+		 * everything again with our locks.
+		 */
+		if (refs == 0)
+			continue;
 
 		if (wc->stage == DROP_REFERENCE) {
 			if (refs == 1)
@@ -4751,7 +4759,11 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 		BUG_ON(ret == -ENOMEM);
 		if (ret)
 			return ret;
-		BUG_ON(wc->refs[level] == 0);
+		if (unlikely(wc->refs[level] == 0)) {
+			btrfs_err(fs_info, "bytenr %llu has 0 references, expect > 0",
+				  eb->start);
+			return -EUCLEAN;
+		}
 	}
 
 	if (wc->stage == DROP_REFERENCE) {
@@ -4885,8 +4897,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		goto out_unlock;
 
 	if (unlikely(wc->refs[level - 1] == 0)) {
-		btrfs_err(fs_info, "Missing references.");
-		ret = -EIO;
+		btrfs_err(fs_info, "bytenr %llu has 0 references, expect > 0",
+			  bytenr);
+		ret = -EUCLEAN;
 		goto out_unlock;
 	}
 	*lookup_info = 0;
@@ -5088,7 +5101,12 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 				path->locks[level] = 0;
 				return ret;
 			}
-			BUG_ON(wc->refs[level] == 0);
+			if (unlikely(wc->refs[level] == 0)) {
+				btrfs_tree_unlock_rw(eb, path->locks[level]);
+				btrfs_err(fs_info, "bytenr %llu has 0 references, expect > 0",
+					  eb->start);
+				return -EUCLEAN;
+			}
 			if (wc->refs[level] == 1) {
 				btrfs_tree_unlock_rw(eb, path->locks[level]);
 				path->locks[level] = 0;
-- 
2.43.0



