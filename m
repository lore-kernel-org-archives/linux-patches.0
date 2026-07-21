Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C97F2BEFF5;
	Tue, 21 Jul 2026 20:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667219; cv=none; b=Oxuy1B1KDuy96BIudx2374wcEbdwesoNuMVZE237UXmZLxQ2JdpEsuLJwlntPaQcbf767ViUUIVnE/Atm8f+XlG0FwUXL63eTDBEuKCjT339RCgasZmTwr/eex2JMnd+g0g4Nqw3m9sNiWbgiITp6ijTgBPTc2+SG5izdSRTXCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667219; c=relaxed/simple;
	bh=RJeI0s4J3rI0LZHaGbD2lh98fT8wr43fm5dgRRs97Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGV/v0jWJV+z3EU33SXDpQK4SaJvuI92JuJdwrXjEn7CWljOLrbNqxMDf7Jo634FkHkQs2IAuaOmfHipb5HKd7oD45Es0pv2mOuQXeTvTWz/VJlRVg8twGfx8l8t9TMFM3rMtzzrZ6QDLNcn4K9bCAL2N11/2JsBbogI67fZ4iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glT/u+k9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glT/u+k9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D5E1F000E9;
	Tue, 21 Jul 2026 20:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667218;
	bh=GidKEDHSumfhOfuY+qQGaag8O6aeVn2E/2S0ua3Hwvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glT/u+k9Vwnxh+XxwNRdyPVLU59moQjx64UkzTgzVbLFRunVYHO27dXUAeH65A06l
	 4TfFtk8S0mwtFFFn6oClLofYHg7njVh3qevjeYzhXfhD7dYABL7mKihL1bDg2FVhx5
	 2cj77Hg3Gk3boiIuk0Lk6bOSpSawwEOEmbUfmPmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0979/1266] fs/ntfs3: bound attr_off in UpdateResidentValue against data_off
Date: Tue, 21 Jul 2026 17:23:36 +0200
Message-ID: <20260721152503.749077861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit d1570c48f49a693974d000251030370ee2e83539 upstream.

In do_action()'s UpdateResidentValue case (fslog.c:3307),
lrh->attr_off and lrh->redo_len come from the on-disk LRH.
When they satisfy aoff + dlen < attr->res.data_off, the
assignment

	attr->res.data_size = cpu_to_le32(aoff + dlen - data_off);

underflows to ~4 GiB (e.g. 0xFFFFFFF9 when aoff=0x10, dlen=1,
data_off=0x18).  Subsequent code that reads attr->res.data_size
to walk the resident attribute payload would then read up to
4 GiB past the 1024-byte MFT record allocation.

The existing mi_enum_attr() defense in fs/ntfs3/record.c:287
catches the corrupted data_size on the next attribute walk
and fails the mount, but only on the path that walks all
attributes.  A read site that picks an attribute by name and
reads its data_size without re-validating is not covered.
Validate aoff against data_off and asize at the source.

Reproduced under UML+KASAN on mainline 8d90b09e6741 via
pr_warn-only probe: with aoff=0x10 and data_off=0x18, the
post-assignment data_size is 0xfffffff9 (mount then fails
at -22 from mi_enum_attr).

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
[almaz.alexandrovich@paragon-software.com: clang-formatted the changes]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3313,6 +3313,17 @@ skip_load_parent:
 		nsize = ALIGN(nsize, 8);
 		data_off = le16_to_cpu(attr->res.data_off);
 
+		/*
+		 * aoff comes from the on-disk lrh->attr_off.  Forbid
+		 * writes that begin below the resident attribute's
+		 * data_off (which would overwrite the resident header),
+		 * and forbid aoff + dlen < data_off, which would make
+		 * the data_size assignment below underflow to ~4 GiB.
+		 */
+		if (aoff < data_off || aoff + dlen < data_off ||
+		    aoff + dlen > asize)
+			goto dirty_vol;
+
 		if (nsize < asize) {
 			memmove(Add2Ptr(attr, aoff), data, dlen);
 			data = NULL; // To skip below memmove().


