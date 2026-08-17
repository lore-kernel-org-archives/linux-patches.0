Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C449A3EC82D;
	Mon, 17 Aug 2026 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975840; cv=none; b=tfeaXSNAHuz79mSm/mqNxqID54ma/9fDv4/L2ipAEcGtH+p4wBKUAOg6aK+DQJVs98Elu0dn1ogxbrcJdrJEE19qMf4UgCX3kaOxahtZuD4xL4OnTwdi2QMUUmE/IV1ZuDikEOvB60+Z7S3Ye/m3mRpes4j81DHNsC8S6EU2ed4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975840; c=relaxed/simple;
	bh=rfeKh57d1yS9/nNeg+rK/PM3IMnhA7qgT86vTcPWTlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6AKqnbLX7ichR5C7dfuCgRMccPek6Oln9IE8H/QGudmJTTtUjW4QPJ8nJ/b4lUHdO2xfLPKVUbbt30v6kYdDx5VFvWhCWw/PErre5OOqbM28d01in5Hc0n+UY1aq+fBeoYe1jh/LwazZjjRVX/Q6c6ZJh3iwNWM+BBAaoZnF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DL3cYpaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DL3cYpaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E681F000E9;
	Mon, 17 Aug 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975838;
	bh=8lzEgq5IoMwzowb9z+f19ZY2A2ISv61boyxlzywloCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DL3cYpaXBddAzxLrWtUpF219uKFpxJUyZiGs/6DlWkmVpZmxJVC/CVfj953z5NSxo
	 lWoBIUa01vGQyv+5WSqR1nineNXrj2IqpRV8vLahqwu3qOa1RlIwQVO6+h3o/z6Tqk
	 3WZKBSKM5/NjaN/of5AEcXu3c5o7Ow+TZd/D4lF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 167/389] binfmt_elf_fdpic: only honour the first PT_INTERP
Date: Mon, 17 Aug 2026 15:30:06 +0200
Message-ID: <20260817132545.693860257@linuxfoundation.org>
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

commit 3349ef6a366a61d631f6a263d12cea240957719d upstream.

The program header scan handles PT_INTERP from a switch nested in the
scan loop, so its break leaves the switch and not the loop. A binary
carrying more than one PT_INTERP runs the case again and overwrites both
interpreter_name and interpreter. The previous name allocation leaks and
so does the previous interpreter reference, along with the write denial
open_exec() took on it. The denial is never released, so the file stays
unwritable for as long as the system runs.

An unprivileged caller reaches this with a crafted binary and repeats it
at will. binfmt_elf stops at the first PT_INTERP. Do the same here.

The flaw dates back to the driver's introduction in the pre-git history
tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
binary format driver").

Link: https://patch.msgid.link/20260721-gezittert-medium-kreide-b41fc1f0277e@brauner
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf_fdpic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -231,6 +231,10 @@ static int load_elf_fdpic_binary(struct
 	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
 		switch (phdr->p_type) {
 		case PT_INTERP:
+			/* elf ABI allows only one interpreter */
+			if (interpreter_name)
+				continue;
+
 			retval = -ENOMEM;
 			if (phdr->p_filesz > PATH_MAX)
 				goto error;


