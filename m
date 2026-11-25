Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624607;
	b=dtDFzWPDGxWCdvB/2TZ5FLeCnqH0sgZPAVoL9zvJlNsbcBiJ3dYTh8cGWA5pz3dK0S2S
	 j4zKVMUgtUwn6mjYNzK3G4Oe7gGm+E9UPmMCnyFpMs1vERmpXXYgUCn+QkycKwCabwOfe
	 OWzKorligAWxglJN7iw6mdlXSGcS63y0UjICv59l0byGdjhR7nw9xHT5naLjaOy5guM1m
	 hNoJQyIMhYzp6QUBmA3pwiVcXt4T8ZJgLEXlo1NpNqHyjGf9i2aBZaZ5plLXApJkYGpcs
	 SMpvaKsQmYiK8bs+Cgbbr2ZIKZicCtQvblCtMBNbVYEmXYIKl1pCL63gr8Bcvzzj42w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gWQFzKtrJo5Pj7VuzYXZI5usyz+hgg0P+mEYL5T/+1g=;
	b=hncEnSn8kbY96SodlqJoJVuWLltXTQ3BRC0Nneh+GgH0cAE50CG7m783Qo1BaczIfkc6
	 2czpXPPXYiGtsL6DmibVxIeSt18BQDF1hTO1h5tdN6uwSW18Z03sVBvbbbkEveWwKjVYb
	 5KZJVXXYfNUOyi+9smjmX0cC7WQLNqI9RZzC9I0wagxN/cHo+SLg1lZLvWqKSOXmr4snG
	 PwhYtkHdVxcONuxUazIlwWfV0e/O3bKq1UlL35IZeAYGLXxt4ky6Hla72V/xO7+7+wfRZ
	 1eaSRzvQktSNFba+lPFZSf9I9ShJyeKOerJJJzjUX48utqWRFFGTfy1NJ5jBlfoD99A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLIwz5Mb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABDA606A682;
	Wed, 25 Nov 2026 16:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLIwz5Mb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41511F000C4;
	Wed, 25 Nov 2026 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624607;
	bh=gWQFzKtrJo5Pj7VuzYXZI5usyz+hgg0P+mEYL5T/+1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLIwz5MbTDfS94ShARvw5833vn+rHLmiSOahaQOiFlCcaKOdTjWqkK6nGAeonoFRL
	 VqIof8+AFX2gdJFyXRgCk+n4cnXmGdhi06ouyjpTXLyG1LNRRtuqpFcyMUiPx6rMda
	 QFrUW8Ik8RhJ2lR9DWb4wLPAgUNHu4yAT9Dl0q7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/816] fs/read_write: make default_llseek() killable
Date: Wed, 25 Nov 2026 15:29:56 +0100
Message-ID: <20261125143854.949227180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 2e1a8fbff51bb9bdf0fe9c6602855e308efcfcdb ]

Allows killing processes that are waiting for the inode lock.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250513150327.1373061-4-max.kellermann@ionos.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7a5783cfac71 ("fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index d908478b7e833..87246e7c2ee83 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -327,7 +327,9 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 	struct inode *inode = file_inode(file);
 	loff_t retval;
 
-	inode_lock(inode);
+	retval = inode_lock_killable(inode);
+	if (retval)
+		return retval;
 	switch (whence) {
 		case SEEK_END:
 			offset += i_size_read(inode);
-- 
2.53.0



