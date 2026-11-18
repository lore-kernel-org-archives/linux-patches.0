Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024155;
	b=S3ECAGaDFSOCd59LdlyIfnn1T/chtLxAThNza2+pXSbxUXX4cxMrvrtcFQdOnix2Nf//
	 MlrPYdlTmpWV4641C7t2R0baleTnJM0iiYXo5AC8Z/HP1QgCsctnPgCpDIfQ/QLApI3vB
	 pdc9Nirp30iwX2AmbgBNPhcaN/VnCkFCMCby8AOba0GWzUXdhibDV4uC7Aj1WARhMKBKf
	 E6fVGnnITZeR5YmcWKBBrJTbyZlSCsMbxrhmTZhjcJracs0wVLfPdC+rtCkdPS7+0FBtB
	 5zmRUBgGrmcm/WTjY3BsrRxGHfjHrr8iM2RBiIaU9bt7TJeuwKoY5WcUsKgSlzHUWPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WjE/jikpjpjFy2Ss7cfiV2F119pJcWYY3NtXRCXkMvc=;
	b=iVYoGdnuVBMcWw+pQAGu3iU/hm8FtOp0v6usG8VHT68kDD0T1LnD1xNG34sM/yTTTF0Y
	 0x//tyLKbyQMeDEL2x0hzgFMe6tM1tsPAvXWY7EKAjheQsaOM2cRY8pfup44jVDvqZcSN
	 4fnJsCmcdHDYMgiTxgRHPPoh5o+sd154TltTPMHaIT8J6225kcGbWmmhVDYDZgcfeu/XX
	 99fwl4jS48dUaU2lhzf6lAePEkPhwIrhlJ0V19FsYE8K/6IXL/zt1vSTwTXXUpmybN3qA
	 guReoZEuY77PZybmGX8AtxhuTxn2jw7v9shBa1af+3CwlPD8wqK4hGt/IY/jmtKRBbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E63fABFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9B606A320;
	Wed, 18 Nov 2026 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E63fABFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056C41F000C4;
	Wed, 18 Nov 2026 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024155;
	bh=WjE/jikpjpjFy2Ss7cfiV2F119pJcWYY3NtXRCXkMvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E63fABFhFwqRj+yUUo1sE34NeYAgJQFjosP6mhGPIeuv83SdFxLtVVyIkF7AT17Qs
	 PE160U+pL5VIPc0XEYvrdTHmRrlvv8kLULt9Ujc6qnEdmg3HXQiItbX7tTvHlH/24l
	 vaIxFHTYxyQXLnjhr7XYZKOxeiT8Uvp2S5YsJ0Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0625/2151] crypto: ccp - fix SFS ioctl race against device teardown
Date: Wed, 18 Nov 2026 15:39:20 +0100
Message-ID: <20261118150144.672697849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit de4929b47683ed22d8c05f68d2d0f0cfd95b90a1 ]

sfs_ioctl() reads psp_master->sfs_data and caches it in sfs_dev before
taking sfs_ioctl_mutex, while sfs_dev_destroy() frees sfs_dev->page
and sfs_dev->command_buf with no locking at all and only clears
psp->sfs_data afterwards. A call to sfs_ioctl() that reads sfs_data
just before sfs_dev_destroy() runs will still acquire the mutex and
go on to use the now-freed command buffer in send_sfs_cmd().

Have both functions take sfs_ioctl_mutex before touching
psp->sfs_data, so a call that is already using sfs_dev completes
before teardown can free it, and a call arriving after teardown sees
sfs_data cleared and returns -ENODEV instead of racing it.

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
index 2f4beaafe7ec6..bc962009ba175 100644
--- a/drivers/crypto/ccp/sfs.c
+++ b/drivers/crypto/ccp/sfs.c
@@ -111,13 +111,13 @@ static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct sfs_device *sfs_dev;
 	int ret = 0;
 
+	guard(mutex)(&sfs_ioctl_mutex);
+
 	if (!psp_master || !psp_master->sfs_data)
 		return -ENODEV;
 
 	sfs_dev = psp_master->sfs_data;
 
-	guard(mutex)(&sfs_ioctl_mutex);
-
 	switch (cmd) {
 	case SFSIOCFWVERS:
 		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
@@ -191,8 +191,11 @@ static void sfs_exit(struct kref *ref)
 
 void sfs_dev_destroy(struct psp_device *psp)
 {
-	struct sfs_device *sfs_dev = psp->sfs_data;
+	struct sfs_device *sfs_dev;
+
+	guard(mutex)(&sfs_ioctl_mutex);
 
+	sfs_dev = psp->sfs_data;
 	if (!sfs_dev)
 		return;
 
-- 
2.53.0



