Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708FD40096A;
	Tue, 21 Jul 2026 17:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654432; cv=none; b=UxOwbLD7FJp7V35qFT1SZ9kVZmwueqY1mXBEesO5kMksxoSHWdaUQKbKUoSmZVFOOXqPRybVnca6TNsCZ/dS+R+9S/S07Oj3bA/SfdCs8ldPurmexncek1piKexoUnn1QqKPczswQoWjp+B2P/zOovwnMNFhcu5BooDIJ3TC8oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654432; c=relaxed/simple;
	bh=2Vfj0TAKBnEjj8Wae9oiUdEfNzhhfqPTr3Z1V0EJ8Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/4Ig1jBhjYXzMh5VYnMEUWzofM4m55edKsJVYCpVmlVJu1ew5f/gmJE1OJbSilWQJqFhjyUnZZFMv1xeLyxDdGCtuis34RYBjUzzIapz8ZWPo2QhZAD02blrGme0sDvqJKkUTS0Unt0MxnmmArZFvrmWWSx2ZgtezQPnhPPFJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncux4R80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncux4R80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55081F000E9;
	Tue, 21 Jul 2026 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654431;
	bh=yZCu8ryIqKlCBC1wn1tyJ6tWoMIDLNO2h/aY1qaZTcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncux4R80HNY0BDe8Yubgx62bD5Yf7oVE2DlgO5s5R1sUuNDgg9kruLLPQoWEtOxW/
	 CUNf7I1i6eF0BBacnWLGXIYkVTxc1E8i5hp5oSNyDxgT+zjbi/GVFwtU3GbSxtClXi
	 FdJMF6B0FoC5JHPEl4idw+uECaX9HBxVn498ARpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1700/2077] ntfs: reject non-resident records for resident-only attributes
Date: Tue, 21 Jul 2026 17:22:53 +0200
Message-ID: <20260721152632.858556004@linuxfoundation.org>
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

commit 097cdfd0a55df5af82c9753833f39a8bfadbcfcb upstream.

The shared lookup-time attribute validator rejects non-resident
$FILE_NAME and $VOLUME_NAME records because their formats require
resident values and callers handle returned records as resident
attributes. Other resident-only attribute types still pass through the
generic non-resident mapping-pairs checks.

That leaves real resident/non-resident union confusion paths. Inode load
looks up $STANDARD_INFORMATION and then reads data.resident.value_offset
without checking a->non_resident. ntfs_inode_sync_standard_information()
does the same when updating the standard information value.
ntfs_write_volume_flags() also looks up $VOLUME_INFORMATION and reads
data.resident.value_offset directly. $INDEX_ROOT callers in dir.c and
index.c depend on the same lookup contract before consuming the resident
index root value.

Reject non-resident records for all resident-only attribute types in the
shared validator. Keep the existing $FILE_NAME and $VOLUME_NAME behavior,
but factor it through a helper and extend it to
$STANDARD_INFORMATION, $OBJECT_ID, $VOLUME_INFORMATION, $INDEX_ROOT, and
$EA_INFORMATION. For $OBJECT_ID and $EA_INFORMATION this is contract
hardening for resident-only formats; this patch only rejects the
non-resident form and does not add new resident value validation for
those types.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -597,6 +597,22 @@ static u32 ntfs_resident_attr_min_value_
 	}
 }
 
+static bool ntfs_attr_type_is_resident_only(const __le32 type)
+{
+	switch (type) {
+	case AT_STANDARD_INFORMATION:
+	case AT_FILE_NAME:
+	case AT_OBJECT_ID:
+	case AT_VOLUME_NAME:
+	case AT_VOLUME_INFORMATION:
+	case AT_INDEX_ROOT:
+	case AT_EA_INFORMATION:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool ntfs_file_name_attr_value_is_valid(const u8 *value, const u32 value_length)
 {
 	const struct file_name_attr *fn;
@@ -692,7 +708,7 @@ static bool ntfs_attr_value_is_valid(str
 	u32 min_len;
 
 	if (a->non_resident) {
-		if (a->type == AT_FILE_NAME || a->type == AT_VOLUME_NAME)
+		if (ntfs_attr_type_is_resident_only(a->type))
 			goto corrupt;
 		if (!ntfs_non_resident_attr_value_is_valid(a))
 			goto corrupt;


