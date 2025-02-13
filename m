Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0C226B0A5;
	Thu, 13 Feb 2025 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459866; cv=none; b=cWgxh+M7YSINEv5gfAwX8UwDdYBxYtaFOKS0T44ugarnU991kYrmgLTnEkWgycd0FRGfBEovGzYzlKO+yG0ch/JsJbY9YDHmjOwD6awdaVEy24p3TRTvNdfQRJzko7os03MVrpdsgqxQCyYSWQGPFn1+oUVcnaYqJAwZnZfNs8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459866; c=relaxed/simple;
	bh=hmfV4oiXeTZbRROz1PdSgEhFAMSRQa+UF+EYgOZsq9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gah2SsxLLPC9T8GhozuLI2ZD0SePoNylUHxCDzsdvSfYlT3uF9z3mRhDGTkOhZ2DVtCXVsubD7UcUFQAEhIXbwVD8Fg7y7Ctqastnwln2pWSGE72GNLPE4jBeDhwAfypsd2CEwpHmnGDTMg94K9+dEnE5i5Vzund2DwRcEwtoqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HneOHM2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HneOHM2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F617C4CED1;
	Thu, 13 Feb 2025 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459865;
	bh=hmfV4oiXeTZbRROz1PdSgEhFAMSRQa+UF+EYgOZsq9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HneOHM2xtLq1VLN46TZ5AeiR/F4Z9VhgW2ctmWKuh9p/QpdJDKCqSlrG5P0F/s0Ct
	 akX4a9V7N2QgPp7YKnf0/vM8+TKmplAFMs4cxm94ixN2CcIgFfQroRyWqkg3D66dBa
	 Km+QYJSiGvxZTYdOj2Ct3HxygPMU+sgVu20hgiBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Viallon <antoine@lesviallon.fr>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.13 387/443] ceph: fix memory leak in ceph_mds_auth_match()
Date: Thu, 13 Feb 2025 15:29:12 +0100
Message-ID: <20250213142455.542958269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Antoine Viallon <antoine@lesviallon.fr>

commit 3b7d93db450e9d8ead80d75e2a303248f1528c35 upstream.

We now free the temporary target path substring allocation on every
possible branch, instead of omitting the default branch.  In some
cases, a memory leak occured, which could rapidly crash the system
(depending on how many file accesses were attempted).

This was detected in production because it caused a continuous memory
growth, eventually triggering kernel OOM and completely hard-locking
the kernel.

Relevant kmemleak stacktrace:

    unreferenced object 0xffff888131e69900 (size 128):
      comm "git", pid 66104, jiffies 4295435999
      hex dump (first 32 bytes):
        76 6f 6c 75 6d 65 73 2f 63 6f 6e 74 61 69 6e 65  volumes/containe
        72 73 2f 67 69 74 65 61 2f 67 69 74 65 61 2f 67  rs/gitea/gitea/g
      backtrace (crc 2f3bb450):
        [<ffffffffaa68fb49>] __kmalloc_noprof+0x359/0x510
        [<ffffffffc32bf1df>] ceph_mds_check_access+0x5bf/0x14e0 [ceph]
        [<ffffffffc3235722>] ceph_open+0x312/0xd80 [ceph]
        [<ffffffffaa7dd786>] do_dentry_open+0x456/0x1120
        [<ffffffffaa7e3729>] vfs_open+0x79/0x360
        [<ffffffffaa832875>] path_openat+0x1de5/0x4390
        [<ffffffffaa834fcc>] do_filp_open+0x19c/0x3c0
        [<ffffffffaa7e44a1>] do_sys_openat2+0x141/0x180
        [<ffffffffaa7e4945>] __x64_sys_open+0xe5/0x1a0
        [<ffffffffac2cc2f7>] do_syscall_64+0xb7/0x210
        [<ffffffffac400130>] entry_SYSCALL_64_after_hwframe+0x77/0x7f

It can be triggered by mouting a subdirectory of a CephFS filesystem,
and then trying to access files on this subdirectory with an auth token
using a path-scoped capability:

    $ ceph auth get client.services
    [client.services]
            key = REDACTED
            caps mds = "allow rw fsname=cephfs path=/volumes/"
            caps mon = "allow r fsname=cephfs"
            caps osd = "allow rw tag cephfs data=cephfs"

    $ cat /proc/self/mounts
    services@[REDACTED].cephfs=/volumes/containers /ceph/containers ceph rw,noatime,name=services,secret=<hidden>,ms_mode=prefer-crc,mount_timeout=300,acl,mon_addr=[REDACTED]:3300,recover_session=clean 0 0

    $ seq 1 1000000 | xargs -P32 --replace={} touch /ceph/containers/file-{} && \
    seq 1 1000000 | xargs -P32 --replace={} cat /ceph/containers/file-{}

[ idryomov: combine if statements, rename rc to path_matched and make
            it a bool, formatting ]

Cc: stable@vger.kernel.org
Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
Signed-off-by: Antoine Viallon <antoine@lesviallon.fr>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5690,18 +5690,18 @@ static int ceph_mds_auth_match(struct ce
 			 *
 			 * All the other cases                       --> mismatch
 			 */
+			bool path_matched = true;
 			char *first = strstr(_tpath, auth->match.path);
-			if (first != _tpath) {
-				if (free_tpath)
-					kfree(_tpath);
-				return 0;
+			if (first != _tpath ||
+			    (tlen > len && _tpath[len] != '/')) {
+				path_matched = false;
 			}
 
-			if (tlen > len && _tpath[len] != '/') {
-				if (free_tpath)
-					kfree(_tpath);
+			if (free_tpath)
+				kfree(_tpath);
+
+			if (!path_matched)
 				return 0;
-			}
 		}
 	}
 


