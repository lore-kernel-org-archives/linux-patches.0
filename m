Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828866;
	b=JAWrYikzcPawSZ5fMjU1IKGJwKJ8BRRNM9B8ELwBB/K4q8THKhe9YLnz6NMl+Kibq7mf
	 NlCvD0xRJcoXlKF4oDhCjb80VDn4v4iXIO+eIjdbmGROAUf3S/VGb6lUd3dJyiYMJSWfe
	 eMHdz1+4+lGbK1r/wBVMfVECTfN4RHhq86wqlP9ZoT64xZZW4omJsrRHod4BVmm/cRQUK
	 wap9+nlSZNqOxpHoc8enAU8EVFEmS8YBV1s/cJ5bQtriueD1s1ZrxIcNQjiAMO9sbZ6T8
	 SUuYvWrulAqStkpn8viKmRyS541zLnQT/meHMqDNIKz4sm0XNGq4RADLEQ41sa1w23w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SdJdG7iBEwe0u2K6X6TLZb31COnbazKmE71YmN3y71M=;
	b=fLewEYjiJQlDkITUv21DrAYtlCh4TXi8NrQ/S4iSS2sjpBue1urJFnvEGmRllEY8ubYw
	 oU612JrBTUwau17M8czgtKhLZW0jXzpOOAi67JP95xZmKnBlNyUDsYJq7fM0Ped0cMPZf
	 1WhkNXQdxXHmhMLeGSjNmHaVt2KYoRiDWPqPTNXFFTOoFp49lFQhb1Xd2UbW23zItfysu
	 lDMZjk4CDfvP6kzHsQNqgTRBDWe+0W4dQK1eqBb09DC1aoYh0m+9q3wDUjoYDa6P3EmyR
	 dnuEHrJEdJ4P861xfiYJEBHScsGVtSUceehKnZ1jw9T/HPvpzDAr6ndPCvoBbkU4ZDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wC/Gv8tQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C8F6070F27;
	Wed,  4 Nov 2026 21:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC/Gv8tQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED08E1F00A02;
	Wed,  4 Nov 2026 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828866;
	bh=SdJdG7iBEwe0u2K6X6TLZb31COnbazKmE71YmN3y71M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wC/Gv8tQkW1qv+7FJaHDmlBlIkT0uT/FNrdrESIo6Or/qxGqX1skYGgvfE9BSVPrY
	 +/jMCIwTMcnzA66lXRZZtPtcIGKmh/GVyvWA/voQ0hiMAUCo43IvzI3DgvRBATZ+gy
	 iReBkaAfQC5Hhfm7UHjXzlW397y1VWlq/n0+IpKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 290/547] ovl: do not copy up an xattr value that was never read
Date: Wed,  4 Nov 2026 16:07:54 -0500
Message-ID: <20261104211046.442899482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 755b5c5c9277be251a51623d6065abab948c61bc upstream.

Copy-up stores uninitialized kernel memory in an xattr of the upper
file, where the user can read it.

ovl_copy_xattr() may only pass bytes to ovl_do_setxattr() that
ovl_do_getxattr() has read. When the read fails with -ERANGE the
function asks for the size again, and if the new size fits the buffer
it stores the buffer although nothing was read into it. The buffer
comes from kvmalloc(), or it still holds the value of the previous
xattr.

A FUSE lower layer that answers every sized GETXATTR with -ERANGE made
copy-up store 4096 bytes that the server never sent, with a kernel
pointer in them, as an xattr of the upper file.

Fix this by failing the copy-up with -EIO when the size that follows
-ERANGE fits the buffer.

Reported-by: Fahad Alharbi <fahad@codepure.com>
Closes: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com/
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -131,8 +131,12 @@ int ovl_copy_xattr(struct super_block *s
 
 retry:
 		size = ovl_do_getxattr(oldpath, name, value, value_size);
-		if (size == -ERANGE)
+		if (size == -ERANGE) {
 			size = ovl_do_getxattr(oldpath, name, NULL, 0);
+			/* Nothing was read into value, so it must not be used */
+			if (size >= 0 && size <= value_size)
+				size = -EIO;
+		}
 
 		if (size < 0) {
 			error = size;


