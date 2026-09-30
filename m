Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6E351DB0E;
	Wed, 30 Sep 2026 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790834; cv=none; b=SBL5YLqu8usQrC9XRznsWwPO3zJj5QQiaObvHUqcg2EtG3KKeSeOPO9y7w/Ch9vSKcqJt0n3gQamgNjkpBxKOPNMD1X/S7kcATBRU+D3tGO/Wr3UMeJoLokfD1zIrtf0r7uJc6+mYiMsFhWFEMl4sn7QkyhZz/94S/4Z0+lgGZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790834; c=relaxed/simple;
	bh=I6OnQWWc3st+y7EXRiOAtkhk0sriYnbmWjnlwypb4p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHgMiCJRKJKhcl0iu1YfDcGmyOjEMZSs0pO6C31ILJnUGfz4qOIkN6cPbe3qPdiocLZTrSRR83ihHuCrSyphAih4Q8XcFi9pPte9/xRz4OJ9BmXB4HS++dDoJQxZFrI4hCvXroCQAIKYZdcujJpqT7dtEAgLgG2RIwxfsc28Ny8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwkBNhVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwkBNhVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652E01F000FF;
	Wed, 30 Sep 2026 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790832;
	bh=RJzVFTXGFUryUaRc4MWieDu5wNVH7NiNWxJU+ZXDNb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwkBNhVgJInNatzXldGrRiLHEmNe78H778xAIZnKKDWs2/ZXruGsJx4lFGZbs4dTK
	 W0oresGI/GzL6OnuAp7cR46Tyx/PXfkQppqeIFl/R73kxXFQJXP7Lha8wf1aCE5wK7
	 17ZKH3fOUPhQOlA+sxZOODLgISuSFz3a9azzcGis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/752] scripts: modpost: detect and report truncated buf_printf() output
Date: Wed, 30 Sep 2026 17:19:21 +0200
Message-ID: <20260930152400.139338524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit d7231d8cb262b1e350c00271bf53d54414b4f3b1 ]

buf_printf() uses a fixed-size stack buffer. vsnprintf() returns the
number of bytes that *would* have been written to that buffer, which can
be larger than the size of said buffer if the formatted string is too
long.

The problem is that whenever this happens buf_printf() currently passes
this length, unchecked, to buf_write(), which silently reads past the
stack buffer and copies invalid data into the output buffer.

Fix this by detecting vsnprintf() failures and truncations before
appending to the output buffer, and report a fatal error instead of
producing corrupt symbol names.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260527-nova-exports-v2-1-06de4c556d55@nvidia.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2fa333fca1f7b..c846928c2a74e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2088,8 +2088,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
 	va_start(ap, fmt);
 	len = vsnprintf(tmp, SZ, fmt, ap);
-	buf_write(buf, tmp, len);
 	va_end(ap);
+
+	if (len < 0) {
+		perror("vsnprintf failed");
+		exit(1);
+	}
+	if (len >= SZ)
+		fatal("buf_printf output truncated for string %s: %d bytes needed, %d available\n",
+		      tmp, len + 1, SZ);
+
+	buf_write(buf, tmp, len);
 }
 
 void buf_write(struct buffer *buf, const char *s, int len)
-- 
2.53.0



