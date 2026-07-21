Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FE83E49F0;
	Tue, 21 Jul 2026 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654424; cv=none; b=TVpLZ6OarhJqGB6RcO7C5dtYqVmneYAyhRrmrTO7w6yxkPBXpum08s2Kanb8tuReKzz0st5/WGgprNfh/2i2tq32ndrSL3r2dctBaN+onG8sY3iQiiTclHcaByakqFfxpy6tEQHUukkg5QZIzejw8GV3misy1yH+Us4b+0Et83c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654424; c=relaxed/simple;
	bh=O+rt1CIQnOHWA94kdPFcefJI3N1J4oloQ1GGHlO7vRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp0OM8/KalJTEA3D+i8Wm4QkURvin0tMEQ1WFcHrDxofMfRxYFhzWyM5XMxs6LBu3BU59rsTacpuqpwnyjuIa1/ovrK5YfCkmE4QEvDScygWXL9GMDX6U5vPIHhh4coW/cuZwFRFdJeqiS7/OO89TTcM7T2SWJEBFtZe2GF8wk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZzWJyIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZzWJyIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041EE1F000E9;
	Tue, 21 Jul 2026 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654423;
	bh=cwH63xQr+Aae6HaCixdndE5iveouOMRuLydvj4Xmsk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZzWJyIeHhVnzy1cfXzlxi+SI9ZRl3mKYH8xv1B1+AXfUkKxnPhlDdp0xp1W3QUks
	 41aOMRm9XxmrxsOxaJa6SBlNDq/qkkdqNaw0mURcdDk6zszNC7F4+HQagB8y+sY7lW
	 /2oaiSyAf6/xN1lNHHJtnFXd4B168w/73cUogL2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1698/2077] ntfs: validate resident volume name values on lookup
Date: Tue, 21 Jul 2026 17:22:51 +0200
Message-ID: <20260721152632.810197287@linuxfoundation.org>
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

commit b3f6cd1d54aa279cc4f47aa27939ebe517a2c390 upstream.

The shared lookup-time attribute validator now has a safe caller path for
$VOLUME_NAME corruption: ntfs_write_volume_label() no longer treats
lookup errors as an absent label, and the mount path reinitializes its
search context before continuing to $VOLUME_INFORMATION.

Add $VOLUME_NAME-specific resident value validation. A volume name is
stored as a UTF-16LE string, so reject odd byte lengths, and reject
values longer than the NTFS volume label limit. Empty labels remain
valid.

Also reject non-resident $VOLUME_NAME records. $VOLUME_NAME is required
to be resident, like $FILE_NAME; a crafted non-resident record would
otherwise pass lookup and ntfs_write_volume_label() would remove it as if
it were a normal resident attribute.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -607,6 +607,14 @@ static bool ntfs_file_name_attr_value_is
 			value_length - offsetof(struct file_name_attr, file_name);
 }
 
+static bool ntfs_volume_name_attr_value_is_valid(const u32 value_length)
+{
+	if (value_length & 1)
+		return false;
+
+	return value_length <= NTFS_MAX_LABEL_LEN * sizeof(__le16);
+}
+
 struct ntfs_resident_attr_value {
 	const u8 *data;
 	u32 len;
@@ -657,7 +665,7 @@ static bool ntfs_attr_value_is_valid(str
 	u32 min_len;
 
 	if (a->non_resident) {
-		if (a->type == AT_FILE_NAME)
+		if (a->type == AT_FILE_NAME || a->type == AT_VOLUME_NAME)
 			goto corrupt;
 		if (!ntfs_non_resident_attr_value_is_valid(a))
 			goto corrupt;
@@ -676,6 +684,10 @@ static bool ntfs_attr_value_is_valid(str
 		if (!ntfs_file_name_attr_value_is_valid(value.data, value.len))
 			goto corrupt;
 		break;
+	case AT_VOLUME_NAME:
+		if (!ntfs_volume_name_attr_value_is_valid(value.len))
+			goto corrupt;
+		break;
 	}
 	return true;
 


