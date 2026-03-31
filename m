Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E0E421EE4;
	Tue, 31 Mar 2026 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976042; cv=none; b=SLsAs7Ld7tTiwe+Ojgbizsek7BvgyuVyhh1AD1z2IGOXJ2Mx3VLoXykD1Vz/uMSYouiu5bh5SInYsAQbvB4sPClyZaBQLMbzdWxocoeoiw6V59YhZ4an9+7VnYIQdY3aWqetGFzOJCftoilG6mv/x6bufOIDhNNQtNHrcrSKFno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976042; c=relaxed/simple;
	bh=4/AzRwB9JQTvyJxF2prIUJFg4bKK/cZIcvlAmpta+V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/n9BNLJh4k4buhxfFyj3uMTnPCMQa9YMj5ASGL23aUbpA9ClleuTOARu3Nwt7FBKBCyc7c9py32f6Xlbx9HCmc7dCHRNfqFRgwku2KK6DmlPGNG/wNl03Z8hrYTupCDIHh3iTiR4IvjIjXHpbAMI5zsvWiTFGJQK0sPBGnLGSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xv99A3HO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xv99A3HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC989C19423;
	Tue, 31 Mar 2026 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976042;
	bh=4/AzRwB9JQTvyJxF2prIUJFg4bKK/cZIcvlAmpta+V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xv99A3HOiOPk3fU4EinffXeIP5NBR7WHh/6BGYMAYz62e+cOt4bQ8TmAOabS+7B3Z
	 gesPTlkoMmQyId3l0U4MQ70pwz1FOP0CVerKjh2sLvArFTOwLMncSaIHzYTiHXtYQs
	 AeWql8uqbir+J+x8QGTc5Z/pywuzZVz0H0doxPK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Yang <gerald.yang@canonical.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 185/244] ext4: fix stale xarray tags after writeback
Date: Tue, 31 Mar 2026 18:22:15 +0200
Message-ID: <20260331161748.589034347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit f4a2b42e78914ff15630e71289adc589c3a8eb45 upstream.

There are cases where ext4_bio_write_page() gets called for a page which
has no buffers to submit. This happens e.g. when the part of the file is
actually a hole, when we cannot allocate blocks due to being called from
jbd2, or in data=journal mode when checkpointing writes the buffers
earlier. In these cases we just return from ext4_bio_write_page()
however if the page didn't need redirtying, we will leave stale DIRTY
and/or TOWRITE tags in xarray because those get cleared only in
__folio_start_writeback(). As a result we can leave these tags set in
mappings even after a final sync on filesystem that's getting remounted
read-only or that's being frozen. Various assertions can then get upset
when writeback is started on such filesystems (Gerald reported assertion
in ext4_journal_check_start() firing).

Fix the problem by cycling the page through writeback state even if we
decide nothing needs to be written for it so that xarray tags get
properly updated. This is slightly silly (we could update the xarray
tags directly) but I don't think a special helper messing with xarray
tags is really worth it in this relatively rare corner case.

Reported-by: Gerald Yang <gerald.yang@canonical.com>
Link: https://lore.kernel.org/all/20260128074515.2028982-1-gerald.yang@canonical.com
Fixes: dff4ac75eeee ("ext4: move keep_towrite handling to ext4_bio_write_page()")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260205092223.21287-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/page-io.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -506,9 +506,15 @@ int ext4_bio_write_folio(struct ext4_io_
 		nr_to_submit++;
 	} while ((bh = bh->b_this_page) != head);
 
-	/* Nothing to submit? Just unlock the folio... */
-	if (!nr_to_submit)
+	if (!nr_to_submit) {
+		/*
+		 * We have nothing to submit. Just cycle the folio through
+		 * writeback state to properly update xarray tags.
+		 */
+		__folio_start_writeback(folio, keep_towrite);
+		folio_end_writeback(folio);
 		return 0;
+	}
 
 	bh = head = folio_buffers(folio);
 


