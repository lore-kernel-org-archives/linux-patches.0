Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF3C3AB29E;
	Fri, 24 Apr 2026 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038289; cv=none; b=BpdmdJVgye0mxWndmVjj9ofIQHudhRs1qQdetMyWTirNezn+U2qPfWcaRMDb0F8pXPrVDrjG393CclW5G8u2+vpbK7GG6j628PnG5oN7zxeWEZwqQoSf0dGTR6fJ8BcCyHDkY0ME7n+brSoeqk0fCurocq2+2BPNMIycSiOunOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038289; c=relaxed/simple;
	bh=6aRp42PcungjSeRm4p9mi8Yd33CEawvLVRN6GC1xlHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDOreStP0+Lx6AhbCV2vm2zN4UpbPhHeqPTdwFagZPbM4DUSJVyS1K61XMv9w+E866AX25UmEX5wL7feMnnhSpQT+qgqWCMNZH0BpU5GXbrhsKnXRX8NCkEHqCp8v3TevgqoqaCbnE7k703lEPgwxdCM4oewSfSBqmqewSAfJCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awaS0AWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awaS0AWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D71C2BCB5;
	Fri, 24 Apr 2026 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038289;
	bh=6aRp42PcungjSeRm4p9mi8Yd33CEawvLVRN6GC1xlHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awaS0AWjYJcHd7RUl1WFEMtTdBTHDE8VB7PO25j06+AUOwvyTsaAHaKwMx6X40u6K
	 usFAjWdyRbmProTPTLBbyH5raw8NSuoVVNL20DLW2JiaZDEITLxb3GaT/SM3dRSBLH
	 /fT9m/BlwYT1xV8Cqw+qc1IPKcWIYdqxw+GmqtqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 14/35] fs/ntfs3: validate rec->used in journal-replay file record check
Date: Fri, 24 Apr 2026 15:31:21 +0200
Message-ID: <20260424132414.643017526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 0ca0485e4b2e837ebb6cbd4f2451aba665a03e4b upstream.

check_file_record() validates rec->total against the record size but
never validates rec->used.  The do_action() journal-replay handlers read
rec->used from disk and use it to compute memmove lengths:

  DeleteAttribute:    memmove(attr, ..., used - asize - roff)
  CreateAttribute:    memmove(..., attr, used - roff)
  change_attr_size:   memmove(..., used - PtrOffset(rec, next))

When rec->used is smaller than the offset of a validated attribute, or
larger than the record size, these subtractions can underflow allowing
us to copy huge amounts of memory in to a 4kb buffer, generally
considered a bad idea overall.

This requires a corrupted filesystem, which isn't a threat model the
kernel really needs to worry about, but checking for such an obvious
out-of-bounds value is good to keep things robust, especially on journal
replay

Fix this up by bounding rec->used correctly.

This is much like commit b2bc7c44ed17 ("fs/ntfs3: Fix slab-out-of-bounds
read in DeleteIndexEntryRoot") which checked different values in this
same switch statement.

Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2789,13 +2789,14 @@ static inline bool check_file_record(con
 	u16 fn = le16_to_cpu(rec->rhdr.fix_num);
 	u16 ao = le16_to_cpu(rec->attr_off);
 	u32 rs = sbi->record_size;
+	u32 used = le32_to_cpu(rec->used);
 
 	/* Check the file record header for consistency. */
 	if (rec->rhdr.sign != NTFS_FILE_SIGNATURE ||
 	    fo > (SECTOR_SIZE - ((rs >> SECTOR_SHIFT) + 1) * sizeof(short)) ||
 	    (fn - 1) * SECTOR_SIZE != rs || ao < MFTRECORD_FIXUP_OFFSET_1 ||
 	    ao > sbi->record_size - SIZEOF_RESIDENT || !is_rec_inuse(rec) ||
-	    le32_to_cpu(rec->total) != rs) {
+	    le32_to_cpu(rec->total) != rs || used > rs || used < ao) {
 		return false;
 	}
 
@@ -2807,6 +2808,15 @@ static inline bool check_file_record(con
 		return false;
 	}
 
+	/*
+	 * The do_action() handlers compute memmove lengths as
+	 * "rec->used - <offset of validated attr>", which underflows when
+	 * rec->used is smaller than the attribute walk reached.  At this
+	 * point attr is the ATTR_END marker; rec->used must cover it.
+	 */
+	if (used < PtrOffset(rec, attr) + sizeof(attr->type))
+		return false;
+
 	return true;
 }
 


