Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017895;
	b=4oJFYPJavCNp4Ofc4vRZeVgeI8MLLUmjM66tZYYqxih+Vc66s4nU/lfbakUMhs0MjQiO
	 ebeOpnW7zTDpaQZ3Er3NIhaTdawRYsmLdNUlRmfKUmVRM8obxqU80pykuxE8+FNjv0tl7
	 0QAldAenjAwu8f5/8TIZZOSFLV26+hubX3+Chz48jKYUt57/vl8nes+lmHj9jrJgExZ80
	 PeqCk+5hUd8O3EFv64eYRoW4RqyGqHnJnEsv7MYJmmcBybINRlKUynoTDfpGsMFTqiMZ+
	 xHhY5EHSRjywlsrYR59L0eX5y1uMJqdrrIEnVhXOr1mnWNVxXhVbyk8JNxVn26kduhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P7QGZOvKVbl8gBtd1583Mx+rJH2vooxNv9f9Ysyw+Oc=;
	b=sw/FVgYUSRm435Prbcc0v/gJj8Fg7P3xmrXS5N3VT8xC8vHIzJNFLvc0zUPpkuOgieL4
	 9etTS/IjKYDxBLhqYZDD4wd7cWKmb4wZjHysr5yqEvqvdmsCuWcVpvPMleAyo4I5VXv82
	 JE4G8F+wTKCFyjq10yxL4+wfph0hrRi9qUkhTPAF1Aq68j3bSGmnl7ALzezPmYhme8WmG
	 TCVNkPFf0r+dVsDmCqG5alx+vkURr7zVpHhODnq79sKuenASplcgBA2k9RaEvFqAs2nRa
	 cDjnJnC4VHidJBCEAbXNiCFsyg2cmk67JWKiy/Q9nmVRi87vzgi5GYSlzPAGuYmXq/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTmTn4xX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F387606A31C;
	Wed, 18 Nov 2026 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTmTn4xX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C761F000C6;
	Wed, 18 Nov 2026 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017895;
	bh=P7QGZOvKVbl8gBtd1583Mx+rJH2vooxNv9f9Ysyw+Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTmTn4xXqQd7OamnBTSCiXylw/YEZXqXxWGmdoTB7ROPzags5LhVfm+Myn36yHzFh
	 NNwWzLE8f9YuEzTAH+aWL6x5AX+I3dOXTtBJVltSwNHquO2HOvwrpfIPXBxQiLgXz3
	 ejBurflR6KaHFvJpapcp/swLK9cDEqI41/5X41cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1006/2651] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:37:26 +0100
Message-ID: <20261118150324.135974499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit c76b93df9ae61d8ddebf6aa3bc218252f85e80c6 ]

The eject command from the util-linux package does not work with the swim
driver: the drive doesn't eject anything and the command fails.
Apparently, ioctl(fd, FDEJECT) returns -EBUSY when fd is opened O_EXCL.
Fix this by checking ref_count for either 1 or -1. Either value means that
the caller is the sole user of the disk.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/ae3ee8e86833a2739d7857460cbe2addf4146088.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index d45b789661a0e..fe46f9656f8ab 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -691,10 +691,11 @@ static int floppy_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	switch (cmd) {
 	case FDEJECT:
-		if (fs->ref_count != 1)
-			return -EBUSY;
 		mutex_lock(&swim_mutex);
-		err = floppy_eject(fs);
+		if (fs->ref_count == -1 || fs->ref_count == 1)
+			err = floppy_eject(fs);
+		else
+			err = -EBUSY;
 		mutex_unlock(&swim_mutex);
 		return err;
 
-- 
2.53.0



