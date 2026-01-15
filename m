Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6313A7F5D;
	Thu, 15 Jan 2026 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496816; cv=none; b=B23J+CSZFSzGZxC8vAzLLgs+WaVbkSONiUghPqFapPgN9B4QFZNY73Etx7rPM/2D5mciH5jdKb0P2yhMHORVehmh5myoHo5kDaJhLJV9/LzPIWGzfqxRBoirTqKHSCAcefpgxO0bwFSVCfcBgXfR92pZVfEwQcBbD3Xjy6rjnP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496816; c=relaxed/simple;
	bh=SAzb5bgw5iIIKeJHt4niMId2X3BVg+5YF9i8JoXjdLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoLSX6ztewK+UH6o///dK5c2ftWXqdI/yDLYXNUGhD3tHuu2r+ztIzag90KgwFMdwX8Yg8MdWh/i2TPNnWmTvslA74eR5icSGX+QkJXgOHMIEtAk/sYvIE77U6INdDQNGF0ztcC680qcuKaVyDUmGaxvIs/DKkJCa6+npyvFRoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsE5vv6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsE5vv6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4A9C116D0;
	Thu, 15 Jan 2026 17:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496816;
	bh=SAzb5bgw5iIIKeJHt4niMId2X3BVg+5YF9i8JoXjdLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsE5vv6CHeMUAQTaTOZVXgSGkeDutOX2YHb8EwZ8heDz6XKvT1rghYsn5+IG/dNvF
	 5eLbRAWQlDiHv/hs+4CmB5jeu2/GSvYucUiceDWV3Bqfrb5ni9unL8LTa+6EA5DTMC
	 QPcOUbEkDWYlYz5FRNOsMe1bdwFiw/fzAqqmY5BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 25/88] nfsd: set security label during create operations
Date: Thu, 15 Jan 2026 17:48:08 +0100
Message-ID: <20260115164147.224139173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 442d27ff09a218b61020ab56387dbc508ad6bfa6 upstream.

When security labeling is enabled, the client can pass a file security
label as part of a create operation for the new file, similar to mode
and other attributes. At present, the security label is received by nfsd
and passed down to nfsd_create_setattr(), but nfsd_setattr() is never
called and therefore the label is never set on the new file. This bug
may have been introduced on or around commit d6a97d3f589a ("NFSD:
add security label to struct nfsd_attrs"). Looking at nfsd_setattr()
I am uncertain as to whether the same issue presents for
file ACLs and therefore requires a similar fix for those.

An alternative approach would be to introduce a new LSM hook to set the
"create SID" of the current task prior to the actual file creation, which
would atomically label the new inode at creation time. This would be better
for SELinux and a similar approach has been used previously
(see security_dentry_create_files_as) but perhaps not usable by other LSMs.

Reproducer:
1. Install a Linux distro with SELinux - Fedora is easiest
2. git clone https://github.com/SELinuxProject/selinux-testsuite
3. Install the requisite dependencies per selinux-testsuite/README.md
4. Run something like the following script:
MOUNT=$HOME/selinux-testsuite
sudo systemctl start nfs-server
sudo exportfs -o rw,no_root_squash,security_label localhost:$MOUNT
sudo mkdir -p /mnt/selinux-testsuite
sudo mount -t nfs -o vers=4.2 localhost:$MOUNT /mnt/selinux-testsuite
pushd /mnt/selinux-testsuite/
sudo make -C policy load
pushd tests/filesystem
sudo runcon -t test_filesystem_t ./create_file -f trans_test_file \
	-e test_filesystem_filetranscon_t -v
sudo rm -f trans_test_file
popd
sudo make -C policy unload
popd
sudo umount /mnt/selinux-testsuite
sudo exportfs -u localhost:$MOUNT
sudo rmdir /mnt/selinux-testsuite
sudo systemctl stop nfs-server

Expected output:
<eliding noise from commands run prior to or after the test itself>
Process context:
	unconfined_u:unconfined_r:test_filesystem_t:s0-s0:c0.c1023
Created file: trans_test_file
File context: unconfined_u:object_r:test_filesystem_filetranscon_t:s0
File context is correct

Actual output:
<eliding noise from commands run prior to or after the test itself>
Process context:
	unconfined_u:unconfined_r:test_filesystem_t:s0-s0:c0.c1023
Created file: trans_test_file
File context: system_u:object_r:test_file_t:s0
File context error, expected:
	test_filesystem_filetranscon_t
got:
	test_file_t

Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Stable-dep-of: 913f7cf77bf1 ("NFSD: NFSv4 file creation neglects setting ACL")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    2 +-
 fs/nfsd/vfs.h |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1379,7 +1379,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
 	 * Callers expect new file metadata to be committed even
 	 * if the attributes have not changed.
 	 */
-	if (iap->ia_valid)
+	if (nfsd_attrs_valid(attrs))
 		status = nfsd_setattr(rqstp, resfhp, attrs, NULL);
 	else
 		status = nfserrno(commit_metadata(resfhp));
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -60,6 +60,14 @@ static inline void nfsd_attrs_free(struc
 	posix_acl_release(attrs->na_dpacl);
 }
 
+static inline bool nfsd_attrs_valid(struct nfsd_attrs *attrs)
+{
+	struct iattr *iap = attrs->na_iattr;
+
+	return (iap->ia_valid || (attrs->na_seclabel &&
+		attrs->na_seclabel->len));
+}
+
 __be32		nfserrno (int errno);
 int		nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 		                struct svc_export **expp);


