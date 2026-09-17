Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239CB519E0D;
	Thu, 17 Sep 2026 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664697; cv=none; b=dLp+URT2iukclnKAUocM2FfNa6pm73C2KKvEIova+Ad9fhNpIRcEgejQ5SUzb9FhWVujdFiDAvUKimuLmjTZhtOTNuai3OUF0im7XJ0y7kbXPig2LluJlWguxWy5XYKylJidBMrirqIKsaQcoxkVQ7Azycx9rOYCkOEWabTnpGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664697; c=relaxed/simple;
	bh=mPt1iBrGw6r88TuHE4RU7BppPI9dwsz2zGSkKgl6qJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5ZZREHJglzGhQOb9U0yyKiwecoDKQf75leup8IVg7yZ6lyzCttzwvF0rvegMDokizlqsHNCwyTvLH5EyGoV6aB/lmPbuqnO3F3IXdcSVOIuKoIRTVPNcmsqaiMLuchrwiYDzp62FqeMboPVYovr1kfqkIcHRqUHG0VOhREjYYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFrxier4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFrxier4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772271F000FF;
	Thu, 17 Sep 2026 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664696;
	bh=fM1bQow8LlwLyX4EtsyxNpXmaJuGplJ+0WPbNCDe6f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFrxier4xm/xd60+J3cRfdBjRU23+7MXkcqRLNUwm7qH2R2xIyrbU71BtX+ygJinp
	 D9j6Qfr4xMs/LtHoiCQEW6z3ubskRfSRznWDCPsm2Qds0AEWB+aJbUke+VYUxeb30W
	 Bc0VzpoohEESSaUAo5ebUAhT3YoZZvQZaUboePA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0458/1250] ksmbd: treat unnamed DATA stream as base file
Date: Thu, 17 Sep 2026 16:04:13 +0100
Message-ID: <20260917151604.398032442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



