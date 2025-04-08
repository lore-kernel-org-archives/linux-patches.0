Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D734D20330;
	Tue,  8 Apr 2025 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115495; cv=none; b=OuW1V+P/T6+Jzdigw4EQkSu5068cuPHnDJX8o1ucWhSuFGz/OXoFhx3HvO9WuJNOSbgBFK0lWC0HZc5riMKgzQMJsAJCqaVkNHvcD5+S7aedZ3AKg1n7Z3eeDH8l5zsJvK+MKJNMS2HnxhIl/i2oSQxQBJzUxcmUp5AZ2VVHQhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115495; c=relaxed/simple;
	bh=h8KHUdZoGkVWy1ND1d8TZArm+sp0/DwMJ6jsB55KVbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ8c5hbQUlo53/yh9Okchv19fN2d2ewHIA4HRmbhJPmWZlPK8lQae31rglg98UERXZxjCG9iG+Z/54T1WmH+j/AOenYmlbkA6FBpCq3XhwebkcGcZ1lnSpcu6YD/QXJ8FOuv+evcXCnkJWU532aR4C0DPCFIspdqW0uo65YIpN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5klccZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5klccZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66995C4CEE5;
	Tue,  8 Apr 2025 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115495;
	bh=h8KHUdZoGkVWy1ND1d8TZArm+sp0/DwMJ6jsB55KVbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5klccZhyH8Dpjzjsu5bkS98Wy/xlDnOvQ0hAIO95BiL7Tdj0NkCUXnvxEtTsANs+
	 UBTTuOHEKefFWzgtqVRrwdvzlhtl+uXrFfW20hDBOdq80cVFSO2C3FgxH6/y/lR79R
	 gF3UnV8VVn3j5d8LKRBmR5Dnqdh3tVyDrzSGDyJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 495/499] NFSD: nfsd_unlink() clobbers non-zero status returned from fh_fill_pre_attrs()
Date: Tue,  8 Apr 2025 12:51:47 +0200
Message-ID: <20250408104903.703747447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit d7d8e3169b56e7696559a2427c922c0d55debcec upstream.

If fh_fill_pre_attrs() returns a non-zero status, the error flow
takes it through out_unlock, which then overwrites the returned
status code with

	err = nfserrno(host_err);

Fixes: a332018a91c4 ("nfsd: handle failure to collect pre/post-op attrs more sanely")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2011,11 +2011,9 @@ out_nfserr:
 		 * error status.
 		 */
 		err = nfserr_file_open;
-	} else {
-		err = nfserrno(host_err);
 	}
 out:
-	return err;
+	return err != nfs_ok ? err : nfserrno(host_err);
 out_unlock:
 	inode_unlock(dirp);
 	goto out_drop_write;


