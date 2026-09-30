Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B5C4DA9D4;
	Wed, 30 Sep 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787954; cv=none; b=Eb7KIKl+6CSWiQn5B+qzFoe9ripzoLjUjSFwssULL+CO5shxPFUW8tzonMS1EAi5g4XGO6qxn4zwiStcysdsT9xKayxJsXpwfDIOnqwHiUZEbyFOG4syIqY6nUTDxQe+29obgqUuFU/Vxj4QGM51M28e36SvnY52YJgoDjXiV/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787954; c=relaxed/simple;
	bh=8T9SBmzn+Zy87WfDeLH1VeYCTiOFuAbZB71U6fl6HfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/9xZ/FDSwzx1/OGTz51OIzVI9olruD3NrxoZ9Mn3DazRy1Oofy3v81k0W2gY2ML+3PTzt45794QDhK3k9mTaYbSsBy9B4+ioQUGAuk6LJZjocySg3dNIFCAH0ktwiQ0U4Dl6fo+ZNnBZPiqrMCrLbuKkOeQGkZElP8I6+6csbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjXZ1spn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjXZ1spn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5CD1F0089A;
	Wed, 30 Sep 2026 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787953;
	bh=SgR4MoqbWxeh5gf17GsVmxVK2J/gasulKAPdm5scF24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjXZ1spneK4akWIbhcpJ7vipIP73BDWcCJgyykRkI5ijt5JuTG2FUxE1CFiFQxyNH
	 +nHbokAbv0a561vCOLHrAYY/UgBKyEJRkqzhyOsPcKDuGl2QmMn5j4Y7FdBNU94ebp
	 ZzKRy/6JiDcx+IgtO6S2edTpbimUdb2aHyyZPajo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 413/457] smb: client: validate POSIX create context length
Date: Wed, 30 Sep 2026 17:28:38 +0200
Message-ID: <20260930152354.900377547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2396,12 +2396,15 @@ static void
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


