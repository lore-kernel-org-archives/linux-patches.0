Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A13547061;
	Thu, 17 Sep 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668227; cv=none; b=j2j3xCRkaZwLwgi6r87MBMqM3XLskdT4+QzY1CRGIGVk0PCLkV2hNpv2N9FQjaRebBaiLURpdl0yElQJtyX+ydxtI5Abq3OsJL6iLon52eGA3OY0D+hZWaEihu2AqXlwLzE9G6OBqjEdy/KDyZZztj4gKGLKvRdVqMiYGP1vRdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668227; c=relaxed/simple;
	bh=Xf9bAkEkvA3DZMZCD+zbfga/yRiL8Up0P22TZFG2E+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ+CPSrN2A0Q50CVsXnf1WkNGK9o7ecmXT5ad+jrH0LCqtqRrruIoWCdFLVifEEoA9rOluMKPVGmHfIcfagY6iVJxJQPokp9RObq26Zw6NtzOAyVDTULcb3NHgdRTG8we3vY3HlY5dSrudRTnUKG7HnxqPDJW+ZlHOZQ3BRrkRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q83ueqA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q83ueqA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E60D1F000FF;
	Thu, 17 Sep 2026 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668225;
	bh=Uu22Wh6nWSQpE23/kOUao8WkBMLJ1WOhGJbHXiX+8v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q83ueqA1Ju7XkFssQVUyMDYeE00WhzY+U6TrcHYsutWrQcLqq7Z0bSUuA9k1TVt8w
	 vyYnBxotvyce7s4g/vNq1GQ5kO6ZsqRcg3wqqoEk1/FmVpnnt57AlWO5dhnTsDoODa
	 HawxEJ+Od2Jy7NgUx3cB0QNZDwe8yEppyfkU+BO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0354/1102] ksmbd: treat unnamed DATA stream as base file
Date: Thu, 17 Sep 2026 16:04:57 +0100
Message-ID: <20260917151548.534188386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 171b5d72dd80f99271c073c6e38d5263687c3b6d ]

The SMB path suffix :: names the unnamed data stream of the base
file, not an alternate data stream backed by a DosStream xattr.

Canonicalize an empty stream name with an explicit  type to a NULL
stream name after parsing. This keeps the base filename produced by
strsep() and lets open continue through the normal base-file path instead
of looking for a non-existent empty stream xattr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/misc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 53ddcae31f719..d6abe574fc89b 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -121,7 +121,9 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
 	char *stream_type;
 	char *s_name;
 	int rc = 0;
+	bool has_stream_type = false;
 
+	*stream_name = NULL;
 	s_name = filename;
 	filename = strsep(&s_name, ":");
 	ksmbd_debug(SMB, "filename : %s, streams : %s\n", filename, s_name);
@@ -137,14 +139,20 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
 
 		ksmbd_debug(SMB, "stream name : %s, stream type : %s\n", s_name,
 			    stream_type);
-		if (!strncasecmp("$data", stream_type, 5))
+		if (!strncasecmp("$data", stream_type, 5)) {
 			*s_type = DATA_STREAM;
-		else if (!strncasecmp("$index_allocation", stream_type, 17))
+			has_stream_type = true;
+		} else if (!strncasecmp("$index_allocation", stream_type, 17)) {
 			*s_type = DIR_STREAM;
-		else
+			has_stream_type = true;
+		} else {
 			rc = -ENOENT;
+		}
 	}
 
+	if (has_stream_type && !s_name[0] && *s_type == DATA_STREAM)
+		goto out;
+
 	*stream_name = s_name;
 out:
 	return rc;
-- 
2.53.0



