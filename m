Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08382AD2E;
	Mon, 17 Aug 2026 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976128; cv=none; b=cr93q7A9ylwzUsDqTAnjLngdQwH94dzlHYylITs9jGXP3NLnycrTpBqA12DN0zhrKtBLmc0w+tRI+HZCDDL7jWd+FiYKA/PWiwlPKdeuIo4WupmsH9gpaIz33JordsdXmJo0DgjCgs0H5RIbdlFZ6Z4dyl7+fwr9Nl0BB0743hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976128; c=relaxed/simple;
	bh=u7gjQHiUuaeYPZt2sgc1EbNXGtsL7ikqXYaCN8p9wjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGC6Mj938f6sn+98I04Tmdb65nU2ojp2anKz5C7BoNSuO8Qoe7mNY/iFxEu/9OWO3qUKXex+mnTZAFn2cN6eX7gJfreyqMvHHKVDV5eQximRZfSAhfWS+jtvy6HHct8U3K8Vz4UHkDe66Ico/Zv9e4umKEzJS8qV662T0s7o7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY4AZZND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY4AZZND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72B11F000E9;
	Mon, 17 Aug 2026 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976127;
	bh=SNI/RpHVlDlHBfJrqEWwMBzCxf8FY/uY71K1jUIyTUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY4AZZNDtFbUzwJ9BSOIE4+OVCHbliCjC9rUDvDJxy3zJ0y3+LUQpU5fvG/Ug7VEP
	 z0dJa3/fIsYXrrV1mvHxqI3LnimwjpUx6LuwyldJKU8RcxEqQmQkFxr81sB6Ks3lCR
	 RKFqWkiUtMql6OCeKmjfafKSAtgfdNB1GUHpBUcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 265/389] binfmt_misc: reject a flag character as the field delimiter
Date: Mon, 17 Aug 2026 15:31:44 +0200
Message-ID: <20260817132549.511541575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -347,6 +347,10 @@ static Node *create_entry(const char __u
 
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
+	/* A flag-char delimiter runs the flag scan off the buffer. */
+	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
+		goto einval;
+
 	/* Pad the buffer with the delim to simplify parsing below. */
 	memset(buf + count, del, 8);
 


