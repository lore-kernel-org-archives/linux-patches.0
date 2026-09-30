Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2047522EFC;
	Wed, 30 Sep 2026 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790390; cv=none; b=JU6R4aV753XGytIH4Gy6M+Lzl79/omHIo2rEzSwxPdHpT50FfDhdLQd4mLeESg7eHZ6Q0I+llj6nsrTke0NlY46Bx4pdB4WJYzwg+ifkjsV6dIKGzVASRlxcJrXIaXStI8JEkPnXduLUUv1ATOC6eVqYkZA2xSi5DMTszQkNZLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790390; c=relaxed/simple;
	bh=M/GUtpNNOiCY9u6Dmqu8eQ7NatUsIidTxeiyMAfcXy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcCUyDZ4oMBDv4J+iurcXm/NQBCa3TRPoO0RxHQlafE9HUQOI2rkTbJm1bqVZZDh6ql+85+TeCEXTQO1cF3LA+CJgum02MgW2C37ZkNr+muR+hUmMkm28Be13d9AUqyFwZk08yIQowG3Bxk1UyqZWuES1T5fT2Z3YSnRZguAlh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsT9gDNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsT9gDNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28D81F000FF;
	Wed, 30 Sep 2026 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790389;
	bh=fLkUhUmxf0bGgCtM2QfvJ4b2Br0pAGdowCa1t9xvIgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsT9gDNiU3fEEMEDq1RfjMOkpL0d+EpLOVNHyiVf3bDLu9k+MhmMVLn8A/8cF2W67
	 7DDAFDIyCGe/qNjFa80z9jhboG2xTfFxwAJloT8Hv0JMsw3XsY0cEwakE2pz0yCmd/
	 MAGvOxxmrHFwv3lD7Rwh2GqLpxfFpGIEEGLLV9sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 811/877] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Wed, 30 Sep 2026 17:28:42 +0200
Message-ID: <20260930152432.219955762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit eeb5ef6083e1cefa2ef75041b5597ff228b8d7bb ]

In move_smb2_ea_to_cifs(), the while (src_size > 0) loop condition is
insufficient. It allows iteration to continue even if the remaining
src_size is too small to contain a complete smb2_ea_info structure.
Consequently, reads of ea_name_length and ea_value_length can occur
out-of-bounds.

Fix this by ensuring src_size >= sizeof(*src) before attempting to read
any structure fields. Additionally, reject any next_entry_offset that is
smaller than sizeof(*src) or that would advance the pointer beyond the
available buffer.

Note that for calls where the server returns a malformed EA list, the
error returned to userspace changes from -ENODATA (getxattr) or
-ERANGE (listxattr) to -EIO. This correctly signals a server protocol
error rather than misleadingly indicating "attribute not present" or
"output buffer too small".

Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Replaced unavailable smb_EIO2() tracing calls with -EIO. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1057,8 +1057,9 @@ move_smb2_ea_to_cifs(char *dst, size_t d
 	char *name, *value;
 	size_t buf_size = dst_size;
 	size_t name_len, value_len, user_name_len;
+	u32 next_off;
 
-	while (src_size > 0) {
+	while (src_size >= sizeof(*src)) {
 		name_len = (size_t)src->ea_name_length;
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
@@ -1113,14 +1114,21 @@ move_smb2_ea_to_cifs(char *dst, size_t d
 		if (!src->next_entry_offset)
 			break;
 
-		if (src_size < le32_to_cpu(src->next_entry_offset)) {
-			/* stop before overrun buffer */
-			rc = -ERANGE;
-			break;
+		next_off = le32_to_cpu(src->next_entry_offset);
+		if (next_off < sizeof(*src) || src_size < next_off) {
+			cifs_dbg(FYI, "EA next_entry_offset %u out of range [%zu, %zu]\n",
+				 next_off, sizeof(*src), src_size);
+			rc = -EIO;
+			goto out;
+		}
+		src_size -= next_off;
+		src = (void *)((char *)src + next_off);
+		if (src_size > 0 && src_size < sizeof(*src)) {
+			cifs_dbg(FYI, "EA next_entry_offset %u left truncated entry (%zu bytes)\n",
+				 next_off, src_size);
+			rc = -EIO;
+			goto out;
 		}
-		src_size -= le32_to_cpu(src->next_entry_offset);
-		src = (void *)((char *)src +
-			       le32_to_cpu(src->next_entry_offset));
 	}
 
 	/* didn't find the named attribute */


