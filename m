Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7738C335BCD;
	Fri,  9 Jan 2026 12:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962208; cv=none; b=l7bsIqxn39mygaYpA3pJuPl7CVfD1IxbR9Y/fBHoXioApuOGGMeUVMCypWHEmZ7QMorZynGlPhyMRt95faMol4/vEASGwRNVvzGX9zW1kT4kTmR2hRF3aQqtZhtoEN+SzXU5CN5BtYsvXmjwU83k7O8cP332ylx33OmxOZcAeJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962208; c=relaxed/simple;
	bh=9b1TGnhc27lZz4Y3O9fkoQVu5jRDoh8t3uKyG/dcuNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTbphrklaoTDPP/p9knNsFBniw28aHXYCjSa3PGTVuA9E0TLGbBE+cOe4fom122qzUU2b3eIsZu+Z+m6xmkk/MBwatta3n2bdOAdrPiGGQdY9pnuFr8W+0gYO63ys8HlAZep+qAbZgDqr7z0ByZPO/dMduLYcs8Z+jYGY1KKpX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQnXBrBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQnXBrBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02087C4CEF1;
	Fri,  9 Jan 2026 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962208;
	bh=9b1TGnhc27lZz4Y3O9fkoQVu5jRDoh8t3uKyG/dcuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQnXBrBrC+nZ3V2dAk4QGVEID6wKA0AfEOAprPcEO5jufpmEoYuxKXK8odFuyiP1E
	 oBumtpmQeWhyrodwX0FfQ8jCSoLqe4S8CRupT6EUHY+ZvTrVYKgg/YJvcOO7aVrpmn
	 fkZ8xTn23M/Vg+BTiXloGEKoeOcdRLTeWQd5X3O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 285/634] ksmbd: fix buffer validation by including null terminator size in EA length
Date: Fri,  9 Jan 2026 12:39:23 +0100
Message-ID: <20260109112128.256432564@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 95d7a890e4b03e198836d49d699408fd1867cb55 upstream.

The smb2_set_ea function, which handles Extended Attributes (EA),
was performing buffer validation checks that incorrectly omitted the size
of the null terminating character (+1 byte) for EA Name.
This patch fixes the issue by explicitly adding '+ 1' to EaNameLength where
the null terminator is expected to be present in the buffer, ensuring
the validation accurately reflects the total required buffer size.

Cc: stable@vger.kernel.org
Reported-by: Roger <roger.andersen@protonmail.com>
Reported-by: Stanislas Polu <spolu@dust.tt>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2354,7 +2354,7 @@ static int smb2_set_ea(struct smb2_ea_in
 	int rc = 0;
 	unsigned int next = 0;
 
-	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 			le16_to_cpu(eabuf->EaValueLength))
 		return -EINVAL;
 
@@ -2430,7 +2430,7 @@ next:
 			break;
 		}
 
-		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 				le16_to_cpu(eabuf->EaValueLength)) {
 			rc = -EINVAL;
 			break;


