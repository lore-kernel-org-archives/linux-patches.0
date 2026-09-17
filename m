Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222184E5327;
	Thu, 17 Sep 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667695; cv=none; b=VRMFCTVwZ63ZHvog4xgEIlw4XCiBnljl++NdBnCp8JvvZPw/HA4ZmUHIdMn1BKhjl9WNJ8gjAJbxXqJitR+WdUsSWNmHEvD0nV67fy5XOTqh+najIy6B87HKydoNxUvBCQFK2VmLBqfju3D3vhXquyLSGD3NdMJz/8OSQpEftS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667695; c=relaxed/simple;
	bh=2tazKB1EyevIoctPCEFA2kKCsqu2ce6YiEujMNL8XVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGcoWH+Dd7m/rIUh7fQbtQaQIx0yfQAQ+Lf+KQpZD1JMckC9yZILhfhpTcb06FbdA69MB+OvxoMOOYEi2/nJXu9XejrJZNenyxHcZCtzrjuHzW2F2iweHIG3v7RC33+utLQo/qFpFG9RZp9c8uX9iqhaFi1FDVjFFnddCHl+ODg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZNFQFPe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZNFQFPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757551F000FF;
	Thu, 17 Sep 2026 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667694;
	bh=B74eQG3j4pdIg3ILmPezhIPuILUYW9Vz0KCFEECOL2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZNFQFPeWSB/Rpm+FXygaZMNBlyYvTdrLoHX4GBxc+s4TkSSElYolz/h5P9vYPfYq
	 Q8S4JipjL6ioU0d2cgDipahQpZiNn2AJpgeaYlIBSqtb0hW5KCbv7zRebFHrzZvmGh
	 eftuo2CvyBVf1bjQTM+dl70D4YTJmHNUWz149/l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0179/1102] scripts: modpost: detect and report truncated buf_printf() output
Date: Thu, 17 Sep 2026 16:02:02 +0100
Message-ID: <20260917151544.055051764@linuxfoundation.org>
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
index f17350bf3ddb4..86f80b55278f6 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1665,8 +1665,17 @@ void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 
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



