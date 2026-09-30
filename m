Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183552ED59;
	Wed, 30 Sep 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790564; cv=none; b=QrRCWsgQ6ifETg8aZwHGrxyHMmW1u/Qrx+olZYMUFgpNVzSLzwnSeurpArf36AAdOQsPpDYEeINvNVgjdHMMRIyti1RnH/LG0b10HawPTM3umMP1LBud6YcJzGeNe5sK7ThZnyB7GuE9eBaTuFP78aWly/wzW1kglAtZVks8AYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790564; c=relaxed/simple;
	bh=dBRtw1E3EOXO3VBEeORnH/PiTA1XKlHvIAb7lGKoTtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnjenCUvyn9oTym3sBn+6eVbXa1hd/1oTy7c3uETmLes1KGudI0P8tTX01cUFuDSYtf2P1OBLopKY8b1BeHUeRTW2LlN0SwkNB9nlbTxV9aShzLSXZTACQUajzfdv2giQejZeGD27vt9saIhFMfzJU3xYKGS6aMgPkAoxV/GPmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDsYRA4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDsYRA4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362B71F000FF;
	Wed, 30 Sep 2026 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790562;
	bh=3o6TBOjU58SdmY24PW6k4cMBrAF3Dr70guN70lceut0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDsYRA4FT+MPTm4BLrbpGDYmtdMfcoadlvDZ6fm+IbORtdQUP7ka63bNCo9gRxuVz
	 RidUARtTVKUkbsAME+5IsKo/TY6IZB6tunlfiei59+fUN+BWV2SPfBlCaqMe+8VxDg
	 ZqozpD35CsAZThiOaa6Xonl9UCJHfK3/uZXoHPKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 871/877] bootconfig: Fix negative seeks on 32-bit with LFS enabled
Date: Wed, 30 Sep 2026 17:29:42 +0200
Message-ID: <20260930152433.528464168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

commit 729dc340a4ed1267774fc8518284e976e2210bdc upstream.

Commit 26dda5769509 "tools/bootconfig: Cleanup bootconfig footer size
calculations" replaced some expressions of type int with the
BOOTCONFIG_FOOTER_SIZE macro, which expands to an expression of type
size_t, which is unsigned.

On 32-bit architectures with LFS enabled (i.e. off_t is 64-bit), the
seek offset of -BOOTCONFIG_FOOTER_SIZE now turns into a positive
value.

Fix this by casting the size to off_t before negating it.

Just in case someone changes BOOTCONFIG_MAGIC_LEN to have type size_t
later, do the same thing to the seek offset of -BOOTCONFIG_MAGIC_LEN.

Link: https://lore.kernel.org/all/aKHlevxeg6Y7UQrz@decadent.org.uk/

Fixes: 26dda5769509 ("tools/bootconfig: Cleanup bootconfig footer size calculations")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -205,7 +205,7 @@ static int load_xbc_from_initrd(int fd,
 	if (stat.st_size < BOOTCONFIG_FOOTER_SIZE)
 		return 0;
 
-	if (lseek(fd, -BOOTCONFIG_MAGIC_LEN, SEEK_END) < 0)
+	if (lseek(fd, -(off_t)BOOTCONFIG_MAGIC_LEN, SEEK_END) < 0)
 		return pr_errno("Failed to lseek for magic", -errno);
 
 	if (read(fd, magic, BOOTCONFIG_MAGIC_LEN) < 0)
@@ -215,7 +215,7 @@ static int load_xbc_from_initrd(int fd,
 	if (memcmp(magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN) != 0)
 		return 0;
 
-	if (lseek(fd, -BOOTCONFIG_FOOTER_SIZE, SEEK_END) < 0)
+	if (lseek(fd, -(off_t)BOOTCONFIG_FOOTER_SIZE, SEEK_END) < 0)
 		return pr_errno("Failed to lseek for size", -errno);
 
 	if (read(fd, &size, sizeof(uint32_t)) < 0)


