Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E37813DB98;
	Tue, 27 Feb 2024 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040628; cv=none; b=B2qeOUnZXU1+SKM0RwTFKPCllrguENK1hP4NXpY6jSy9WRmw176igENWTcZJRoTTfmF0wOl7EAhmamwxigF67Y/FqMy3Ss4fWAPL4g2To5hdsy6ZmUFv2wrWu9VGtSDSOsUIjw/JhrUYdIEoLOrh2hd95Bi225+0P0locdSen8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040628; c=relaxed/simple;
	bh=0vKuDhg62J9JICXobiHdTUnLr5VOO9YJE/sPPWdot8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqS9Swi7pYZ/hkiKeMs0rBWXU3iH9F73BBSLEGYsCIqVAEY6YejEN24U7l6cBF6HHjixMUR4/AbiEifLqkVRvF/lZ0WlcOx2lQF9YsxUDfs0Rb7w6PJWsACCkP39/0h71Aji7v06UsH3zbs1ij1r7jj1EZm1jXq5jNVU7rEcRpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PivsmAO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PivsmAO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC0EC433F1;
	Tue, 27 Feb 2024 13:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040628;
	bh=0vKuDhg62J9JICXobiHdTUnLr5VOO9YJE/sPPWdot8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PivsmAO4CKi543kOQ/zcH4pfxlyM2Fft1knzk0S9EQy+819k7h3jtFEzZrrxzGNQF
	 YqFF+BQZFDjOveVkD+pqp6llVt0HKMIMRQ0nPN21m3LmtjnqPsqCNYp/5eXTZGRxEM
	 0Q4NMnmdg2lmyGrIli6JKZr2CvRLAql77f+SbqIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 025/334] cifs: helper function to check replayable error codes
Date: Tue, 27 Feb 2024 14:18:03 +0100
Message-ID: <20240227131631.414758280@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 64cc377b7628b81ffdbdb1c6bacfba895dcac3f8 ]

The code to check for replay is not just -EAGAIN. In some
cases, the send request or receive response may result in
network errors, which we're now mapping to -ECONNABORTED.

This change introduces a helper function which checks
if the error returned in one of the above two errors.
And all checks for replays will now use this helper.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 1 +
 fs/smb/client/cifsglob.h   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 9718926205047..5730c65ffb40d 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -367,6 +367,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		atomic_inc(&tcon->num_remote_opens);
 	}
 	kfree(utf16_path);
+
 	return rc;
 }
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 942e6ece56b1a..f794b16095e43 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1820,6 +1820,13 @@ static inline bool is_retryable_error(int error)
 	return false;
 }
 
+static inline bool is_replayable_error(int error)
+{
+	if (error == -EAGAIN || error == -ECONNABORTED)
+		return true;
+	return false;
+}
+
 
 /* cifs_get_writable_file() flags */
 #define FIND_WR_ANY         0
-- 
2.43.0



