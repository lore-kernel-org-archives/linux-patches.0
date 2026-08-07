Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE104746B1;
	Fri,  7 Aug 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117360; cv=none; b=qfCzo5pNae3+cPIqGQR6eYDJl1BPilYausTUkFQJ0aH4Mrr8Q0MX8n6mNEayCtbyM6jiyFJIbGqMY0VgmwAusU0uWUFpdYDD9xgpQBRbFRbEJLDt4dkTDCB9K7cmkWgSdlseEremtHYxALO6HDigpXDvCOTnelChllCmC408gJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117360; c=relaxed/simple;
	bh=mEO/d0tSMoW1G3+iEnuu+JJfrn2FOzv+cyP5hGAE1UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuDe1nXtZRpiH667FzDx2ShLTxjxBxCNhU3Vitocls7SDc3eaIEEb+e1aLmw15AymsIlFDqd9RCv7/pxSC1IATdU5Yfpt5IswWWd0duB8SSXQRay+Ye1aL46H4ZmlcaECydn8bphNP9dvQsD04X3/bqDIf7xsyYtIYmVSCOUzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8JiTeVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8JiTeVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D5D1F000E9;
	Fri,  7 Aug 2026 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117358;
	bh=g1ROr5nCqqQP/qHOkgPmy+WAY1w0sRyNo3+iGl9PUhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8JiTeVWM+zKyNpN022gilxaF41xIchBDFqfgpIQsiKZl01dIV4pB067TefFN+WjY
	 Ai9SOA6kIGFIWX7tCNqHBNMGrGB6U+L3ATuWlyhmrfWdmkXqVt5OsNNccAz9A6QN88
	 czskuTed68oIOoSSpGpR12JCmXcJzaCGSHzsyJmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 290/438] binfmt_misc: reject a flag character as the field delimiter
Date: Fri,  7 Aug 2026 16:38:06 +0200
Message-ID: <20260807143434.158592595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 8e85d50ba1117fd446bf9a250bd8a97d48384bdc upstream.

The registration string starts with a user chosen delimiter that
separates the individual fields. So that the field parsers terminate
even on a truncated string create_entry() pads the buffer with that
same delimiter:

	memset(buf + count, del, 8);

Most fields are scanned for the delimiter with strchr()/scanarg() and
happily stop on the padding. The flags field is different: instead of
scanning for the delimiter check_special_flags() consumes the flag
characters 'P', 'O', 'C' and 'F' and stops at the first byte that is
none of them, relying on the trailing delimiter to end the scan.

If the delimiter is itself a flag character the padding no longer acts
as a terminator. The scan swallows all eight padding bytes and keeps
reading past the end of the allocation until it hits a byte that is
not a flag character. For example registering

	PaPEPPxPPiP

with 'P' as the delimiter (name "a", type extension, magic "x",
interpreter "i", empty flags) leaves the flag scan running off the end
of the buffer. The registration is rejected in the end because the
parser does not stop exactly at buf + count, but only after the out of
bounds read has already happened. With an unlucky allocation layout the
scan can walk into an unmapped page; under KASAN it is reported as a
slab out of bounds read. binfmt_misc mounts are available to
unprivileged users in a user namespace so the read is reachable without
privileges.

Reject a delimiter that is one of the flag characters up front. Such a
registration was always rejected anyway, only after the out of bounds
read, so no valid registration string changes meaning.

Link: https://patch.msgid.link/20260710-work-binfmt_misc-locking-v3-3-a162f7cb58d6@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -384,6 +384,10 @@ static Node *create_entry(const char __u
 
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
+	/* A flag-char delimiter runs the flag scan off the buffer. */
+	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
+		goto einval;
+
 	/* Pad the buffer with the delim to simplify parsing below. */
 	memset(buf + count, del, 8);
 


