Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AF744AB91;
	Tue, 21 Jul 2026 22:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674140; cv=none; b=ZybM7fmvC9uCNKrlp+975xs7i5CFIrqU6oo2EZxwiIfC8CN011VtuHzOqE3k6QGbV/4x2PJTYRVY7TLgWIjndGQ9uxceNIKVyd0E5IgfCrPsuqotzxhD3azd4cTkluRXlk4Gt/O/ix28/ls0guebGgwzLTVHSEZ5WZTaJFb9pLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674140; c=relaxed/simple;
	bh=mTsSGsxf7CMQ6K9rqXKnqrrV1O5B+pyS60EE2Cy6lB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9+tWu9r2kDWgK4JUgNO1e5nzJQc5gdvvD11zmbc78DSV8H0EVsT4PWcIhgnq1LpuAFyAMq8FjfFa3RKYN6FvhVo3Px1QUAs01UjlagMVn440wk9nQFVtNCCz+8RK6wCxWgkUZdsc+o+dLbnFpA+UAzVl+ehHYrzI4k8dkGgTLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UM7wCe7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UM7wCe7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8498D1F000E9;
	Tue, 21 Jul 2026 22:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674139;
	bh=dvFX/x+FZ0fHsdEFMVEFOC8SgjGYcFtFbUU6oLMWizc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UM7wCe7FD2nJ1U19IFb7qLkUFTerKowdZ3Uu83aJDukjuMaDC0Fetx38VEuelp522
	 ZyR2sizRApQaFDAd0UT7NVq55O6Gcb0s4IZyVE4caWOY8I7EsuSHJGvVQmiqGWo9Ag
	 N+oFJ7wVD23PR10sfurDe1cBHavwcHZQjmQDj/tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/699] smb: client: fix overflow in passthrough ioctl bounds check
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152405.346336589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a4f27ad055392fa164f5649e89a3637b033c5fcc ]

smb2_ioctl_query_info() validates the PASSTHRU_FSCTL response payload
before copying it to userspace.

The payload offset and length both come from 32-bit fields. The bounds
check currently adds OutputOffset and qi.input_buffer_length directly, so
the addition can wrap in 32-bit arithmetic before the result is compared
against the response buffer length.

A malicious server can use a large OutputOffset and a small OutputCount
to make the wrapped sum pass the bounds check. The later copy_to_user()
then reads from io_rsp + OutputOffset, outside the response buffer.

Use size_add() for the offset plus length check so overflow is treated as
out of bounds.

Fixes: 2b1116bbe898 ("CIFS: Use common error handling code in smb2_ioctl_query_info()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 032799e25d9f03..8f320a9d59f665 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1698,8 +1698,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (le32_to_cpu(io_rsp->OutputCount) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(io_rsp->OutputCount);
 		if (qi.input_buffer_length > 0 &&
-		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
-		    > rsp_iov[1].iov_len) {
+		     size_add(le32_to_cpu(io_rsp->OutputOffset),
+			     qi.input_buffer_length) > rsp_iov[1].iov_len) {
 			rc = -EFAULT;
 			goto out;
 		}
-- 
2.53.0



