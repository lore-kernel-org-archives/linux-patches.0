Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5620E248BA6;
	Wed, 15 Jan 2025 10:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938069; cv=none; b=WLbhmij0YWlVGN/xawzFShUopgI2SSjNNATyPqrfmBtEyrjNlziORJNopNq2C0TKYnRxBCg66lYMETT/sIr+Ct43DGvf8R6h2QhWxCtcXhMWZ8rYQN2J1PQqrlFpbA50yPe//ePsCvbTu6tHeUpJuoT7/zEEJKk8qcDxSQWm/ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938069; c=relaxed/simple;
	bh=IF4EzfBFcJm67+40fO05bdSnKBZEusMzyw3aWLiKF6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd35GdoVA5l8IWrK10SyztlJYso8G33zMfYR5LFDjcyfeVJKd9Mb1h6OALjxhytr1saoqOPKY4wd5kVRX8pnbw/jFhV8hSMLrcaW3jKeFDpJFJJMSIIox4g/yvvPmNMqhAxj0kZINz0oeR0+nwew+O/EkCJBVvs2YLpfNP6djDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWMaQ1+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWMaQ1+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92EFC4CEE1;
	Wed, 15 Jan 2025 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938069;
	bh=IF4EzfBFcJm67+40fO05bdSnKBZEusMzyw3aWLiKF6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWMaQ1+S0hXdCxfkFz4BFR6oz1INHIgUjbbhnFPe5cmI8H6DDwEN65rEGJvE++Rcd
	 IpJztjV3KVzYymiDLWSn6gY2ZGo78W4gc0n6H7GtpSTCq+sa1JMKZhqxoHRD2bdCvU
	 8vThEQ+xko3DuD8GMinJfaUiVakuNlpDf08CrqJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Wang <xw897002528@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/189] ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked
Date: Wed, 15 Jan 2025 11:36:10 +0100
Message-ID: <20250115103609.306167411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: He Wang <xw897002528@gmail.com>

[ Upstream commit 2ac538e40278a2c0c051cca81bcaafc547d61372 ]

When `ksmbd_vfs_kern_path_locked` met an error and it is not the last
entry, it will exit without restoring changed path buffer. But later this
buffer may be used as the filename for creation.

Fixes: c5a709f08d40 ("ksmbd: handle caseless file creation")
Signed-off-by: He Wang <xw897002528@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7cbd580120d1..ee825971abd9 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1264,6 +1264,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 					      filepath,
 					      flags,
 					      path);
+			if (!is_last)
+				next[0] = '/';
 			if (err)
 				goto out2;
 			else if (is_last)
@@ -1271,7 +1273,6 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			path_put(parent_path);
 			*parent_path = *path;
 
-			next[0] = '/';
 			remain_len -= filename_len + 1;
 		}
 
-- 
2.39.5



