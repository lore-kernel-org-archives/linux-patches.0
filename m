Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F211151617E;
	Wed, 30 Sep 2026 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784618; cv=none; b=krIxlzrVV0waZui3HafleAGOjg+r8xOjWzr/4ejoDVLAJHDceci1vwpJqc+8RD7RpNUyUeOvFUSCBMhTE7SBJjFH0IKr26KvbZ603FBRv2XC2zY42cUevUncYwyBA8JLeQUE5DSUIRhRo0ImDYhVg36WErxQ/meg8am8zCxDsXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784618; c=relaxed/simple;
	bh=ysVrjgGoFfD2rmxNdyRuq0+2k9pUGPOQe+EvRmwDFU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlZiPaf+wFrfhgLdLK3+KTflTA8y5et0tw9W9HM6fyLXdw6EhDm3HD5mfqo+WXyOvtU+dNIMrJzhZdeu0VFM56VpiP1Qx8TvA6mI39VPaRtNeSMb3G9Z0oFxBQxPZCasJ88gG/sSHUo9JkTSNYTY8H/f1LMlZ2teOVQBvGEsuDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/p+yFLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/p+yFLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF801F000FF;
	Wed, 30 Sep 2026 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784615;
	bh=BoVkoNIdBggLS556AxTW7awSZbCU3Pc0q85QvLvWEuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/p+yFLOHwiQKfE6s2O1TrakFcKZVksn0ReO+kE/R0thOJc4PZIAMdxUHy2CeaZRN
	 G5v2YNfWaRsarh8Fx9Hkst4MM8JTNU178nCACfbmMKl6SY/iugXoOPqleVf0jZAiTk
	 cKFcv7mcwGYgkOsXLhfPigSEE3gCBb4swlen4+go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/982] ksmbd: treat unnamed DATA stream as base file
Date: Wed, 30 Sep 2026 17:15:55 +0200
Message-ID: <20260930152421.508394263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e8afaa686e3a..11314f7c622a6 100644
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



