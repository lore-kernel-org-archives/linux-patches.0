Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADA92820A0;
	Thu, 19 Feb 2026 02:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466691; cv=none; b=ItrlHAqc7kuF9HK0CJ3bTHBGSCYyId9GW+o0uL7qCtj7+rfosQfx8bIp92btbTryDHw4OkP7xz1fhpk/wTUTl7eA1vQEV5c1E6zj1dCXdbqY4kd6byjsFBa4RGbyfreswnlqQwDwg+JNGgSGrxChVJmCW6l9WN3nWyCVmiFpMLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466691; c=relaxed/simple;
	bh=y6tt7ei+qxr4LoTgYfCIHZb1FvaD8Vmha1OM1rVF+Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdYsQWj7Mx+Pf57GO2wZZgJLKr3OU39aakSUsXXRyxjnI4BBsyVoKkSd+wWvFsgZN6TxMqVfPPO3LDT86ZU4WeH3Ncnsq1aC3MaW8EyA5oyyHc29sfjb9+Nh2788hOely0NuoKHWPQjGYOU6EFarNFup9zE9sJiKodK3pHtooh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BajFkvGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BajFkvGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F0BC116D0;
	Thu, 19 Feb 2026 02:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466691;
	bh=y6tt7ei+qxr4LoTgYfCIHZb1FvaD8Vmha1OM1rVF+Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BajFkvGEtvZdqkRcLrclXmHUQT8SElbN5SQzSLoS+AyHDJN/oyN/s/oR6yOIBS33i
	 mM/+khIkqX+VQYpdZOIDD6X3uyA1Npp6myml/ukSiv2vda1ofp4Ea+Dtou45LVk/Fw
	 3OStkHDKEMoRh7V79SoDLTNwharWzKoAFNev+HTNYVvGzP1U4J0nVWpn2ofdkwInKN
	 ccl5JZwmElRPbFT/SBRhqiPS+JQMvT/uUZlNngp3vFK6ALBVNLW7Kj2qq3Ipp/Us74
	 NunjkK57sYA+ak8U9pTpx8k2D4q2X4ffDAmxIO3JbzMkiKpkZdiWGYtyOObjRBgOh6
	 bazIWr/B9iOqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sam Day <me@samcday.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] usb: gadget: f_fs: Fix ioctl error handling
Date: Wed, 18 Feb 2026 21:03:58 -0500
Message-ID: <20260219020422.1539798-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam Day <me@samcday.com>

[ Upstream commit 8e4c1d06183c25022f6b0002a5cab84979ca6337 ]

When ffs_epfile_ioctl handles FUNCTIONFS_DMABUF_* ioctls, it's currently
falling through when copy_from_user fails.

However, this fallthrough isn't being checked properly, so the handler
continues executing further than it should. It then tries the secondary
dispatch where it ultimately gives up and returns -ENOTTY.

The end result is invalid ioctl invocations will yield a -ENOTTY rather
than an -EFAULT.

It's a common pattern elsewhere in the kernel code to directly return
-EFAULT when copy_from_user fails. So we update ffs_epfile_ioctl to do
the same and fix this issue.

Signed-off-by: Sam Day <me@samcday.com>
Link: https://patch.msgid.link/20260108-ffs-dmabuf-ioctl-fix-v1-1-e51633891a81@samcday.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. So 6.12.y exists and would contain this DMABUF code (introduced in
6.9).

### Stable Criteria Assessment

1. **Obviously correct and tested**: The fix is trivially correct —
   returning `-EFAULT` immediately on `copy_from_user` failure is the
   standard kernel pattern. The commit was accepted by Greg KH (USB
   maintainer and stable tree maintainer).

2. **Fixes a real bug**: Yes — wrong error code returned to userspace
   and unnecessary blocking call on error path. This affects userspace
   programs that depend on correct error codes for their error handling.

3. **Small and contained**: Yes — only 3 error paths changed in a single
   function, net -6 lines. No structural changes.

4. **No new features**: Correct — purely fixes error handling.

5. **Risk assessment**: Extremely low risk. The change only affects
   error paths (when `copy_from_user` fails). The non-error paths
   (successful `copy_from_user`) are completely unchanged.

### Additional Concerns

- **Unnecessary blocking**: The current buggy code causes the function
  to call `ffs_epfile_wait_ep()` when `copy_from_user` fails. This is a
  wait function that could block, causing unnecessary delays for the
  failing ioctl. The fix eliminates this.
- **Dependencies**: No dependencies on other patches needed. The fix is
  self-contained.
- **Affected versions**: Only kernels v6.9+ that contain the DMABUF
  ioctl support.

### Verification

- **git log** confirmed that DMABUF ioctls were introduced in commit
  `7b07a2a7ca02a` (v6.9)
- **Read of f_fs.c lines 1730-1835** confirmed the bug mechanism: after
  `break` from first switch, code falls through to
  `ffs_epfile_wait_ep()` then second switch where default case returns
  `-ENOTTY`, overwriting `-EFAULT`
- **git tag** confirmed the code exists in stable tree 6.12.y (which
  includes all code from v6.9+)
- **Commit message** clearly explains the bug and fix mechanism
- **Signed-off-by Greg KH** confirms the USB maintainer accepted this
  fix
- Could NOT independently verify whether userspace programs have been
  affected (unverified, but the wrong error code is a definite API
  contract violation)

### Summary

This is a clear, small, correct bug fix for error handling in the USB
gadget FunctionFS DMABUF ioctl handler. The bug causes:
1. Wrong error code (`-ENOTTY` instead of `-EFAULT`) returned to
   userspace
2. Unnecessary blocking in `ffs_epfile_wait_ep()` on error paths

The fix is minimal (3 error paths changed to return directly), obviously
correct (follows standard kernel patterns), has zero risk to non-error
paths, and was accepted by Greg KH. It meets all stable kernel criteria.

**YES**

 drivers/usb/gadget/function/f_fs.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 928f51fddc64e..e75d5d8b5ac91 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1744,10 +1744,8 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	{
 		int fd;
 
-		if (copy_from_user(&fd, (void __user *)value, sizeof(fd))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&fd, (void __user *)value, sizeof(fd)))
+			return -EFAULT;
 
 		return ffs_dmabuf_attach(file, fd);
 	}
@@ -1755,10 +1753,8 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	{
 		int fd;
 
-		if (copy_from_user(&fd, (void __user *)value, sizeof(fd))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&fd, (void __user *)value, sizeof(fd)))
+			return -EFAULT;
 
 		return ffs_dmabuf_detach(file, fd);
 	}
@@ -1766,10 +1762,8 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	{
 		struct usb_ffs_dmabuf_transfer_req req;
 
-		if (copy_from_user(&req, (void __user *)value, sizeof(req))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&req, (void __user *)value, sizeof(req)))
+			return -EFAULT;
 
 		return ffs_dmabuf_transfer(file, &req);
 	}
-- 
2.51.0

