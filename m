Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B0B374E64;
	Wed, 23 Sep 2026 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175230; cv=none; b=H7VWC75EtPLvbIwWdsnVfxvlnTSqaGbvCJizt7s79xoCCJQ9YxFOZJmLJK6ygtmLhQKTikg6EP4h399M3Mfz+gxoP6CDbxCOeQ8Va9geangDNRMtR0l1bwmXj4dosKTGluqUvKcity++uPKld9b+1VhVPvNjecgUXjjyhDS5UYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175230; c=relaxed/simple;
	bh=mpSmYPC8TgqdH1sH+KqCuS2BoRs7I9IJpux/YVTtrp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkjVcdVCVhpqFYk5fRxl2bS3OMQNhZeeMd6+HqBqGWIl7GxCDXE5MV73jOo4hsY4LtVXZhTazB6bV1QMdFoVTjbWrX9thNbEZMq1eUhMUBRM3zCJPZA5xZzMsIcajRVekZdBWXmjIpiqnca++RDFpLAjtX0VenxN3dT1EGTlkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wG5yTulW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wG5yTulW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457FC1F000FF;
	Wed, 23 Sep 2026 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175229;
	bh=7GOM1d0Cg4olaAgh6sEg0y5PzDFawvJ3f1PGP9mgqLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wG5yTulWmlZ6N5+29LOkQL5si2xaXjtF9W3Ejc3hlYpyBfBPZlnpokGaKaV7dLgug
	 hV/hor8Ud8CishPCWmA1tmqz/K65AaKA352RzYussjyvcum2xA5pU3zms5r6WTkSwH
	 BrobwWQsE931X0Ej7C+mEYFfSZV2yFl1LvWL0/4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 354/398] smb: client: fix server->total_read for compound encrypted PDUs
Date: Wed, 23 Sep 2026 16:07:08 +0200
Message-ID: <20260923140652.606487462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -5301,6 +5301,7 @@ receive_encrypted_standard(struct TCP_Se
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+	server->total_read = next_cmd ? next_cmd : pdu_length;
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");


