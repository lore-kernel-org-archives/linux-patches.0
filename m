Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2846630C160;
	Fri,  4 Sep 2026 05:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498952; cv=none; b=YYYCv6L9S4AqCQfRhVBWXbLnv8D0FVfTVosif6a46GEfkI1tqdXPYKUggY6Vt2r3elaVCHTxaOAQTChui7RuN0yHYd16PY7oBSD4jWs6k+su8M9jnN9WNEnembovnlrS21YmFFrNUdOab+XH400rvv2Gds7kEySfYKkaNRlg0Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498952; c=relaxed/simple;
	bh=eM+VHNpU3PF8vfYU1He6yjoJEoHXQw5MvNU/nU2VQqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jswCLM0IDSHVWCVSx1ViPW9j1AvjloyYcS/8eABlGcGX5kyqJULjgMuarUz4j7ingZ2PgKJwTGHfBfhDUFIQIptDKnNGk4TlrrX4wJu/DQqVQzixcOyY3DEpqeHLwWLpHbsR989nDWDIxA1qNeI1l9bulPQYl35cQ11WISKLtJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV84FRpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV84FRpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2E41F00A3D;
	Fri,  4 Sep 2026 05:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498950;
	bh=HKqNZBRZgeBvsUNWwqvfihHnPJdaaHilsKzYWhzAQhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FV84FRpKws3BNgBg2BEFn9qNuaWpN11LLck64yvXAbeM/XXdCUSu7shwZfxqTEfky
	 mx4Ebx5ZYg/O2ajdxI3AyhXz6ypzS4pYSI0Tla979PX/tsrzkSdzwdjfDpePKnpsLl
	 pIjjWAt0kcDo0cwCRpMBzThq9XAel46ZD3nrJ1pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 245/713] smb: client: restore the data_offset bound in is_valid_oplock_break()
Date: Fri,  4 Sep 2026 06:53:33 +0200
Message-ID: <20260904045809.324792893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit ba22f575de9deeae4ae0859ca4315a7698226237 upstream.

Commit 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
changed the quantity this bound is measured against.  It used to be
srv->total_read minus the 4-byte RFC1002 preamble that total_read then
included, so it was the SMB message length.  The same commit stopped
counting the preamble, and the mechanical substitution to
srv->total_read - srv->pdu_size left an expression that is identically
zero: standard_receive3() reads MID_HEADER_SIZE() bytes and then exactly
pdu_length - MID_HEADER_SIZE() more, adding both to total_read.

len is therefore 0, the subtraction below it wraps, and no __u32
DataOffset can exceed the result, so the check from commit 097f5863b1a0
("cifs: read overflow in is_valid_oplock_break()") no longer rejects
anything.  Use total_read, which is now the message length on its own.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Cc: stable@kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1misc.c b/fs/smb/client/smb1misc.c
index ba56023010d8..cdfbbff24b72 100644
--- a/fs/smb/client/smb1misc.c
+++ b/fs/smb/client/smb1misc.c
@@ -80,7 +80,8 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 			(struct smb_com_transaction_change_notify_rsp *)buf;
 		struct file_notify_information *pnotify;
 		__u32 data_offset = 0;
-		size_t len = srv->total_read - srv->pdu_size;
+		/* total_read excludes the RFC1002 preamble */
+		size_t len = srv->total_read;
 
 		if (get_bcc(buf) > sizeof(struct file_notify_information)) {
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
-- 
2.55.0



