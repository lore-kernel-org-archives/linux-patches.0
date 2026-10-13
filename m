Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147EF4D7D30;
	Tue, 13 Oct 2026 11:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892430; cv=none; b=j6LUqC0GXwtTKsJSrsnzJer56uPKUk2NuRA+7O/GnGNUPVQpKRlEq6OSXUxKqmDqNwPqfwbjbQiKs0zDJQCQkgagcJs4sVKkQ5a8NvIjhZ04OukU67wj1xi57arXF9xIRsmgfp0twXjF5t2f4XuOxE6UHYtFcwZSfChXMHQ1W4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892430; c=relaxed/simple;
	bh=w0y4YHr/GNMT5RUDKSlyzwLGbJxvl/gplC33NL7/M3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRFH44CmzVrjUYrBaBEpOXGF82SZXUikw6IyR2wFHEIf5den5q4RAQreOpRJ8jv1XFkVepji97X+YgQOz9cfWzteA0o27V0+J0YjcFWRvgU00auRzeD3q/T/04b6dt3Puf2MhR6loRLfFlmC3T1Be0lD+e9jjfSTTcMD3gPtgSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB0jrz7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB0jrz7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2371F000FF;
	Tue, 13 Oct 2026 11:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892428;
	bh=OY/u1dxeHiQ304FFAcp8EgCo1RUkKqNMQEUEstk7sg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB0jrz7TOnssmG4gAmsA6ARW0Enu23o6h8gfHEwQrBXjr78tUetlAbPPKrGR/iiPC
	 zz5+8J8ZeFLK1E1ilbfGr06fuYt+2bd8weZmr5ER8g17vfN/WtZ2DC8fW1ip1wTS07
	 3lAsWjD2wPFsP3v+3jWjTTo6qJ67ZXNG1G+vmFMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 168/281] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Tue, 13 Oct 2026 13:38:04 +0200
Message-ID: <20261013112859.243767598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


