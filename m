Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5AE1F3B96;
	Mon, 23 Jun 2025 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714568; cv=none; b=iaDrgEQ177QQqwFnwX9NpCI27xuF0I0CI/J+X7sVLlg5xp0rMLWPYs8wpSF47vicWp63/TvwT1ZYdpHbbDJPO0536AoAJvImKKCuM2IwMNovCmLhcrhfYV2jk/Or9mpD8YElHXKPnWNQOE2feiRxnt1gvjQv/pfKvRp+AYKZaTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714568; c=relaxed/simple;
	bh=+IxT6NNiF4Dgt0cQ8KB7xh2N2NkTift8LZdCZXIUKBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/gyIPfTHdv25Ut4dBm0m9yKdKj6EQPcXkfj3xQiImyyDDqyczisPkQ5s1GvxEJRdR0PL3Eb4NmQKIKj+Sd32AfNDEoaDw4s/JM3CRqBWJNeiPQs+9ws8SZMDv7B6+a/7AQCsDfOk9Hfx+qBzW8iF7e72el1w4+Rr9RiKBzZOS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaWGZZFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaWGZZFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FB4C4CEEA;
	Mon, 23 Jun 2025 21:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714567;
	bh=+IxT6NNiF4Dgt0cQ8KB7xh2N2NkTift8LZdCZXIUKBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaWGZZFSnmKrzT7DySlxG0EBFRgn8/iDLas75WsaxV01FGcmtLfAGNToMOZdEpjmQ
	 7C/Mcl/puAC1lJAaC264BQHS901Ay/YEx53DRExAUOhbsBqnrQVrQyviQHJlWdFHC7
	 ag9Ev6+6iQdEseJs86p7FmB06DzR5m11+SWk4sKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Sortie Termansen <sortie@maxsi.org>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 402/592] isofs: fix Y2038 and Y2156 issues in Rock Ridge TF entry
Date: Mon, 23 Jun 2025 15:06:00 +0200
Message-ID: <20250623130710.001617762@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas 'Sortie' Termansen <sortie@maxsi.org>

[ Upstream commit 5ea45f54c8d6ca2a95b7bd450ee9eb253310bfd3 ]

This change implements the Rock Ridge TF entry LONG_FORM bit, which uses
the ISO 9660 17-byte date format (up to year 9999, with 10ms precision)
instead of the 7-byte date format (up to year 2155, with 1s precision).

Previously the LONG_FORM bit was ignored; and isofs would entirely
misinterpret the date as the wrong format, resulting in garbage
timestamps on the filesystem.

The Y2038 issue in iso_date() is fixed by returning a struct timespec64
instead of an int.

parse_rock_ridge_inode_internal() is fixed so it does proper bounds
checks of the TF entry timestamps.

Signed-off-by: Jonas 'Sortie' Termansen <sortie@maxsi.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250411145022.2292255-1-sortie@maxsi.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c |  7 +++++--
 fs/isofs/isofs.h |  4 +++-
 fs/isofs/rock.c  | 40 ++++++++++++++++++++++-----------------
 fs/isofs/rock.h  |  6 +-----
 fs/isofs/util.c  | 49 +++++++++++++++++++++++++++++++-----------------
 5 files changed, 64 insertions(+), 42 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 47038e6608123..d5da9817df9b3 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1275,6 +1275,7 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 	unsigned long offset;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 	int ret = -EIO;
+	struct timespec64 ts;
 
 	block = ei->i_iget5_block;
 	bh = sb_bread(inode->i_sb, block);
@@ -1387,8 +1388,10 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 			inode->i_ino, de->flags[-high_sierra]);
 	}
 #endif
-	inode_set_mtime_to_ts(inode,
-			      inode_set_atime_to_ts(inode, inode_set_ctime(inode, iso_date(de->date, high_sierra), 0)));
+	ts = iso_date(de->date, high_sierra ? ISO_DATE_HIGH_SIERRA : 0);
+	inode_set_ctime_to_ts(inode, ts);
+	inode_set_atime_to_ts(inode, ts);
+	inode_set_mtime_to_ts(inode, ts);
 
 	ei->i_first_extent = (isonum_733(de->extent) +
 			isonum_711(de->ext_attr_length));
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 2d55207c9a990..5065558375333 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -106,7 +106,9 @@ static inline unsigned int isonum_733(u8 *p)
 	/* Ignore bigendian datum due to broken mastering programs */
 	return get_unaligned_le32(p);
 }
-extern int iso_date(u8 *, int);
+#define ISO_DATE_HIGH_SIERRA (1 << 0)
+#define ISO_DATE_LONG_FORM (1 << 1)
+struct timespec64 iso_date(u8 *p, int flags);
 
 struct inode;		/* To make gcc happy */
 
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index dbf911126e610..576498245b9d7 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -412,7 +412,12 @@ parse_rock_ridge_inode_internal(struct iso_directory_record *de,
 				}
 			}
 			break;
-		case SIG('T', 'F'):
+		case SIG('T', 'F'): {
+			int flags, size, slen;
+
+			flags = rr->u.TF.flags & TF_LONG_FORM ? ISO_DATE_LONG_FORM : 0;
+			size = rr->u.TF.flags & TF_LONG_FORM ? 17 : 7;
+			slen = rr->len - 5;
 			/*
 			 * Some RRIP writers incorrectly place ctime in the
 			 * TF_CREATE field. Try to handle this correctly for
@@ -420,27 +425,28 @@ parse_rock_ridge_inode_internal(struct iso_directory_record *de,
 			 */
 			/* Rock ridge never appears on a High Sierra disk */
 			cnt = 0;
-			if (rr->u.TF.flags & TF_CREATE) {
-				inode_set_ctime(inode,
-						iso_date(rr->u.TF.times[cnt++].time, 0),
-						0);
+			if ((rr->u.TF.flags & TF_CREATE) && size <= slen) {
+				inode_set_ctime_to_ts(inode,
+						iso_date(rr->u.TF.data + size * cnt++, flags));
+				slen -= size;
 			}
-			if (rr->u.TF.flags & TF_MODIFY) {
-				inode_set_mtime(inode,
-						iso_date(rr->u.TF.times[cnt++].time, 0),
-						0);
+			if ((rr->u.TF.flags & TF_MODIFY) && size <= slen) {
+				inode_set_mtime_to_ts(inode,
+						iso_date(rr->u.TF.data + size * cnt++, flags));
+				slen -= size;
 			}
-			if (rr->u.TF.flags & TF_ACCESS) {
-				inode_set_atime(inode,
-						iso_date(rr->u.TF.times[cnt++].time, 0),
-						0);
+			if ((rr->u.TF.flags & TF_ACCESS) && size <= slen) {
+				inode_set_atime_to_ts(inode,
+						iso_date(rr->u.TF.data + size * cnt++, flags));
+				slen -= size;
 			}
-			if (rr->u.TF.flags & TF_ATTRIBUTES) {
-				inode_set_ctime(inode,
-						iso_date(rr->u.TF.times[cnt++].time, 0),
-						0);
+			if ((rr->u.TF.flags & TF_ATTRIBUTES) && size <= slen) {
+				inode_set_ctime_to_ts(inode,
+						iso_date(rr->u.TF.data + size * cnt++, flags));
+				slen -= size;
 			}
 			break;
+		}
 		case SIG('S', 'L'):
 			{
 				int slen;
diff --git a/fs/isofs/rock.h b/fs/isofs/rock.h
index 7755e587f7785..c0856fa9bb6a4 100644
--- a/fs/isofs/rock.h
+++ b/fs/isofs/rock.h
@@ -65,13 +65,9 @@ struct RR_PL_s {
 	__u8 location[8];
 };
 
-struct stamp {
-	__u8 time[7];		/* actually 6 unsigned, 1 signed */
-} __attribute__ ((packed));
-
 struct RR_TF_s {
 	__u8 flags;
-	struct stamp times[];	/* Variable number of these beasts */
+	__u8 data[];
 } __attribute__ ((packed));
 
 /* Linux-specific extension for transparent decompression */
diff --git a/fs/isofs/util.c b/fs/isofs/util.c
index e88dba7216618..42f479da0b282 100644
--- a/fs/isofs/util.c
+++ b/fs/isofs/util.c
@@ -16,29 +16,44 @@
  * to GMT.  Thus  we should always be correct.
  */
 
-int iso_date(u8 *p, int flag)
+struct timespec64 iso_date(u8 *p, int flags)
 {
 	int year, month, day, hour, minute, second, tz;
-	int crtime;
+	struct timespec64 ts;
+
+	if (flags & ISO_DATE_LONG_FORM) {
+		year = (p[0] - '0') * 1000 +
+		       (p[1] - '0') * 100 +
+		       (p[2] - '0') * 10 +
+		       (p[3] - '0') - 1900;
+		month = ((p[4] - '0') * 10 + (p[5] - '0'));
+		day = ((p[6] - '0') * 10 + (p[7] - '0'));
+		hour = ((p[8] - '0') * 10 + (p[9] - '0'));
+		minute = ((p[10] - '0') * 10 + (p[11] - '0'));
+		second = ((p[12] - '0') * 10 + (p[13] - '0'));
+		ts.tv_nsec = ((p[14] - '0') * 10 + (p[15] - '0')) * 10000000;
+		tz = p[16];
+	} else {
+		year = p[0];
+		month = p[1];
+		day = p[2];
+		hour = p[3];
+		minute = p[4];
+		second = p[5];
+		ts.tv_nsec = 0;
+		/* High sierra has no time zone */
+		tz = flags & ISO_DATE_HIGH_SIERRA ? 0 : p[6];
+	}
 
-	year = p[0];
-	month = p[1];
-	day = p[2];
-	hour = p[3];
-	minute = p[4];
-	second = p[5];
-	if (flag == 0) tz = p[6]; /* High sierra has no time zone */
-	else tz = 0;
-	
 	if (year < 0) {
-		crtime = 0;
+		ts.tv_sec = 0;
 	} else {
-		crtime = mktime64(year+1900, month, day, hour, minute, second);
+		ts.tv_sec = mktime64(year+1900, month, day, hour, minute, second);
 
 		/* sign extend */
 		if (tz & 0x80)
 			tz |= (-1 << 8);
-		
+
 		/* 
 		 * The timezone offset is unreliable on some disks,
 		 * so we make a sanity check.  In no case is it ever
@@ -65,7 +80,7 @@ int iso_date(u8 *p, int flag)
 		 * for pointing out the sign error.
 		 */
 		if (-52 <= tz && tz <= 52)
-			crtime -= tz * 15 * 60;
+			ts.tv_sec -= tz * 15 * 60;
 	}
-	return crtime;
-}		
+	return ts;
+}
-- 
2.39.5



