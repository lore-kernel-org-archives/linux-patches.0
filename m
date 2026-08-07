Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689C3AEB40;
	Fri,  7 Aug 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115322; cv=none; b=uxA25RvjtkD7Fx/qmei1kG/+ltOcHeRekbWOtBUsbnH5d7rs3FCsZrPO4qhhwDOTiZA4sXFdPCiu23vjQWmxuwwUb2WkbWqpZTIlGjO7WO7Nks/3E9G23Sx4hcL3/6U8anGkx1BgR6l83UnaaJ6Pdqc4Dir8duLoW1NkAn7hp74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115322; c=relaxed/simple;
	bh=Xuw+IcvT+Zl9sMsyBdJfzJBRwsPBZo3GmtrVVIginxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIw68LyklCENXaOf47wQpXa0q2tqe88hF7UmwrztY7TQRSuMRmXgaUHaNLZlaxeP6b5D7CZcGibTfV9xRDy9Fd4rqMiAuqI3dIIVmIjTqs+DMoUNMQRCxf0zXZ/e0MyrwzkNnYEziZCjmIWwOr/o4ZGsIjs1vUBT9Y7WUGk3LDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HB2Mo8To; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HB2Mo8To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D971C1F000E9;
	Fri,  7 Aug 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115320;
	bh=o1q+MLFJfCylAV/BZgSPSziuTB7fJG491Th47OztF3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HB2Mo8TocV8diBi761EUhtodjenf5WNf5ahPEvAiAXVu9uOR09zR4qHZG704nPywK
	 sFe4xKyfZ/49TLcBoeuuotT4n3rx4rafB6uhSioN/EBl4RM6NQdOmy3w+fT079JpCY
	 TWwJSI5WygbQqTQfXz/no5qeQopFChEqsIiW/B/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 233/396] binfmt_misc: reject a flag character as the field delimiter
Date: Fri,  7 Aug 2026 16:36:33 +0200
Message-ID: <20260807143429.282785478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -383,6 +383,10 @@ static Node *create_entry(const char __u
 
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
+	/* A flag-char delimiter runs the flag scan off the buffer. */
+	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
+		goto einval;
+
 	/* Pad the buffer with the delim to simplify parsing below. */
 	memset(buf + count, del, 8);
 


