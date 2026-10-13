Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA9E4F93DB;
	Tue, 13 Oct 2026 12:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893199; cv=none; b=aqbewOu1rm5BBhtE15gXPwSSsOeQ2M9Hi8zWMxYvFup8e8upalPjyQt6b6lYaT8Xhn4222VJdp6YOZqfREMcSc83jvjLQTDlRcVipuMEn77nSeqynbrsyqMhC/lcMqHUuiQiBMy25hLrdOkZ1kJACUPP5y2MLz7ODNh4+Bb10Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893199; c=relaxed/simple;
	bh=1PS7TJ/+GEQ3z1+L6EEMmHpcRADRxMTlIk327INdAhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM+7kjPeuvF6TC2PxdauHJ2O6vw6ZlTFuuq/V/PRKZVNdfX7bO4b17mYmIRtk+AWSRPr4gCOYIwui0+KZEF5E94dq95hS+SKLqPDasY5ByGW3b55XEaTEjFLAyy1sZtFRzXqS01eVUhgcLVR56E9sakLPbfaTAmmsO9UlISbKa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hz+TF8AJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hz+TF8AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4121F000FF;
	Tue, 13 Oct 2026 12:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893198;
	bh=PKYFw+RYJQJAxSmAg58+iGCyHXIQYr+xElMPKqgJBA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hz+TF8AJm7KokNXDEp2e0flpnW81YoKgJZesMZ/6TE3oOUcB1yh49y/NWO5ns8QFx
	 lz4ITUxn2eUkgxcv5b6MCYYlwv72Yfcbodu1Yp+iUQxI77NfsAZ8Q8UvN0zLYIn+up
	 lRPpsEM30Grh8PwdH2ZcVfGcIaCdpvWTTfockuQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 145/621] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Tue, 13 Oct 2026 13:32:20 +0200
Message-ID: <20261013112924.295323645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit b0d1022b9bdb1e98aa7fb3244fdd50a58c61766c upstream.

An immutable inode is never written to so write hints are pointless.
Refuse the hint on an immutable inode the way setattr(), fallocate() and
etxattr() refuse their changes.

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-3-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fcntl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -372,6 +372,9 @@ static long fcntl_set_rw_hint(struct fil
 	u64 __user *argp = (u64 __user *)arg;
 	u64 hint;
 
+	/* nothing is ever written to it */
+	if (IS_IMMUTABLE(inode))
+		return -EPERM;
 	if (!inode_owner_or_capable(file_mnt_idmap(file), inode))
 		return -EPERM;
 


