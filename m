Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF6E1D545;
	Thu, 23 May 2024 13:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470616; cv=none; b=hzKlyu3Yc5XjxAB2UzZkkYYInL7GCs7RdhVjHcf8BG2qjRZ7BQ7xXWwh7K3iSeZfN1rGbXNVwqOg8g7i7jPNSr7QsPzCwDhMjDuKy3y07ZK48sj/7/K8osXunVCm16zkAbkJRPYT9aOs8sANaa8WBBD0uZjV3Wgzer7rK1CY6i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470616; c=relaxed/simple;
	bh=NzyXBCzCXj3pqupkcINz7Be+waefbZPZOZR6IJs0jlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI6HyQC8lFUcZWplJazKoOIrcUSUkIfLxJv4B3TqdUgOfVohw7uza63X5cA+hsZZ1Dz4ItI2UPaDrnx3mTYO/S3nBiltEqNc1lpsyfgix2ciX7Nl9uFMrsUwOsgNCzwK5O1iXEpIJ56gKk1zLOgOka3JJQjyouBseQHU7QTMxcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNICacX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNICacX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F41C3277B;
	Thu, 23 May 2024 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470616;
	bh=NzyXBCzCXj3pqupkcINz7Be+waefbZPZOZR6IJs0jlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNICacX0V9M0mbLUzIeS5+L0YgPY7iMG6l7cFGeLpANBe/ooNkFcXcjFdigSvjJVd
	 +Q3Xl+gbzLj2H1hsvkYc85f1jWHEjRV9MqL0n+fcvrNmBjVkBp3BeThkSd4xUUVlvU
	 wPRPiYGODrVqx7/o4oMOep9GM7aHSIAzuJ+Yx5vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/102] cifs: new nt status codes from MS-SMB2
Date: Thu, 23 May 2024 15:12:54 +0200
Message-ID: <20240523130343.561342407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 7f738527a7a03021c7e1b02e188f446845f05eb6 ]

MS-SMB2 spec has introduced two new status codes,
STATUS_SERVER_UNAVAILABLE and STATUS_FILE_NOT_AVAILABLE
which are to be treated as retryable errors.

This change adds these to the available mappings and
maps them to Linux errno EAGAIN.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2maperror.c | 2 ++
 fs/smb/client/smb2status.h   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 1a90dd78b238f..ac1895358908a 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -1210,6 +1210,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_INVALID_TASK_INDEX, -EIO, "STATUS_INVALID_TASK_INDEX"},
 	{STATUS_THREAD_ALREADY_IN_TASK, -EIO, "STATUS_THREAD_ALREADY_IN_TASK"},
 	{STATUS_CALLBACK_BYPASS, -EIO, "STATUS_CALLBACK_BYPASS"},
+	{STATUS_SERVER_UNAVAILABLE, -EAGAIN, "STATUS_SERVER_UNAVAILABLE"},
+	{STATUS_FILE_NOT_AVAILABLE, -EAGAIN, "STATUS_FILE_NOT_AVAILABLE"},
 	{STATUS_PORT_CLOSED, -EIO, "STATUS_PORT_CLOSED"},
 	{STATUS_MESSAGE_LOST, -EIO, "STATUS_MESSAGE_LOST"},
 	{STATUS_INVALID_MESSAGE, -EIO, "STATUS_INVALID_MESSAGE"},
diff --git a/fs/smb/client/smb2status.h b/fs/smb/client/smb2status.h
index a9e958166fc53..9c6d79b0bd497 100644
--- a/fs/smb/client/smb2status.h
+++ b/fs/smb/client/smb2status.h
@@ -982,6 +982,8 @@ struct ntstatus {
 #define STATUS_INVALID_TASK_INDEX cpu_to_le32(0xC0000501)
 #define STATUS_THREAD_ALREADY_IN_TASK cpu_to_le32(0xC0000502)
 #define STATUS_CALLBACK_BYPASS cpu_to_le32(0xC0000503)
+#define STATUS_SERVER_UNAVAILABLE cpu_to_le32(0xC0000466)
+#define STATUS_FILE_NOT_AVAILABLE cpu_to_le32(0xC0000467)
 #define STATUS_PORT_CLOSED cpu_to_le32(0xC0000700)
 #define STATUS_MESSAGE_LOST cpu_to_le32(0xC0000701)
 #define STATUS_INVALID_MESSAGE cpu_to_le32(0xC0000702)
-- 
2.43.0



