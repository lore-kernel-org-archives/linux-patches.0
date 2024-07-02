Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD81BE223;
	Tue,  2 Jul 2024 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940574; cv=none; b=AxSTNRjgYDZ4cmhzQ19BOUIwh81k4nWOyOXT6Aww06st81+RObzfN2iEwKGGzlrohIBEaI0V5G+IqP33fUGA6mLzfhMpnP3bYDZxHUdGNyDSQDuiuHWsWcOT7vqIj+/aE6mK8yCFVcueVDHvI6PGLorgDAOFjSiut1buThMTCLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940574; c=relaxed/simple;
	bh=H/c4Y/qfWhW6nftjHpED4gs5usWCkPH8nyX3BhprWLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXXQAaA8PVW+TTmvqv/CRH2XHoAzysbqswdfww5y15wgJlnBCahhHaLtv/X8cLn9NhuTdpYZR11rpBWWt+VPKLYjsa2TtU3izOX7By5mKG8SKRNv0GafQzc9dRCJfZxTKBvw8kq31kA7eCd7N4QeoLOIeg7MuWPdG0noOJJaLfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeG+ufzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeG+ufzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71022C116B1;
	Tue,  2 Jul 2024 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940573;
	bh=H/c4Y/qfWhW6nftjHpED4gs5usWCkPH8nyX3BhprWLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeG+ufzNNo6uCZqQOs6FsoOUaML+IGBQv3HwlpG4ORNh8jZnoc3VN5y00pHWdGZJp
	 CXqD+QMcbIWI2IMm9OkE9AkZU8Iy9/+sUy+LcIA01XON29YNOJLb9yIIpvwTc6u/hb
	 KruUVATXWloSzEwz6Fxnp64Lk25TDSJFc7MPj87I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e49ccab73449180bc9be@syzkaller.appspotmail.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.9 196/222] bcachefs: Fix sb_field_downgrade validation
Date: Tue,  2 Jul 2024 19:03:54 +0200
Message-ID: <20240702170251.477775156@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 692aa7a54b2b28d59f24b3bf8250837805484b99 upstream.

- bch2_sb_downgrade_validate() wasn't checking for a downgrade entry
  extending past the end of the superblock section

- for_each_downgrade_entry() is used in to_text() and needs to work on
  malformed input; it also was missing a check for a field extending
  past the end of the section

Reported-by: syzbot+e49ccab73449180bc9be@syzkaller.appspotmail.com
Fixes: 84f1638795da ("bcachefs: bch_sb_field_downgrade")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/sb-downgrade.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -134,7 +134,8 @@ downgrade_entry_next_c(const struct bch_
 #define for_each_downgrade_entry(_d, _i)						\
 	for (const struct bch_sb_field_downgrade_entry *_i = (_d)->entries;		\
 	     (void *) _i	< vstruct_end(&(_d)->field) &&				\
-	     (void *) &_i->errors[0] < vstruct_end(&(_d)->field);			\
+	     (void *) &_i->errors[0] <= vstruct_end(&(_d)->field) &&			\
+	     (void *) downgrade_entry_next_c(_i) <= vstruct_end(&(_d)->field);		\
 	     _i = downgrade_entry_next_c(_i))
 
 static int bch2_sb_downgrade_validate(struct bch_sb *sb, struct bch_sb_field *f,
@@ -142,7 +143,9 @@ static int bch2_sb_downgrade_validate(st
 {
 	struct bch_sb_field_downgrade *e = field_to_type(f, downgrade);
 
-	for_each_downgrade_entry(e, i) {
+	for (const struct bch_sb_field_downgrade_entry *i = e->entries;
+	     (void *) i	< vstruct_end(&e->field);
+	     i = downgrade_entry_next_c(i)) {
 		if (BCH_VERSION_MAJOR(le16_to_cpu(i->version)) !=
 		    BCH_VERSION_MAJOR(le16_to_cpu(sb->version))) {
 			prt_printf(err, "downgrade entry with mismatched major version (%u != %u)",


