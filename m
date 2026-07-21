Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EED62E736D;
	Tue, 21 Jul 2026 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654430; cv=none; b=hii5KXI/sdpPMwmnOtM7SM/kBm1lAFS/QiAC7QSyUYwK5baqMRmzeRzdxDa09Zqyx3PMnq78lCoOchSFLnD3wBYAasNMOZW+KOLn4SFWXfq5BubZRVitXbce5mHUwYv3+MII8kXSJSwfBktTeykVcX7hxim+yR8jsphotvhQtKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654430; c=relaxed/simple;
	bh=OMLYkfkwzyRF5F1D3HSP9oPTus5w98vRrE2sZwJiYGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPFE6y4LqOag7hJ7xPRYXIPFzcO558/pSsj/6L+/Iejfbn1xWtnB3ND42kiVhcjK1p2kxGqfQHA+yoie8hhEQoi+EW3G5IBQOFiTM16IhxS68SBFeLd2z3DKKcRY8sLJ5Qc1nCFmlGPBQrF+KHk8LKw4CK4SXIT2Rp74ltwjmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCWztSwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCWztSwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D87E1F000E9;
	Tue, 21 Jul 2026 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654428;
	bh=4+TSTdt/yyBXA3vd++9fRjkByQenmRBJsKY5DlM0fJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCWztSwynxOsCTMF1f4SIgHfEKwdZIWNcd4I1R2CZDlXfFX985rJ0bMA0ELgY4aN1
	 3t6lKZn4k0mfpufFSopr9V/sAYg5/y9YMM9Mgm33NZhUIH1EJgtwkaZ/GPRuqwW8Na
	 bIOVnBvS6PPSFj9FTRhvO1EmoxdLFmfjjgocIXek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1699/2077] ntfs: validate resident index root values on lookup
Date: Tue, 21 Jul 2026 17:22:52 +0200
Message-ID: <20260721152632.833568002@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit fcf5bf0e8570798970e3ae8c95d04765ba2c5b97 upstream.

Resident $INDEX_ROOT values carry index header fields that callers
consume after lookup. Some callers already validate parts of the layout
before walking entries, but those checks are scattered and do not cover
all root header invariants, such as entries_offset alignment and lower
bound, index_length, and allocated_size consistency.

The resident root resize paths now keep these header fields consistent
while the value size changes: ntfs_ir_truncate() lowers
index.allocated_size before shrinking the resident value, and
ntfs_ir_reparent() grows the resident value before publishing a larger
root header. Lookup-time validation can therefore cover these invariants
without tripping over the driver's own resize paths.

Add $INDEX_ROOT to the minimum resident value size table and validate the
resident index header fields before returning the attribute from lookup.
Require 8-byte aligned index header fields, a sane entries_offset, an
index_length within allocated_size, allocated_size within the resident
value, and enough entry space for at least an index entry header.

The shared validator already rejects non-resident records for
resident-only attribute types, including $INDEX_ROOT.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -588,6 +588,8 @@ static u32 ntfs_resident_attr_min_value_
 			sizeof(__le16) * 1;
 	case AT_VOLUME_INFORMATION:
 		return sizeof(struct volume_information);
+	case AT_INDEX_ROOT:
+		return sizeof(struct index_root);
 	case AT_EA_INFORMATION:
 		return sizeof(struct ea_information);
 	default:
@@ -615,6 +617,31 @@ static bool ntfs_volume_name_attr_value_
 	return value_length <= NTFS_MAX_LABEL_LEN * sizeof(__le16);
 }
 
+static bool ntfs_index_root_attr_value_is_valid(const u8 *value, const u32 value_length)
+{
+	const struct index_root *ir;
+	u32 index_size;
+	u32 entries_offset;
+	u32 index_length;
+	u32 allocated_size;
+
+	ir = (const struct index_root *)value;
+	index_size = value_length - offsetof(struct index_root, index);
+	entries_offset = le32_to_cpu(ir->index.entries_offset);
+	index_length = le32_to_cpu(ir->index.index_length);
+	allocated_size = le32_to_cpu(ir->index.allocated_size);
+
+	if ((entries_offset | index_length | allocated_size) & 7 ||
+	    entries_offset < sizeof(struct index_header) ||
+	    entries_offset > index_length ||
+	    index_length > allocated_size ||
+	    allocated_size > index_size ||
+	    index_length - entries_offset < sizeof(struct index_entry_header))
+		return false;
+
+	return true;
+}
+
 struct ntfs_resident_attr_value {
 	const u8 *data;
 	u32 len;
@@ -688,6 +715,10 @@ static bool ntfs_attr_value_is_valid(str
 		if (!ntfs_volume_name_attr_value_is_valid(value.len))
 			goto corrupt;
 		break;
+	case AT_INDEX_ROOT:
+		if (!ntfs_index_root_attr_value_is_valid(value.data, value.len))
+			goto corrupt;
+		break;
 	}
 	return true;
 


