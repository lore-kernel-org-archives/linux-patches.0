Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826990;
	b=hlvRsMTWryxef3X1H1CRl49uPnGOlayEl9qFMLSm2WyPylKtcMTQPdO6qZALj/St/N96
	 YQRyt/rgpscUL06vu3B0XcIf86q/d4w/f47gGZnORP3f3NqjwW8QtFfdHERDOCcVOw4EW
	 wpfJ1TtQ5S2CrEixkKQZB3inGLMk/Fvzn7hkqVw4n++G2ZPiXCRoYYycaDJ7vZnkBy7sH
	 pMBCdVnERTccuu4AphYpSuiy3BqsQe+Xhp7YJeXcQ77Ym5VBWiQS1DqLMIN0OpGIOru+b
	 x1uHXFkkKpk+2QMZyyqQxO+SIqGUlE0+tnJIFzKZmnEKdTJnrBF5VGEAOuHJKuXugIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ybrEAxNJ7zNp9iwpdBdT2m0umtS4XiF4mHcajRZrvA=;
	b=HcHp41/4z8YxNjXDR6qg0/inSMKcQF5irlGrdfkYnqN8GtNdwzk2PIsnoAr3/3xOCF+H
	 lpFDRpyr0mOrggJQjUDOdZsjjTmM004skITZ+DuaqlI5xrNd+E8jN8rLc8UAsn6UTGySa
	 kLvcJqT4auxyhLqe5XnPBPJFtTQlL5u/T9S8ewNKnsfndW6UUwmu/NaVkns7ovkDZhkNk
	 ap47BBXRPFEyet5U3Xk9mXQly/aeGtdNONe4RbjOFYu6+ZtRKDAIH2Ms2UKSGaq/T1R9Z
	 oHid1/0UL3h7HzoqoWn5QhLjQ0aBF73fUwR9eCjC1r7CJHZKDBpgm3m3AiSC6zxijPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N7B1YKm/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F066070AB2;
	Wed,  4 Nov 2026 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7B1YKm/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457F81F000C1;
	Wed,  4 Nov 2026 21:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826990;
	bh=3ybrEAxNJ7zNp9iwpdBdT2m0umtS4XiF4mHcajRZrvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7B1YKm/Olc71JI4DjHtsvzdAGwBKz8mIaZaPVuP/9EDvW4cG4DlR7NXY+LqPnC58
	 wYtyYPvf+hhNUNAOZotTZnoRIwvGarkuy+g766uWXlVuOdXYuhn/XRQ6DaZQJHNMRN
	 5GaOe8UCvyKsauE+jbJ5QzkfMm+UJ4NkDQu+PQ9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Adolph <coderzeng@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 127/547] ksmbd: prevent session binding in compound requests
Date: Wed,  4 Nov 2026 16:05:11 -0500
Message-ID: <20261104211041.792419816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 19f8fd6b5ced33b02a083759e6901f9d6e8076df upstream.

A failed multichannel binding can retain its target session on the work
item so that the error response can be signed. Subsequent compound
commands can then use that session together with a tree connection left
over from an earlier command.

Limit binding SESSION_SETUP requests to standalone messages during
message validation, before smb2_sess_setup() can replace work->sess.
Check both NextCommand and the current request offset to cover binding
in the first, middle and last positions of a compound. The existing
validation error path returns STATUS_INVALID_PARAMETER and stops
processing the remaining commands.

This intentionally limits support for compounded binding. It is not a
protocol requirement that binding be standalone. Standalone binding and
non-binding compounds retain their existing behavior, without changing
session, tree or response encryption handling.

Fixes: 4b706360ffb7 ("ksmbd: fix multichannel binding and enforce channel limit")
Cc: stable@vger.kernel.org
Reported-by: Zeng Adolph <coderzeng@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2misc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -501,6 +501,14 @@ int ksmbd_smb2_check_message(struct ksmb
 	if (req_struct_size > len + 1)
 		return 1;
 
+	if (command == SMB2_SESSION_SETUP_HE &&
+	    (work->next_smb2_rcv_hdr_off || next_cmd)) {
+		struct smb2_sess_setup_req *req = (void *)hdr;
+
+		if (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)
+			return 1;
+	}
+
 	if (smb2_calc_size(hdr, &clc_len))
 		return 1;
 


