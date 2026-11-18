Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052948;
	b=Vb0On3f2OuMOIvQjP3Zm+HVbS2hqNda08zn/Cvjos7Eywl6ZoJT74q6DQe26RKGkJeD5
	 nOC+/lg2B2tAxjLjpHrQu2y+gd7IQAxosGHpM3JT1rBbNE2UGN4fo8egW0mH/yjKrH7nh
	 vj+IBKZOBAz94bWxOdiLWU/DAoamUp8Ee8PhOjBongeWl/NFitGjB4xDzdHBPcqzAoKSC
	 RZvnm6lvJSdko3UvnpEPW4aL6JAyZaBOLU+uRC5t9yCHJah0mMcFQV6PGcI8Encfznrdj
	 yULT1uBynWeerpY54mi9svrJd76LkzChBKZ31/L+EoULEVhfQ4/b+rRyPAimdy+izBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SzP7DCaAwou+k+WqqFjAdUyAn31H+5zTC71JlY1TTlY=;
	b=Vw/rL5PX9J79pgJkL4MIaUP8buxyugDN3F/BYnw6LCRkAnyKhxhKZxy8JgYXf9ag2IaN
	 PKtWF91NLEs5JNj4npTe36ZRxSgeFszp5W1i1XGChSIrgjkVQNfBkhsCL74tpwkkukW2s
	 q+Vis5kmQZ2e28zcg8tgu2M6T/jEFYRzOg8gG5I1rIsYRWsKoq47tp6dqpj8rdt4BXyPT
	 7j/GxL4aOW58+JcgSBBq1Ydy1TqUQy8BGqT3s4HWe7FDie5yCRmDxAHQtxwI1EBA5bAnH
	 ONQeiP+AH75X85qbQsO1DdSPIgKEEEUZarRYxnEOqM3CnEAfjDxPE8Ac77aeJXY7Z2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sH4iTc4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F74606A31C;
	Thu, 19 Nov 2026 01:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sH4iTc4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F621F000C4;
	Thu, 19 Nov 2026 01:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052948;
	bh=SzP7DCaAwou+k+WqqFjAdUyAn31H+5zTC71JlY1TTlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sH4iTc4BGdlK2OO9qvqviH2B8XkTXSuZ3L7dnve8Wba+ERBoKaXGe7nABhG8XLoOY
	 GYQg1XPqJTgQpr56+cPUBJDDTnGE2qBwrx8XGGhlqND7ppbPQoICtC3lHmfFkzx66P
	 dDfa2zWQ3TGjI9EVHvf88P/CHOu9D/I7gRCHEklw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0746/2214] fsverity: Be more careful with return value of ->get_verity_descriptor()
Date: Wed, 18 Nov 2026 15:40:22 +0100
Message-ID: <20261118150041.643519577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 8f8faec82aa902b1997ae578c46bcc84afbad811 ]

If fsverity_operations::get_verity_descriptor() returns that the verity
descriptor has 0 size, then a zero-size buffer is allocated to hold it,
and it's called again with bufsize=0.

But bufsize=0 is a special case that says to return the actual size.  If
in the meantime the filesystem has decided that the size is some
actually valid size, it will return that size, and then
validate_fsverity_descriptor() will read from ZERO_SIZE_PTR and crash.

Of course, for the filesystem to misbehave in that strange way, it
generally would require direct writes to the block device.

Regardless, fsverity_get_descriptor() might as well guard against it.
Make it do so.  Specifically, validate that the first call to
->get_verity_descriptor() returns at least the minimum descriptor size,
and validate that the second call returns the same size as the first.

Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261025203831.120095-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/open.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 92df87f5fa388..eedd1a3f9a02f 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -222,12 +222,6 @@ static bool validate_fsverity_descriptor(struct inode *inode,
 					 const struct fsverity_descriptor *desc,
 					 size_t desc_size)
 {
-	if (desc_size < sizeof(*desc)) {
-		fsverity_err(inode, "Unrecognized descriptor size: %zu bytes",
-			     desc_size);
-		return false;
-	}
-
 	if (desc->version != 1) {
 		fsverity_err(inode, "Unrecognized descriptor version: %u",
 			     desc->version);
@@ -267,31 +261,37 @@ int fsverity_get_descriptor(struct inode *inode,
 			    struct fsverity_descriptor **desc_ret,
 			    size_t *desc_size_ret)
 {
-	int res;
+	int size, res;
 	struct fsverity_descriptor *desc;
 
-	res = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
-	if (res < 0) {
-		fsverity_err(inode,
-			     "Error %d getting verity descriptor size", res);
-		return res;
+	size = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
+	if (size < 0) {
+		fsverity_err(inode, "Error %d getting verity descriptor size",
+			     size);
+		return size;
 	}
-	if (res > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
-		fsverity_err(inode, "Verity descriptor is too large (%d bytes)",
-			     res);
+	if (size < sizeof(*desc) || size > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
+		fsverity_err(inode,
+			     "Verity descriptor has invalid size (%d bytes)",
+			     size);
 		return -EMSGSIZE;
 	}
-	desc = kmalloc(res, GFP_KERNEL);
+	desc = kmalloc(size, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
-	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, res);
+	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, size);
 	if (res < 0) {
 		fsverity_err(inode, "Error %d reading verity descriptor", res);
 		kfree(desc);
 		return res;
 	}
-
-	if (!validate_fsverity_descriptor(inode, desc, res)) {
+	if (res != size) {
+		fsverity_err(inode, "Verity descriptor size changed (%d => %d)",
+			     size, res);
+		kfree(desc);
+		return -EINVAL;
+	}
+	if (!validate_fsverity_descriptor(inode, desc, size)) {
 		kfree(desc);
 		return -EINVAL;
 	}
-- 
2.53.0



