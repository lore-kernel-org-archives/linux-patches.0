Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFCD389477;
	Tue, 10 Mar 2026 11:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142057; cv=none; b=NQYEMyFyk4pwPA/REVEqzZx8U2HOtlH7boRXyAFq1z1nsMTl7TpvnxQnpwPyjUUGRPJRk2woYK67ueq57oozLWV65xNprRzbEtfbDLOw5fEi7cbgnYwk6IjdQllR5eL1vi+ZhNDmdRJufZO4TMVuCGEJ+E+MOLr+bwS1eueVWr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142057; c=relaxed/simple;
	bh=YwzR0tBFPChcpE9MEmClF792CDrgf4EQQ0tTx+KywkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMFTcX5IgQlMOaleke2ct8lxg2bfr9uZAhKDVSUNTQVqhiG7+zCVrflNAHsWDmutJxl7u8g89KEL7LDzPELzpWEXD6rDYr+Re6nVtEAmPbcw5c7cjWbOEGfPLzrlvFu/ugeRzeZgYPvRD22/qkT0ScSZ+7KR8gnoIS2sPKqU5jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nASli6K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nASli6K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ACEC2BC86;
	Tue, 10 Mar 2026 11:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142057;
	bh=YwzR0tBFPChcpE9MEmClF792CDrgf4EQQ0tTx+KywkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nASli6K7z4xP/YvwMZeJ1t6AqImWlvWG4SeKllqthWDTTM/RMjFXWvi9ZEgtndA3B
	 Z9cs7d7FHTbvaAwiwUA1GcBpWuGENyIoeixx5kaHaxNx+roZDxSYEia01k+ZWJxcV7
	 JJuWPskWGGc5EM7YmbE3qa6PahhPDQq5IpDtNeOyLqtJtRkAlTCGJBBoBId1MCVPFr
	 bmZlj67lbp2oCh7UuXLnSSVOzIA3ok9OWKuAloPpvOCsJGGrDEYFb2V4YaUe8oZHi6
	 g1rvfw/3NzhyyU6SPjMy0Q8E1bLzQLZ1BNXYdldpzdoL+RtjYVKZgXD7WL2ELpWlh6
	 S6SxS9AkChXeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 183/314] xfs: Fix error pointer dereference
Date: Tue, 10 Mar 2026 07:17:22 -0400
Message-ID: <2a9e2a7555ae4426381fd25df409f222ea99689b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit cddfa648f1ab99e30e91455be19cd5ade26338c2 upstream.

The function try_lookup_noperm() can return an error pointer and is not
checked for one.

Add checks for error pointer in xrep_adoption_check_dcache() and
xrep_adoption_zap_dcache().

Detected by Smatch:
fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
'd_child' dereferencing possible ERR_PTR()

fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:
'd_child' dereferencing possible ERR_PTR()

Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
Cc: stable@vger.kernel.org # v6.16
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/orphanage.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 9c12cb8442311..3c4f3b542c20f 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -445,6 +445,11 @@ xrep_adoption_check_dcache(
 		return 0;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
+	if (IS_ERR(d_child)) {
+		dput(d_orphanage);
+		return PTR_ERR(d_child);
+	}
+
 	if (d_child) {
 		trace_xrep_adoption_check_child(sc->mp, d_child);
 
@@ -482,7 +487,7 @@ xrep_adoption_zap_dcache(
 		return;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
-	while (d_child != NULL) {
+	while (!IS_ERR_OR_NULL(d_child)) {
 		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
 		ASSERT(d_is_negative(d_child));
-- 
2.51.0

