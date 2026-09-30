Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B834951DDE9;
	Wed, 30 Sep 2026 18:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793655; cv=none; b=uYKr45MfPaiHsM1xC+p7xQOGsUFExXv3e2Tq/+N/ThKeS3Srq2bZQY1ZBOinfZHjxJPDw3aU3r84p9zVWwkqNBvGEMnvama0jslG66Ba0D0oRqfagNktqYMkjcvBUdwFNuqWkrho5SjvJEvLctbghQ83/ySoidb9vN/fryvbRU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793655; c=relaxed/simple;
	bh=NCZUOcYeoRPMN5+2OU9XRj5aHhLedM60KhRcCPG8uNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrRb+9wLa+a/hDgVbH72lMNGopdpholq+Uv7mGSjeGORCIsUnl8rmeEZgkkz/FQ2CToWHuw7MPaQSvZI+D5ZcsNI0gPuC/hv+xpxpICcb+MJU3TEVD6ERroG4lInFzErCgh2S2xOlWppJBhXh1MZtDG252qpmg1a+K7Hh3Z4ot4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCUW0ZEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCUW0ZEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0991F000FF;
	Wed, 30 Sep 2026 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793653;
	bh=imGgxVRszy+Gz+f7P1cdw9vedM+3uHOB2wQZXtmqOGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCUW0ZEgtZXbYawxLskwE5NvglAaqQL22rL/j1Zy/TndqgfEfsmmmgnm5ebTEqHPp
	 Fh5tLT1TDqfO9cswrcN5tUq9ZZbUeqcrib6fll54c3rLzejB+8RvvAjVs5CCfxIAqw
	 PBeBzhElYsHGyCI/IcAUFBetl4uf/4xA3Tn6lgWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 332/395] smb: client: validate POSIX create context length
Date: Wed, 30 Sep 2026 17:29:54 +0200
Message-ID: <20260930152347.862118823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit fa2e9900dd2a3f5a1e7ef5a8c5e8d435feedbfcc upstream.

parse_posix_ctxt() reads the fixed nlink, reparse_tag, and mode fields
before checking that the POSIX create context contains them.  A short
context can pass the generic checks and still make these fixed-width
reads run past its declared data.

The current in-tree smb2_open_file() path passes a NULL posix pointer,
so this handler is not reached on the ordinary open path.  Still require
the POSIX data to cover all three fields before reading them because the
helper performs those unguarded reads.  Keep the existing soft-failure
behavior so malformed optional metadata does not fail the open.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2297,12 +2297,15 @@ static void
 parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 		 struct create_posix_rsp *posix)
 {
-	int sid_len;
 	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
-	u8 *end = beg + le32_to_cpu(cc->DataLength);
+	u32 dlen = le32_to_cpu(cc->DataLength);
+	u8 *end = beg + dlen;
+	int sid_len;
 	u8 *sid;
 
 	memset(posix, 0, sizeof(*posix));
+	if (dlen < 3 * sizeof(__le32))
+		return;
 
 	posix->nlink = get_unaligned_le32(beg);
 	posix->reparse_tag = get_unaligned_le32(beg + 4);


