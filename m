Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058881;
	b=IGADY7GhE/9+JVU1qtWfBU0rtDdHn2/UWu8X0WN+hAHzFkAkQLKQ0DDKv8ClpHdb/ifZ
	 V1N/UQZzCGq45rLN8cKKfws5G8RNYG1YJ4CaqMVj+C4scFWWwcqN/68vyV2kYUP/hxMPs
	 dMKpQ+3xFX9Vs4k2dGZHuFrsfXzA9MdJG/fL8sZazC2ZYPyERXLZHhnxKrtXeD0kSeQt9
	 mUSE1WB1414wIH/hVv4VT58RHl7jEzVEAhmNbguKE+797gj8+mairiO4w7GxiZHrvtcnY
	 +ByBCziROlut4fsbihX2O3akptOvsAFZQRYmq8RM1I+/Ylh47zYf6kSNyy2CEFiL8JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fE4pRNVMePFUpdvNM+9HuoGCu//D1ZEfiFZ6vMOgj04=;
	b=E19nGqjyGXO8jq3ErXLD39Twe4byAFTsvrhE2BDXcTwbvE7aizED5TmQkqwh3LoqYF1e
	 e6SCOEGQ9Sh508BaD5vGoR7f+vFF1mS0HAQIull/h89BZOd6OLB1RnRP3UdRcPucEgHST
	 RUNRpZrCSDVz53+c8ncFBRIaLJIgIFN82d7Eq9pNr+T2Orrx9tsf/0+6cUtPTMGTRJvBP
	 RsFspiq0JafZzkGQYER94biJxt8Wbb26RnRYTGHMQrIqGiDHMshXNUIRK0ocmqFCWJeII
	 rQJFpoMnUmzDhTFBFVGxn05PKByVjFMzPLNzUv/qNEr7WhKuiIGvSEIawxSE9ydToGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Png50X85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23443606A31C;
	Thu, 19 Nov 2026 03:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Png50X85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297581F000C4;
	Thu, 19 Nov 2026 03:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058880;
	bh=fE4pRNVMePFUpdvNM+9HuoGCu//D1ZEfiFZ6vMOgj04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Png50X859vDNV052ay54W6kWrx07VS1FGL4sfuUzRV2zsJYsFyaX94LDpjGtw5NY9
	 S3logwZKnVmrYYhfdVfET2+hRgXCS9Y8+7RLxWjc4vHzzCVpvCbduiW+q3oKDQNQ0R
	 7WLEteYyMKAXUv9ycGrMTAHmDAZe05/75VAS0Sb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0644/1848] fsverity: Be more careful with return value of ->get_verity_descriptor()
Date: Wed, 18 Nov 2026 15:44:42 +0100
Message-ID: <20261118145942.711851831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 8f8faec82aa902b1997ae578c46bcc84afbad811 upstream.

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
index 804bd717c4d32..7a786126a1340 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -221,12 +221,6 @@ static bool validate_fsverity_descriptor(struct inode *inode,
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
@@ -266,31 +260,37 @@ int fsverity_get_descriptor(struct inode *inode,
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



