Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CEE222D75;
	Thu, 12 Dec 2024 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025006; cv=none; b=u3AqovdZlxXCir7b1eDUk5IUTLKubf96j1pL4mnVTc4CZ9NnPIKcqjEoG/U/a0XVvfeXx0z2l077VuKzCuf6h4xnhAY7b+EGWLVPohe/K4y7Drz7gbAZwT9QEqoBe5wQPEV5FlKKNz7QghThnKU8aaHiWoxnInEQhR3GyJOpTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025006; c=relaxed/simple;
	bh=M1Ky2xygdpCVeWznumJ+Hn1ttEG0fxi1KdVon/gduGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKPGTzSU9nBr1qePvcgAa1xQEXQE4xG39ChvYX+oCBeKYP1D74Kn21nm69TzrQ+TG2sWPUQXiom+VsjLr9cyGh6fQ59sLM3Gib6ceJNmu8a7Tei7657sbC9dtMoUPnPXpflsD7wrP3fmN+1/p5IMBK+7Zu0nPH4k74YBQzazdsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ab96mTpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ab96mTpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD276C4CECE;
	Thu, 12 Dec 2024 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025006;
	bh=M1Ky2xygdpCVeWznumJ+Hn1ttEG0fxi1KdVon/gduGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ab96mTpgxD1mwjgte9kuS5gcl3nltD9La/PAVxUIK0gqBKTaWJNC8ehNHQenZOgsE
	 NmXP/V9iXicpllsaTAohaeO2jQuweHUab33a11jdnW2NmRoVJa56QRklTJwiVHElQO
	 iJJw8uOJPxDA942+7JkNR+n5Ly5FfRPvSv0Q8cr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Mahmoud Adam <mngyadam@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/321] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Thu, 12 Dec 2024 15:59:03 +0100
Message-ID: <20241212144230.995820758@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

commit e2a8910af01653c1c268984855629d71fb81f404 upstream.

ReparseDataLength is sum of the InodeType size and DataBuffer size.
So to get DataBuffer size it is needed to subtract InodeType's size from
ReparseDataLength.

Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
at position after the end of the buffer because it does not subtract
InodeType size from the length. Fix this problem and correctly subtract
variable len.

Member InodeType is present only when reparse buffer is large enough. Check
for ReparseDataLength before accessing InodeType to prevent another invalid
memory access.

Major and minor rdev values are present also only when reparse buffer is
large enough. Check for reparse buffer size before calling reparse_mkdev().

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[use variable name symlink_buf, the other buf->InodeType accesses are
not used in current version so skip]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b2e45e168548b..64ac683498e03 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2539,6 +2539,12 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
 
 	/* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
 	len = le16_to_cpu(symlink_buf->ReparseDataLength);
+	if (len < sizeof(symlink_buf->InodeType)) {
+		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
+		return -EIO;
+	}
+
+	len -= sizeof(symlink_buf->InodeType);
 
 	if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
 		cifs_dbg(VFS, "%lld not a supported symlink type\n",
-- 
2.43.0



