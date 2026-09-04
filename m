Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E13A5445;
	Fri,  4 Sep 2026 05:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500732; cv=none; b=U9D1iB/X9G+gCc0lo9jRxySy9A178WWRtbWmmXxqAbOwrphSgYm4VwDYKXhNNNg7jJHUDIxbaAdmU5byXGFs8yaLn3SArUbzJ1BqUs6jKuGrBmBFcJhbo8ScKOQM3rYXceOwKkKPFzCkuuJ7TrtPmygOg4vyBVxGN647VWhye90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500732; c=relaxed/simple;
	bh=mr/8VRq8btMpXsYpn+B8zfmUTQ0ZDCXxy+bBMstlqx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH0izfjwauPO6NLPBpL787b/7P0kwJGTJN/giT+VEke0WArTYk9eqF47qo1hxxvsRsFVIt+yY+EYyWYhOo2EGuCOMB/mBVLm54cKFqwgHwVERUOgi2xw2ftEcfnvt1vYUWelOfZEgXe8BbIvCVwrgo7LdyYIYdrIqcURemmmoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2AMRQS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2AMRQS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913741F00A3D;
	Fri,  4 Sep 2026 05:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500731;
	bh=6NAlKOldWVa3nsl3oCL+JB9LrX30lx0ohwV6iSIvJLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2AMRQS261JB3Psmry68DhtXvnuPVSRzU8MtBuCcRAaOgpw1BjAQHIAokAjb6WY2s
	 hS/WeiZmfyurMVHyJvTKkc+z7/GjTMppkkq2Ee9e+u5RLPQ2GJsEWXJfaG3oSAGJkN
	 PjHrBiy+vWHVmT/uE0mSzTxZiM005DVSRM+ZWYyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 158/552] ceph: bound MDSCapAuth path and fs_name decode in handle_session()
Date: Fri,  4 Sep 2026 06:55:15 +0200
Message-ID: <20260904045752.479559322@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 77933e22adfe813be2bd10be08d6e950103c3967 upstream.

handle_session() decodes the MDSCapAuth records carried by a
CEPH_SESSION_OPEN message (msg_version >= 6). For each record the
match.path and match.fs_name byte strings are read by first decoding a
32-bit length and then copying that many bytes with the bare
ceph_decode_copy(). Unlike the surrounding fields, which all use the
_safe decode variants, these two copies are not preceded by a
ceph_decode_need() bounds check, and the enclosing MDSCapAuth and
MDSCapMatch struct_len fields are skipped rather than enforced as an
upper bound. A length larger than the bytes remaining in the message
front makes ceph_decode_copy() read past the end of the front buffer.

The message front is a dedicated allocation (ceph_msg_new2() ->
kvmalloc), so the over-read runs off that object. A malicious or
compromised MDS can trigger this with the first post-connect message on
mount, with no client-side user interaction; under KASAN it is reported
as a slab-out-of-bounds read in handle_session().

Impact: a malicious MDS can force the kernel client to read up to 4 GiB
past the message front allocation during session setup, crashing the
client (out-of-bounds read).

Switch both copies to ceph_decode_copy_safe(), which performs the
ceph_decode_need() bounds check before the copy and branches to the
existing bad label, matching the rest of the decoder and the error path
that frees the partially decoded cap_auths array.

Cc: stable@vger.kernel.org
Fixes: 1d17de9534cb ("ceph: save cap_auths in MDS client when session is opened")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4269,7 +4269,9 @@ static void handle_session(struct ceph_m
 					pr_err_client(cl, "No memory for path\n");
 					goto fail;
 				}
-				ceph_decode_copy(&p, cap_auths[i].match.path, _len);
+				ceph_decode_copy_safe(&p, end,
+						      cap_auths[i].match.path,
+						      _len, bad);
 
 				/* Remove the tailing '/' */
 				while (_len && cap_auths[i].match.path[_len - 1] == '/') {
@@ -4286,7 +4288,9 @@ static void handle_session(struct ceph_m
 					pr_err_client(cl, "No memory for fs_name\n");
 					goto fail;
 				}
-				ceph_decode_copy(&p, cap_auths[i].match.fs_name, _len);
+				ceph_decode_copy_safe(&p, end,
+						      cap_auths[i].match.fs_name,
+						      _len, bad);
 			}
 
 			ceph_decode_8_safe(&p, end, cap_auths[i].match.root_squash, bad);


