Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063691;
	b=SVEdhPN1BYjN07bRd+1UwHtHS+iioX+1h6Phi0O4Ry2d6oVR2vXhlbo9NNkM5quyzUP+
	 jQU3xOIaek+VwQxwmAGBpi39laXf4yIQN+Mv5zVMS/psAzQEiF+RJ+7PTglU/IxDlIXuC
	 VONDorB7kF83CIthkfIWmBdmuQ/porzx/IV4O434UGtN18AEh99SyapKCn8A7RrMF6kt1
	 wRVXyNeSPOo5//k198sPltfTxEy5UDXd8iksCJJOmz3rvP4vxisitYBOGZvgmmSzninpp
	 C0tMVk85Amt+9A1jbEHvdETqc1eiAD8hUBeR1/L0nO0YMUDBQYjWf923QcDEMCDsINA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eeA49f8JeRLRTGiOktfxjkmbp6GS9Op0k/Agmpjuj9A=;
	b=eL67JtZh8e7/ASENYbAaEjbKL8CuQjVVuTh3CtKi42NfRo9JaIoXzQhdrGVamGEjz3eq
	 +U5LtgF31xi2Yvs/yCMDDRot4maDNkl3lcb2onpqu3xQoTcnBGuw2/ItkzEgFe667AYUp
	 O6Ql/Ace1mg5jPtqivXAOEuF2ycQvTNFYv0KMR11vjfeE3zb78mSKG3FsdCYJkaf8g/Iw
	 l/z3lPDzxiK7cMkJGNsfN2kb6BPWOmwtFRDe5jpOBW+JL8b5D+2ogh8tmd2z+MyrQvvjI
	 UQ/RMVCWc7C2ykADF8WfM+IWJjv5AoEd3ryxmocVo2MgyW4v1UyCgVuz4yz4nmWtJ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUwnbP1r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB83606A32C;
	Sat,  7 Nov 2026 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUwnbP1r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B461F0089F;
	Sat,  7 Nov 2026 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063691;
	bh=eeA49f8JeRLRTGiOktfxjkmbp6GS9Op0k/Agmpjuj9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUwnbP1rSOeMf9YiWJzYQ8aVNjnzmLIGDkCHdV7VD2doLHZs8pqc7EhfOAa7lu+8A
	 GmhtcCQ3FIOrr+XySIwx4DpDZYCWy3APf0wrMLoeEQ7ANM1+/uf0M9LuzTGW5Mozi6
	 1OvafivT3/mzb9dK8M+EiFG+9v23fwSzmYTsVFV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 797/869] loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()
Date: Sat,  7 Nov 2026 08:57:59 -0500
Message-ID: <20261107134919.825913383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Maier <dmnk@google.com>

[ Upstream commit 87409eedc543d288cdd49c2174f7d61eca7b8db5 ]

lo_ioctl() checks for (mode & BLK_OPEN_WRITE) || capable(CAP_SYS_ADMIN)
before allowing LOOP_SET_STATUS or LOOP_SET_STATUS64, but not
lo_compat_ioctl(), the handler used by 32-bit user space on 64-bit
kernels.

As a result, on 64-bit kernels with CONFIG_COMPAT=y, a 32-bit
unprivileged user-space process holding a read-only (O_RDONLY) file
descriptor to an active /dev/loopN device can issue a compat
LOOP_SET_STATUS ioctl to modify lo_offset, clear lo_sizelimit to 0
(exposing backing-file data past the configured limit), or alter
lo_flags.

Enforce the same (mode & BLK_OPEN_WRITE) || capable(CAP_SYS_ADMIN) check
on LOOP_SET_STATUS in lo_compat_ioctl().

Cc: stable@vger.kernel.org
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Reviewed-by: Bart Van Assche bvanassche@acm.org
Link: https://patch.msgid.link/20261025200740.2064379-1-dmnk@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 13ce229d450cd..57d3babbd63bf 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1686,8 +1686,10 @@ static int lo_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	switch(cmd) {
 	case LOOP_SET_STATUS:
-		err = loop_set_status_compat(lo,
-			     (const struct compat_loop_info __user *)arg);
+		err = -EPERM;
+		if ((mode & BLK_OPEN_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_status_compat(lo,
+				(const struct compat_loop_info __user *)arg);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_compat(lo,
-- 
2.53.0



