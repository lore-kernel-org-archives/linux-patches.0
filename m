Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC9C4418EC;
	Tue, 21 Jul 2026 22:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672416; cv=none; b=DTSFW3BGR9m9EdCsezMppGVoQ7KjyhHiog+pvXPEGHFlPt5Ce3diWesCWoKm3+3fCUoI+geVEHUpHPATpmfqpEbr11svt27C2nRr18QXGL5UgyWjom/b7XpYtQf1Rb9hVPpMFm2gFtxi1AaQUfLYRIgC0EYCfAxImGeXnEDxXYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672416; c=relaxed/simple;
	bh=fmc0IGtUhCA+o/WO/JuyyScsgmNJV4n0Zc6ourRN7dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACG6tsNf/uXwD2EBIEcV72FsgZa7j7I6RnS2w0fzn0CjIeiJTsJpsEkjo/rj0+hbsR4lAA4iihnwP4IYOIyVtVOlH0ZABoPmsZMBkJ98c02kBgeEouO1/k7a3B1Lh/8aezWhasSw4jN72XZBisgZMUHqR/0LBNDSvvT1vk1g42I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvPww80G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvPww80G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF03F1F000E9;
	Tue, 21 Jul 2026 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672415;
	bh=e+B2tytJubSI14fk56GMkVhdVp+pmi6ApKEjC6vPNzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvPww80GPPuLbEdmflv1x2q4XDfb2xYB/1zh3AKpRJQ+qgtncIWB7UUEF8qhXSl55
	 Z9JUrERjMfz8hKOCOFsMM+DmzRv3EuPJQhbRk6AjyzL+AeIKQssmvjYHL3FbLzuCpH
	 8rTLftymTaBjj31qiti36f5STn8Kki95OL8GjIM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 615/843] fs/ntfs3: bound NTFS_DE view.data_off in UpdateRecordData{Root,Allocation}
Date: Tue, 21 Jul 2026 17:24:10 +0200
Message-ID: <20260721152419.888781295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

commit 3e127829e57f5190f612412ece4541cb96d5ec7a upstream.

In do_action()'s UpdateRecordDataRoot (fslog.c:3489) and
UpdateRecordDataAllocation (fslog.c:3697) cases, the memmove
destination is `Add2Ptr(e, le16_to_cpu(e->view.data_off))`,
where e->view.data_off comes from an on-disk NTFS_DE inside
an INDEX_ROOT or INDEX_BUFFER.  Neither case validates
view.data_off + dlen against e->size; the existing
check_if_index_root / check_if_alloc_index helpers walk the
entry chain and validate the entry's offset, but not its
internal view fields.

The neighbouring read sites (e.g., fs/ntfs3/index.c when
iterating view entries) check view.data_off + view.data_size
<= e->size.  Apply the same bound at the two memmove sites.

Reproduced under UML+KASAN on mainline 8d90b09e6741 via
pr_warn-only probe instrumentation: with view.data_off forced
to 0xFFFC, the memmove writes 32 bytes past the end of the
NTFS_DE.

This is similar in shape to Pavitra Jha's 2026-05-02 patch
"fs/ntfs3: prevent oob in case UpdateRecordDataRoot"
(<20260502105008.21827-1-jhapavitra98@gmail.com>) which
proposes calling ntfs3_bad_de_range(); that helper does not
exist in mainline.  This patch uses inline checks.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Reported-by: Pavitra Jha <jhapavitra98@gmail.com>
Closes: https://lore.kernel.org/ntfs3/20260502105008.21827-1-jhapavitra98@gmail.com/
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3512,6 +3512,18 @@ move_data:
 
 		e = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 
+		/*
+		 * e->view.data_off and dlen come from the on-disk
+		 * INDEX_ROOT entry / LRH.  The neighbouring read sites
+		 * (e.g. fs/ntfs3/index.c) check that
+		 * view.data_off + view.data_size <= e->size; mirror that
+		 * bound here so the memmove cannot reach past the entry.
+		 */
+		if (le16_to_cpu(e->view.data_off) > le16_to_cpu(e->size) ||
+		    le16_to_cpu(e->view.data_off) + dlen >
+			    le16_to_cpu(e->size))
+			goto dirty_vol;
+
 		memmove(Add2Ptr(e, le16_to_cpu(e->view.data_off)), data, dlen);
 
 		mi->dirty = true;
@@ -3720,6 +3732,12 @@ move_data:
 			goto dirty_vol;
 		}
 
+		/* See UpdateRecordDataRoot for the rationale. */
+		if (le16_to_cpu(e->view.data_off) > le16_to_cpu(e->size) ||
+		    le16_to_cpu(e->view.data_off) + dlen >
+			    le16_to_cpu(e->size))
+			goto dirty_vol;
+
 		memmove(Add2Ptr(e, le16_to_cpu(e->view.data_off)), data, dlen);
 
 		a_dirty = true;


