Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705468;
	b=soSVwG/WGoZ1D3hcg9pDc4QKuafZ5hMGGiDgP4m29z0bMHwBqaCdkjnJe2s2+5VyXbEM
	 Mmjh0zVlsV2rn+nwKg+FfqDcUNzXuXeBpwPGKkBSkQB5lP9XrYRdXsIU6X8y0G9RCDOMi
	 5X9+kf7kcowTZUoiioc0xgKaf3fn8J8zhZu30lpoTn9BwZvT3BnMgLj7kU224uxBorhIB
	 rFzdsMBT+5Km/LHuRRYRdFDUm1hjAd+ttjT2pyEX/IEd9wm4fr1209FUTbXSGAPdZ57VC
	 k2C7GFxJyabA3KzlrPgl9igeqNJPGEU8S25QNZVaukMeeW5cwfA9rtsi9FudQlg4k1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tEX06U3yF9cHzDPL++SpiSNCgY9Mt3p6RIRRcsl3uPc=;
	b=Gj3BIU6xZm142WA47m8OEex1ZjxE6x3FISqDXxJjVuMlmRTPedGhhr7G4NjZT/5s35BF
	 BQImE2P8vADbJrUpKwSwlTPskfHcE26Dy3SA0dED/sgq186BlUjDAiovfYS02Cp1knuDl
	 F92nOAG7sSOCAId/TmEpyZxABe6ki+VObqxcJLoaDZUT6h6FRtF0YNvoFVojyfpfNPReP
	 9IgGXUWUhL8uoZ0D2avCyyGetDqb5rCD7tx/1Z9tRQKmTEIEUvWKwqGNnZoHCDnqTG1Lc
	 OcvKV91BpBrsAWM+2KO4UnTL0G5G8lbcATqQmMjnh6v2TSirIi74ph56PwhA+FP8aww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L6gdeyia;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE856606A327;
	Thu, 26 Nov 2026 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L6gdeyia
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E331F000C6;
	Thu, 26 Nov 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705467;
	bh=tEX06U3yF9cHzDPL++SpiSNCgY9Mt3p6RIRRcsl3uPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6gdeyiaxtVjXxzaf7HYQ9VuAmYdnWHzPGmGCHOfE152doRDSOPaFJ7ODS2v2kR9r
	 495DxlmemPPvc5GdEjipWBHkBhp70Pa87+17uHYOvU10NrI+zbw1fktBer7C0qsYlX
	 wfilP+oZGdXErfQW6UPPL5Wtv2tT0O+hYVY5BISc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 207/319] fs/proc: fix the write length returned by proc_sys_call_handler()
Date: Thu, 26 Nov 2026 15:39:35 +0100
Message-ID: <20261126144011.416952928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -539,6 +539,8 @@ static ssize_t proc_sys_call_handler(str
 	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	size_t count = iov_iter_count(iter);
+	/* ->write_iter() must never report more than the iterator held */
+	size_t orig_count = count;
 	char *kbuf;
 	ssize_t error;
 
@@ -589,7 +591,8 @@ static ssize_t proc_sys_call_handler(str
 			goto out_free_buf;
 	}
 
-	error = count;
+	/* the write path consumed at most the original iterator length */
+	error = write ? min(count, orig_count) : count;
 out_free_buf:
 	kvfree(kbuf);
 out:


