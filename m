Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619766;
	b=C+4c5qEpiZom5lY1h0YIWwAZ3ON7+h/biqa41xkyH8ZWmINz30pvMY99Q8Lkand1UXlF
	 jFPtEKrA65EJ9/sOpVzbB2EasCkyciW1vrRzW2oLRxKdYa60A6COF53Fl/FoEBh/+743j
	 WLdMbXIaGVk5lLQDpvzjCWLOPiulA8ycMKODKNUMpCa77OzioRA7mNLmEqsuhVkyfihsO
	 WJIyqd/ExSZglI9y6m7U8tuLuoELmv95ZmVNjtDj4Amag2fq192xqm6ih1spJ2Zx91miO
	 uuQFKji0IoZCC1oozd8FaDZw8h29qn2BK/lHx6hzh0enVmb3iGyvhM9FTafY6SixkWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KqxHTU8DFuYZQCYo42m4+HDXvuWZievROVNqa0nawHE=;
	b=flAOl1BLcq0LdxsxEWGboaLFiVHPRpfmZmDHUYOSBohzkezuEAlXjA/VfeoVdimMSLV1
	 NRxQ2JDJoyyaI1RruUj4z2LAaCuvJpB2WhQzNhIzax2SflZjh5BnBCysCTlHwEPk+l8Eu
	 oYJIABbBvgUIYfZsR+Jz9oGKXKRo4NkIPiSSeaoXFajmL7+2QTVNb9rPoJ5SCXmPkwetX
	 QRQ0OnKJmimEmAQePTVBLowxX4WGOpGSGkmrwb4/1/s3vqlhsM9UkSWoR240eK0zRtINO
	 WHdZmYr3fu3x80IrxJ5rT6I4dDzvfMG6VOxSqV1kpiR/2xL/n1cOoEBqlLj8n1Ssi+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSMvtnAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4B9606A321;
	Wed, 25 Nov 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSMvtnAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1869B1F000C6;
	Wed, 25 Nov 2026 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619765;
	bh=KqxHTU8DFuYZQCYo42m4+HDXvuWZievROVNqa0nawHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSMvtnAGFr9Mlr7wiDU7g7H+woPoJc/snfOUKqnVtcdjIvuKNd7bSDPK60Vd4wnR0
	 jcsrnTCGJR924GH2ReNjC5jUuC+vm9X5kcaRXBdj7v5mVaB17vv2c2o8wDu7msdWVM
	 cLRPk+JCH/S/TFZy3QzwCtG1omEW5Kl+uL/yXsFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0702/1005] fs/proc: fix the write length returned by proc_sys_call_handler()
Date: Wed, 25 Nov 2026 15:34:00 +0100
Message-ID: <20261125143838.203700447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

commit fbdc020ee1b82079102e493aaa7200de5f497a38 upstream.

proc_sys_call_handler() reads the write length from iov_iter_count() and
copies that many bytes from the iterator into kbuf.  A cgroup/sysctl BPF
program can replace the new value through bpf_sysctl_set_new_value() and
update count to the length of the replacement value.  The handler then
returns that adjusted count as the number of bytes written, even though
the iterator originally held a different number of bytes.

If the replacement value is longer than the original input, ->write_iter()
reports more bytes than the iterator held.  splice(2) passes that value to
iter_file_splice_write(), which subtracts it from the pipe length and
walks past the pipe head:

  Splice Exceeded! ret=7 tot=1 left=0
  Oops: general protection fault
  RIP: 0010:iter_file_splice_write+0xb6f/0x1170

The write path consumes at most the original iterator length in
copy_from_iter_full() before the BPF hook runs.  Return the smaller of the
adjusted and original counts on the write path, so an expanded BPF value
cannot exceed the iterator while a handler that reports a shorter parsed
length still produces a short write.  The read path keeps using the
adjusted count for copy_to_iter().

Fixes: 4e63acdff864 ("bpf: Introduce bpf_sysctl_{get,set}_new_value helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314073.648427.7892850166511253762@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -557,6 +557,8 @@ static ssize_t proc_sys_call_handler(str
 	struct ctl_table_header *head = grab_header(inode);
 	const struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	size_t count = iov_iter_count(iter);
+	/* ->write_iter() must never report more than the iterator held */
+	size_t orig_count = count;
 	char *kbuf;
 	ssize_t error;
 
@@ -607,7 +609,8 @@ static ssize_t proc_sys_call_handler(str
 			goto out_free_buf;
 	}
 
-	error = count;
+	/* the write path consumed at most the original iterator length */
+	error = write ? min(count, orig_count) : count;
 out_free_buf:
 	kvfree(kbuf);
 out:


