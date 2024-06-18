Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA67E16D320;
	Tue, 18 Jun 2024 12:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715348; cv=none; b=GI8Wbz75tLBSXWrlw1ucsDS641tHeUQ6tR8CG4TLUMmUpA//ypkwjl8/T3g+lSTwRe3Km1i8q6lY4N2vQklMwCZz77ZOIZbw9Zhwu6RdKHA6M4qzDa7fOkn+hvsOvFTgrxdrHIjanVWl+gxPGX2CxB9YnTVkmJGwyTvW0FOygVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715348; c=relaxed/simple;
	bh=Wef/eK2PTgez+svjkcxyiVUCAo6nn0aNJn7F5NxDusw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFE7wLNmPGn+vlnRyQFZ0SgTR9VujeN5K8baxEFeECcb3Sv1NqMXVbkvOnLbGWHzCHIG0u5z1mW669JBT6AWTGB17lme/wogtvtEzLoopmFyS8o88zVv71YEV9d0rnr3aZp4RpRp3dD0IAF5ALo8o+oODJLGjHVt3Qq0qfduGYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP/6Gfat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP/6Gfat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D101C3277B;
	Tue, 18 Jun 2024 12:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715348;
	bh=Wef/eK2PTgez+svjkcxyiVUCAo6nn0aNJn7F5NxDusw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PP/6GfatNlmT7vIAbglO6en7Df7FUECw6m4AS+fVWFLOYH/SOSVoss0/upxxEOP1y
	 Nr/bFSYSs3LJz9LibrHUbm9Me02GPmfi1+348oJgX9EIb9v6EGfcRygYSojwCDkAA3
	 92oJvHny7pibgKRIOt8ccoxynqNLDYaSRBqf2SKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/770] UAPI: nfsfh.h: Replace one-element array with flexible-array member
Date: Tue, 18 Jun 2024 14:31:40 +0200
Message-ID: <20240618123416.811709579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit c0a744dcaa29e9537e8607ae9c965ad936124a4d ]

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Use an anonymous union with a couple of anonymous structs in order to
keep userspace unchanged:

$ pahole -C nfs_fhbase_new fs/nfsd/nfsfh.o
struct nfs_fhbase_new {
        union {
                struct {
                        __u8       fb_version_aux;       /*     0     1 */
                        __u8       fb_auth_type_aux;     /*     1     1 */
                        __u8       fb_fsid_type_aux;     /*     2     1 */
                        __u8       fb_fileid_type_aux;   /*     3     1 */
                        __u32      fb_auth[1];           /*     4     4 */
                };                                       /*     0     8 */
                struct {
                        __u8       fb_version;           /*     0     1 */
                        __u8       fb_auth_type;         /*     1     1 */
                        __u8       fb_fsid_type;         /*     2     1 */
                        __u8       fb_fileid_type;       /*     3     1 */
                        __u32      fb_auth_flex[0];      /*     4     0 */
                };                                       /*     0     4 */
        };                                               /*     0     8 */

        /* size: 8, cachelines: 1, members: 1 */
        /* last cacheline: 8 bytes */
};

Also, this helps with the ongoing efforts to enable -Warray-bounds by
fixing the following warnings:

fs/nfsd/nfsfh.c: In function ‘nfsd_set_fh_dentry’:
fs/nfsd/nfsfh.c:191:41: warning: array subscript 1 is above array bounds of ‘__u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
  191 |        ntohl((__force __be32)fh->fh_fsid[1])));
      |                              ~~~~~~~~~~~^~~
./include/linux/kdev_t.h:12:46: note: in definition of macro ‘MKDEV’
   12 | #define MKDEV(ma,mi) (((ma) << MINORBITS) | (mi))
      |                                              ^~
./include/uapi/linux/byteorder/little_endian.h:40:26: note: in expansion of macro ‘__swab32’
   40 | #define __be32_to_cpu(x) __swab32((__force __u32)(__be32)(x))
      |                          ^~~~~~~~
./include/linux/byteorder/generic.h:136:21: note: in expansion of macro ‘__be32_to_cpu’
  136 | #define ___ntohl(x) __be32_to_cpu(x)
      |                     ^~~~~~~~~~~~~
./include/linux/byteorder/generic.h:140:18: note: in expansion of macro ‘___ntohl’
  140 | #define ntohl(x) ___ntohl(x)
      |                  ^~~~~~~~
fs/nfsd/nfsfh.c:191:8: note: in expansion of macro ‘ntohl’
  191 |        ntohl((__force __be32)fh->fh_fsid[1])));
      |        ^~~~~
fs/nfsd/nfsfh.c:192:32: warning: array subscript 2 is above array bounds of ‘__u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
  192 |    fh->fh_fsid[1] = fh->fh_fsid[2];
      |                     ~~~~~~~~~~~^~~
fs/nfsd/nfsfh.c:192:15: warning: array subscript 1 is above array bounds of ‘__u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
  192 |    fh->fh_fsid[1] = fh->fh_fsid[2];
      |    ~~~~~~~~~~~^~~

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/nfsd/nfsfh.h | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/nfsd/nfsfh.h b/include/uapi/linux/nfsd/nfsfh.h
index ff0ca88b1c8f6..427294dd56a1b 100644
--- a/include/uapi/linux/nfsd/nfsfh.h
+++ b/include/uapi/linux/nfsd/nfsfh.h
@@ -64,13 +64,24 @@ struct nfs_fhbase_old {
  *   in include/linux/exportfs.h for currently registered values.
  */
 struct nfs_fhbase_new {
-	__u8		fb_version;	/* == 1, even => nfs_fhbase_old */
-	__u8		fb_auth_type;
-	__u8		fb_fsid_type;
-	__u8		fb_fileid_type;
-	__u32		fb_auth[1];
-/*	__u32		fb_fsid[0]; floating */
-/*	__u32		fb_fileid[0]; floating */
+	union {
+		struct {
+			__u8		fb_version_aux;	/* == 1, even => nfs_fhbase_old */
+			__u8		fb_auth_type_aux;
+			__u8		fb_fsid_type_aux;
+			__u8		fb_fileid_type_aux;
+			__u32		fb_auth[1];
+			/*	__u32		fb_fsid[0]; floating */
+			/*	__u32		fb_fileid[0]; floating */
+		};
+		struct {
+			__u8		fb_version;	/* == 1, even => nfs_fhbase_old */
+			__u8		fb_auth_type;
+			__u8		fb_fsid_type;
+			__u8		fb_fileid_type;
+			__u32		fb_auth_flex[]; /* flexible-array member */
+		};
+	};
 };
 
 struct knfsd_fh {
@@ -97,7 +108,7 @@ struct knfsd_fh {
 #define	fh_fsid_type		fh_base.fh_new.fb_fsid_type
 #define	fh_auth_type		fh_base.fh_new.fb_auth_type
 #define	fh_fileid_type		fh_base.fh_new.fb_fileid_type
-#define	fh_fsid			fh_base.fh_new.fb_auth
+#define	fh_fsid			fh_base.fh_new.fb_auth_flex
 
 /* Do not use, provided for userspace compatiblity. */
 #define	fh_auth			fh_base.fh_new.fb_auth
-- 
2.43.0



