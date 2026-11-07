Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065542;
	b=Xb1SnF5SbAHKEyrl8g3dt1x/99qdyxhlisFalICyrnw3C98bio8A+u49vArFAFCUz4Pp
	 pLtAlnPbmrR0gngsFVuCGsCiyZx7eV84zbKYGuaab7bqzNndJOb8HBpy0fl77HALrd5Mw
	 rSsS1UmsAMJ7zi3W1aVhRU5m7qOWtVSCJN6aPIt01CwENItKvQXbXZmpj8prR8h56gPnD
	 6iPXwl4/utxUzw3eK403XFLYobVeo79VV7jccpGUn8b/bEPd6d3ypSkr2fAnOEf88tOKa
	 RoJmM62dgH1ZTMbINoPfdHazveJ3djwzMQa9LrbBexPw5CI8JbMfrH3FV6GKotBc7Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGHtHt+jAFOjTq6m7FuLLXZ5bVyo+bBbFP3zzTvotn4=;
	b=m8RXj7yz5dN4uvyl7JCwNBAGlDPmX30KzXKlru7R4Z16XOiCy/TOEhMQPYG0du8AecsK
	 1RhbaYG9xAkvjrZDug6XVa4f4e1i1YtDyGsyCwALCbNRUVRlMes5NhVebuXlvBsZkHT1K
	 CllD21WJtv6JCg/nP1BvNDPv9WifGgpWzINb5rQC39OjUhRXyuqxHlWeiZbqRpMYZtaLP
	 mWFMVfTcs/3mBBbbJVfOoE2KZvOr6Qsz3X3mRqBhnRp9dWo9Q+yDLeVECckMh5SwwJXhV
	 Wq9Rave+29IZdm9/HgQO7xVRUp9nwYK4G8cMvjDuz3wMlxtngWfzoOkss/AplTi2zwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjUbJCkB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D69606A330;
	Sat,  7 Nov 2026 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjUbJCkB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B20F1F008A2;
	Sat,  7 Nov 2026 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065542;
	bh=gGHtHt+jAFOjTq6m7FuLLXZ5bVyo+bBbFP3zzTvotn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjUbJCkBmYucS15GUj4dfJ/nmvUJl9VfqvcGgqG2QQM89yhE8tgN6FD6ae8fMHDze
	 PsKcPxui/ogSGYXSp7xborI8CgJ1awSydv9/UGsFO4juwdpV5DR5VHiTosZYd+K72q
	 BCX0uEERARriLpCLnVCXJwjnBJksDMeezoFwrN7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1218/1257] fsverity: Be more careful with return value of ->get_verity_descriptor()
Date: Sat,  7 Nov 2026 08:58:34 -0500
Message-ID: <20261107135013.003183523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 52c8cd0149216..9761b67bc9754 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -270,12 +270,6 @@ static bool validate_fsverity_descriptor(struct inode *inode,
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
@@ -314,31 +308,37 @@ static bool validate_fsverity_descriptor(struct inode *inode,
 int fsverity_get_descriptor(struct inode *inode,
 			    struct fsverity_descriptor **desc_ret)
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



