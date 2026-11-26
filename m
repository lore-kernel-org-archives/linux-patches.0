Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704856;
	b=bjgpS45LaFonGXR0dlWSwVE41B6eLYqEKLxFXuGEEUR+HGkTNRbe6qeUQcMTFZ0fLuuC
	 RlMUVcJMt4wbB4MY9kYBI/RmALmKQTrwBgMNCTL1jKb6PtmBry+tAgbGINtwhCEMgVKp4
	 mKaWoSqx5nALLQVVwVDLZ9PgftmusVnyyGvqAXZ1NOKkjwBKHHQ7RkYxWdaaU1BCZG2Yj
	 18LEJg320YGuuyV33/0FYPdbY9oBROXVFIxHyk8ljvi3f1RDH/f07Ml3sC48mioc2SNI7
	 51HzSi3BkcOzbQR265AJIXvL8y8NqJhsmCDc66XGGY7BjVO8gWdqTirpTYZj0Cdpl5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EUVw37J3Z6E1eNrL+NEp/gkzVjekwRzzCeI2VfukfR4=;
	b=mMKJiWQlH41KsWtk98rGJeT2WrMODMXupDXw7bPI7kBnh1N6VTX1TiMAt7MfWAL0zwJP
	 bp5AxKgJY8VcoyRqOlX/O2gYwks1qUkWZDcK75PpOF+VNUvlkyvcdJ01qdqP/oeNBD5JS
	 q7kZnjMj4oAnj5hBXeT/zv8noUp/RleO+LwLYaMtOnKsINcX1k4Vz8B9cPOL/6hoFpYTp
	 odBgEuAJm3gOEo7jUeHOOnOSGWA4iOncAGXxhMHcfVqoaxOa11gEt6gpHfTja8a/SYYjb
	 dqXXS2eZvkjW/WCx1NxPlieByr8UiXbb/9cppafXPcx8Yy4qtwYjz86jO1h0wNZ29rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llAqVo0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B092A606A31C;
	Thu, 26 Nov 2026 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llAqVo0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F951F000D4;
	Thu, 26 Nov 2026 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704856;
	bh=EUVw37J3Z6E1eNrL+NEp/gkzVjekwRzzCeI2VfukfR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llAqVo0hZCe/Q+YRnMcf8RFOBGewoeBafhOGfTm+XGfEILXlvM0UP1U8PDJeuoplP
	 hHWcr7T7slXmJqqPsZV4npDDlc3/z3V165BO+NpTEOD5VsmoX9yaVMtdMXOXOQBAQ9
	 sQn8jlzSGDBvYF577dyNlv93jEi4ikw3R9okfhAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 265/265] module: fix [e_shstrndx].sh_size=0 OOB access
Date: Thu, 26 Nov 2026 15:39:55 +0100
Message-ID: <20261126143623.759477635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 391e982bfa632b8315235d8be9c0a81374c6a19c upstream.

It is trivial to craft a module to trigger OOB access in this line:

	if (info->secstrings[strhdr->sh_size - 1] != '\0') {

BUG: unable to handle page fault for address: ffffc90000aa0fff
PGD 100000067 P4D 100000067 PUD 100066067 PMD 10436f067 PTE 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 7 PID: 1215 Comm: insmod Not tainted 5.18.0-rc5-00007-g9bf578647087-dirty #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
RIP: 0010:load_module+0x19b/0x2391

Fixes: ec2a29593c83 ("module: harden ELF info handling")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
[rebased patch onto modules-next]
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3035,6 +3035,10 @@ static int elf_validity_check(struct loa
 	 * strings in the section safe.
 	 */
 	info->secstrings = (void *)info->hdr + strhdr->sh_offset;
+	if (strhdr->sh_size == 0) {
+		pr_err("empty section name table\n");
+		return -ENOEXEC;
+	}
 	if (info->secstrings[strhdr->sh_size - 1] != '\0')
 		return -ENOEXEC;
 


