Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20A7511E7A;
	Wed, 30 Sep 2026 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786210; cv=none; b=VzHLtf/WKJC0kJvp/3uePaAn0/WtuFGRBjoR6utxq6szwZL/iKm2jNeyezMH3xfPxaCXg7J59HvQ3mBPCY2fn9xCldVJXjc7Q+vlgwrQAuFapj3IJOw/gx6MalrQnLLm+2kQwrx4ZXipsddWZAmXSKKnkfJGczxekTTj2PVlctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786210; c=relaxed/simple;
	bh=+NSO4cbUUpU+dX0i3Bf/rwMKQ3VG2k2f7BZyLtwHWEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7PGiT95AHgWD5YOGbFLQtSzivSffCvklsuqQ4CF2NO3i4e7IcigfvunlUn2CVife7r5z0BwlF/Q3UnPJIfIDK561bYuIJf25eGkEJVgxPCfEkI2tc8m/qFruu8NnE/mYTbuTTvSZRLawLVKeRI9TsFfhCClw30hk4KKTVnRyVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoR75l6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoR75l6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3291F000FF;
	Wed, 30 Sep 2026 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786208;
	bh=HaUvF/VHvKO3QeDyNA1duioMGklMhR8+Fv/Q4Z2uY98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoR75l6uru1JdLOolSqPn5NJwFSdmMySEpuvBvtZjZwb5y008rLVNOPtCb5aS9qb8
	 mrW9wiOqViiQhE3Mnz26Uatj0kqbCCw6MwGj2Cno39aTqLIsCybHjjXYH1wBoy/aYC
	 dC+JykeRVDy482ZxrWLjF7sDWXKbcDSEy0dX1QYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 779/982] smb: client: fix server->total_read for compound encrypted PDUs
Date: Wed, 30 Sep 2026 17:25:15 +0200
Message-ID: <20260930152433.487586289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit f73726b83e4756fdaa099e1bc1143293bd57ad79 upstream.

In receive_encrypted_standard(), server->total_read is left at the
full decrypted frame size when walking sub-PDUs of a compound encrypted
frame. As a result, cifs_handle_standard() passes this full size
to smb2_check_message(), causing the PDU length guards to incorrectly
validate the entire compound frame instead of the current sub-PDU.

This allows truncated non-last sub-PDUs to bypass length validation,
leading to out-of-bounds reads in smb2_get_data_area_len().

Fix this by setting server->total_read to the true length of the
current sub-PDU: next_cmd for non-last sub-PDUs, and the remaining
pdu_length for the last one.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5217,6 +5217,7 @@ receive_encrypted_standard(struct TCP_Se
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+	server->total_read = next_cmd ? next_cmd : pdu_length;
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");


