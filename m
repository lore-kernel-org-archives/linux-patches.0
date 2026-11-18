Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045812;
	b=Vv6/w2mhFfhsG7We1H9cOiv/Em0GrCcvg2kVDVr1Vn0kQ2ISxXvrXBtvwZ82PvrhP5+Y
	 CGlqy3Ta9rfrVrZTEJxNY13V6mMkRqT7GfBKNaBUVpXic8n4PQtsAmXexqzPuPii9bHMd
	 VpRi0dc9J5b6pHxZ8jRgIrpskApFWzMY1dboz1zWanp7vvru7x+eDdODKoRMFh3LyQX1S
	 CDE8SBjI4S9VgWwf33Dj4qQgskvWD5VqDur73UIKgrPXw6Zjcpec5gEQc1yLYZz6hbdcc
	 Hne9NdisBHz7AG1XoVkhFspxSUDMCpvPCYcHzdvVCEeLnz69ruazX+iPIgDXt/AgBYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0XN8Dilbevr19QbDG9MIHgHxhm98S9tcne3fNaA7TbY=;
	b=5KTuV8+VAAo9Gv6ZOm6Gf6EOyXJ/o2RkBkXuQK7X2WMxGXR7Zew0irUqwWCm6OnygdjJ
	 vy+boixoXWUVRN6nIpaorSwW1WYk9ykTEAeKtpxSJbxHN9xi/CspBb+OlHMAPYfABE/sP
	 1wm8NnbeBqRTDVXqMOCMkatOxCOihLwAk520x+2StXPUh2MpsiBSkNIrvuk+1zglVXe1Z
	 oxC9tKoUw3nYG6N9ZQLLOj8f6do39V6yqDuguTgQw53bMya/IdexRvGySVLAcmAxzCzrB
	 mF5H4JFCn9hwFzvAwWg7wI/rY5IqhanvypLUWjzUis/RUPsqeKONCwqcse5DsJ1e+HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnSHgOc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA48C606A325;
	Wed, 18 Nov 2026 23:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnSHgOc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F751F000C4;
	Wed, 18 Nov 2026 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045812;
	bh=0XN8Dilbevr19QbDG9MIHgHxhm98S9tcne3fNaA7TbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnSHgOc20IeD9Cb9bvXCIuPnd+td66uWHebV3p7Iutp6alpLZqqmHeJgpQf/I5GrF
	 1piWHq+rGt88gbBNyim8Y74rYygIKuC3nlQQS0JLtR7Pmum256srI2Atv1dZ5TqqYF
	 vJ4W2ULjnpvCSmL8DWyth2F9l/AivfC5hRUU/5kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1057/2857] ceph: clamp MDS reply result code to the errno range
Date: Wed, 18 Nov 2026 15:34:51 +0100
Message-ID: <20261118150239.646667422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>

[ Upstream commit ec8d583469ed64b4973192a21b5a41c33219721f ]

ceph_mdsc_wait_request() returns the reply head result code of the MDS
request to its callers as a plain int errno.  The value is a
server-controlled u32 and nothing checks that it actually is an errno;
several callers pass it straight to ERR_PTR(), e.g.
ceph_finish_lookup() on the atomic open path:

	err = ceph_mdsc_wait_request(...)	/* e.g. +0x50fc00 */
	...
	if (err)
		dentry = ERR_PTR(err);

IS_ERR() only recognizes the [-MAX_ERRNO, -1] window, so an
out-of-range value is not caught anywhere and survives as a "struct
dentry *".  On the open path the positive error travels
ceph_finish_lookup() -> ceph_atomic_open() -> ERR_PTR() in
fs/namei.c's atomic_open() wrapper -> step_into(), which dereferences
it as a dentry and oopses (mainline 7.3-rc3-135-g4982d3552a3b, the
value in R12 is the server-supplied result):

BUG: KASAN: probably user-memory-access in range
[0x000000000050fc00-0x000000000050fc07]
RIP: 0010:step_into_slowpath+0x3e3/0xe60
R12: 000000000050fc00
Call Trace:
 <TASK>
 ? __pfx_ceph_atomic_open+0x10/0x10
 path_openat+0xf41/0x2440
 do_file_open+0x228/0x480
 do_sys_openat2+0x103/0x1d0
 __x64_sys_openat+0x141/0x200
 do_syscall_64+0xe8/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x79
 </TASK>

(0xdffffc00000a1f80 in the full report is the KASAN shadow of 0x50fc00;
without KASAN the raw value is read.)  Values with the top bit set fare
no better: 0xd8000000 sign-extends through the int conversion into the
kernel address range and takes a page fault instead.

Clamp the result at the single read and return -EIO for anything
outside the errno range, which is what a malformed reply means there.
net/9p does the same to server errno values with safe_errno().  This
is the path the reported crash takes; the other readers of
head->result, including the ceph_async_create_cb() and
ceph_async_unlink_cb() callbacks, are not covered by this patch.

Each of the six crashing opens was run on a build of
7.3-rc3-135-g4982d3552a3bf with only this change applied: it crashes
the unpatched kernel on the first openat() (verified on the same
tree without the patch), and with the patch the open fails cleanly
without an oops.  A few hundred normal file operations on the
patched kernel also completed without a crash; valid errno values
pass through unchanged.

Cc: stable@vger.kernel.org
Fixes: 2f2dc053404febedc9c273452d9d518fb31fde72 ("ceph: MDS client")
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a02913070dd02..f8b469c900dee 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3240,6 +3240,14 @@ int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
 	/* only abort if we didn't race with a real reply */
 	if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
 		err = le32_to_cpu(req->r_reply_info.head->result);
+		if (err > 0 || err < -MAX_ERRNO) {
+			/*
+			 * The result is server-controlled.  Values outside
+			 * the errno range are turned into bogus pointers by
+			 * the ERR_PTR() users among the callers.
+			 */
+			err = -EIO;
+		}
 	} else if (err < 0) {
 		dout("aborted request %lld with %d\n", req->r_tid, err);
 
-- 
2.53.0



