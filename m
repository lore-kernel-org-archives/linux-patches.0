Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE483AA187;
	Fri,  4 Sep 2026 05:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500644; cv=none; b=dbLqUH+vL3lXtif9XcTnEmKgbepcuEeWut4x+L87OHsorFp4a/QHe5pYVTEDHivwmQUfvt3+ZILh9KjiEiEyfy+/4pxY32dz165jcY9y/2uoYYTqwv/YbfDbH1Wqwp/g05i2qcjHptwZ4N25fSjoVBYrjWz7ce5UDvPqHIMFzOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500644; c=relaxed/simple;
	bh=hITZQhAL2wyNWiIjNSZXp+hqAJmJQZHOjqQ81LeWnmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qh/YbpN+LEoNC5uMdtdRz6OypUiTsWMiw/3VC5DfOY2q0zCbz/YftHHV8ggSslWpyPjKiJHXmyXwX/mHg5BrhfaUvus0XLG3qQnq4l/muoSLLe0ixeGVKSXfzb3CUH0FhX2Brz5V/wBdhIOWorW67nyoYoSvai8Bni4oHnQ276I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkUyUgyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkUyUgyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863E81F00A3D;
	Fri,  4 Sep 2026 05:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500643;
	bh=o/kU72+3Hq3gDdO86LeUMnzKhiyDdQCm0OJM8iYAVfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkUyUgyZkndJGBOLEVPPu4TYcF5p3YjqwrvTQrHcDrR6lvsjROtzItGxD0hb4JAeJ
	 gWV99OH/ZiFbaUKxxdl/w4V9QS8yRlCXribz/1BaU7uO1HwpWQd+LFu0tNPN2o/kJ3
	 RtwUVEIPuCp4Er63ZJvJ0M8t0i1hdpiwwQ1/zfA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 130/552] nfsd: fix dentry ref leak on V4ROOT export filehandle lookup
Date: Fri,  4 Sep 2026 06:54:47 +0200
Message-ID: <20260904045751.265419721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 6247023fbbec1325029f2d5f2a7cdc0f9f9ea15a upstream.

nfsd_set_fh_dentry() leaks the dentry reference from
exportfs_decode_fh_raw() when the NFS3_FHSIZE or NFS_FHSIZE
switch cases detect NFSEXP_V4ROOT and goto out. The out: label
calls exp_put() but never dput(dentry), and fhp->fh_dentry was
never assigned so fh_put() cannot compensate.

A crafted NFSv3 filehandle targeting a V4ROOT export's fsid
triggers the leak on every request.

Fixes: ef7f6c4904d0 ("nfsd: move V4ROOT version check to nfsd_set_fh_dentry()")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-4-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -277,15 +277,19 @@ static __be32 nfsd_set_fh_dentry(struct
 		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOWCC)
 			fhp->fh_no_wcc = true;
 		fhp->fh_64bit_cookies = true;
-		if (exp->ex_flags & NFSEXP_V4ROOT)
+		if (exp->ex_flags & NFSEXP_V4ROOT) {
+			dput(dentry);
 			goto out;
+		}
 		break;
 	case NFS_FHSIZE:
 		fhp->fh_no_wcc = true;
 		if (EX_WGATHER(exp))
 			fhp->fh_use_wgather = true;
-		if (exp->ex_flags & NFSEXP_V4ROOT)
+		if (exp->ex_flags & NFSEXP_V4ROOT) {
+			dput(dentry);
 			goto out;
+		}
 	}
 
 	fhp->fh_dentry = dentry;


