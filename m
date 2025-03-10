Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537651C3F34;
	Mon, 10 Mar 2025 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630865; cv=none; b=OkcJ4QQmtu6s885LQ38pJN7BkKHJw3R1Unkrc1Q8/rhzgUgmvpPU3xS8blj6IB9vwm6tAGYzUs0zS5nbyogGZX314PBF8i6hKpc/kq1V9PLZMYvOVhZUelrF5oXChSpRw6o6Y4YNMIlM0hxgIEWJTBnrhH8DijeHx5AxzyGvJXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630865; c=relaxed/simple;
	bh=Y0FAHoOQB3FRI4waLBQnvS1E2Tirwe/DtPn5r7zDkek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHhZ077x3sWcfiaalXm872yAMszukWK5BPgK+rbDyhtMShtb5Dbl403vGR8HPdS65PI6EqkJuSNHLw4BSfAGFy/BZ/EMmBXBI/mQSdAvAsXZNE0SbJRadoF5SySdIP2QNVkbhAMjd+NPp9ibGNJXrMMBpkhXOLP9JcEuWR/N768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbWwTqjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbWwTqjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB588C4CEE5;
	Mon, 10 Mar 2025 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630865;
	bh=Y0FAHoOQB3FRI4waLBQnvS1E2Tirwe/DtPn5r7zDkek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbWwTqjEtUSjtbT0tvlwSg1jwSFNrDBeWrTXF8uIlh3454bTW+8OHkJzAFL9iPL1Y
	 J2PdTLJEgzsobd108MbsCYIvJPwvHD4VV3pP6wUYdxdfzM0GrkQZOUhd+1Cz6/UpAx
	 WyrCwwbWWc5F4vjfLn7mLvPw23sPNPXy4zzWYLUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 530/620] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Mon, 10 Mar 2025 18:06:16 +0100
Message-ID: <20250310170606.465730900@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 860ca5e50f73c2a1cef7eefc9d39d04e275417f7 ]

Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
in receive_encrypted_standard() to prevent null pointer dereference.

Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ee9a1e6550e3c..7bce1ab86c4da 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5198,6 +5198,10 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 
-- 
2.39.5



