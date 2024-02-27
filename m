Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F38413B293;
	Tue, 27 Feb 2024 13:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041082; cv=none; b=c2bAwA615EZUMkWZxvcDL3N8FHXYYhgvzhiTqs1NsMSnb23ZNemyOVs4vKmriHsWCq7jtN5hWJoJ7PPML/4DjUqY43NyehL20kcKd+/aLin/3+dynFQe3w4lieUtfNPQMXEJuDJzPBwUn2nXZD/90RykFk3BHvdiJG/HI3nU3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041082; c=relaxed/simple;
	bh=m+krDVWp8DGIRZpgUsCrSUNjM1Zww75bH23oU5nPwRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZJwZS9lJeWINct9hmzdznrMIUP4/oizBSuO5UzXOJji3gZh6nUtte7yvPSOYyEvox7kRuGiDivLGxOUBCIvOuemPplcO4RsS2uhbPZGKaJfH/c+WBrsaPkjNMV18CZIP0tH9AOvxva4Bbb3PlIwv/MvPgUBKmBo0Bx1/AZdbg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmV0/pdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmV0/pdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F37EC43399;
	Tue, 27 Feb 2024 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041082;
	bh=m+krDVWp8DGIRZpgUsCrSUNjM1Zww75bH23oU5nPwRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmV0/pdStUt3jaflibSX0uHxpDmnHD+IJuJ58H/+GXIufApIiPAnNyKmKWdzADl0Y
	 pgPF0nd968y2nFpyC7BMIvqbmUVnf0z4Kvy+yaeJKQpZh+OQPQ8eqyhC1PeKqATpzn
	 QKJ5O8sHGd6r9fXs4a+nd9ZN93Zi3twR290hOXfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 184/334] md: Make sure md_do_sync() will set MD_RECOVERY_DONE
Date: Tue, 27 Feb 2024 14:20:42 +0100
Message-ID: <20240227131636.578989102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6 upstream.

stop_sync_thread() will interrupt md_do_sync(), and md_do_sync() must
set MD_RECOVERY_DONE, so that follow up md_check_recovery() will
unregister sync_thread, clear MD_RECOVERY_RUNNING and wake up
stop_sync_thread().

If MD_RECOVERY_WAIT is set or the array is read-only, md_do_sync() will
return without setting MD_RECOVERY_DONE, and after commit f52f5c71f3d4
("md: fix stopping sync thread"), dm-raid switch from
md_reap_sync_thread() to stop_sync_thread() to unregister sync_thread
from md_stop() and md_stop_writes(), causing the test
shell/lvconvert-raid-reshape.sh hang.

We shouldn't switch back to md_reap_sync_thread() because it's
problematic in the first place. Fix the problem by making sure
md_do_sync() will set MD_RECOVERY_DONE.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com/
Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
Fixes: 5fd6c1dce06e ("[PATCH] md: allow checkpoint of recovery with version-1 superblock")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240201092559.910982-4-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8813,12 +8813,16 @@ void md_do_sync(struct md_thread *thread
 	int ret;
 
 	/* just incase thread restarts... */
-	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
-	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
+
+	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+		goto skip;
+
+	if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
+	    !md_is_rdwr(mddev)) {/* never try to sync a read-only array */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		return;
+		goto skip;
 	}
 
 	if (mddev_is_clustered(mddev)) {


