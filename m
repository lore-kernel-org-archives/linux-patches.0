Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704579;
	b=wFJfMciC04WAhuvmXEB9+/7i7ps+nXDBXrdpPmALW82VKma6KycH9xsNno2CohyCyLKo
	 n7o8XavDyuvSuiIutQ3BBVR29/Zae0NJxMERFcIJIne1DLU9wQOye4iITUEiVtXsyFuVm
	 ZRfDevQSTQJ6qasxrl9lf9tNZmm9RZ/gBpFJhQMZ8327hTBvEXy6P2h6N78rl9BATAUhp
	 Zbz4A5axoJV7uAB0QS5Mcc619OcQIyOYYVn3+rydCRCJM2Vnc6iNLMvvHnimz2S4J7h79
	 SOn82UAOOo55bI66eTk+EVxqByHO5pngGttXFIxobDiAa5GK77qIw3xgtmHI17FTRQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SlimHpyLpUcYJI40gniDJkeMvsfCJwjp2Nwh6kLRZVA=;
	b=Za70rDcbdpc3ofhKe7uT5vVIq/WBCeNXmK51zVPTksbs6lJI8kr1qPg6+S3WSeKPdnG1
	 Qw5jHLc5CxF88lKq3HkW8/leIa9eaIxiZYBAiAqR6C4YUgvZjHwZplCNm42wCGUMDBSNC
	 LyP692k+Exy5jB8gBnpLECrak4dpJSZTbNA+gJ4mEiJ+x2BtMa2JVi2ToKdzn9EfELbW3
	 WWzNurHaQYAbhPuYRIymQIeQd5aUSBrm4KbQajkVe5lJx/6NKjhKScV53vD/DlPTqvr4k
	 hiE6uYXHqWvXRAoNHA2079xbz2reO0+W3I1GBjh98TsUCmn/B0AN5BOA/b/SZIHY2zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOyXfaer;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F19606A31C;
	Thu, 26 Nov 2026 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOyXfaer
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9534A1F000C4;
	Thu, 26 Nov 2026 14:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704579;
	bh=SlimHpyLpUcYJI40gniDJkeMvsfCJwjp2Nwh6kLRZVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOyXfaerLF/CxqE29ShN6tQPBgDjUx51O2ZzQnXm7fsOnXgeqHU1w0wEr4ctkB8Ay
	 95r8ccwQtIoraH2a/iZg9TvLzvIfF1naUx5JP6RUt3/dOPvoq5fflyCZAVIdGrpA4R
	 nnDkl6yoAWTCpzpHxyEVDNliEQ0B93rBIKYkUyFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 172/265] fs/proc: fix the write length returned by proc_sys_call_handler()
Date: Thu, 26 Nov 2026 15:38:22 +0100
Message-ID: <20261126143617.204883080@linuxfoundation.org>
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
@@ -541,6 +541,8 @@ static ssize_t proc_sys_call_handler(str
 	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	size_t count = iov_iter_count(iter);
+	/* ->write_iter() must never report more than the iterator held */
+	size_t orig_count = count;
 	char *kbuf;
 	ssize_t error;
 
@@ -591,7 +593,8 @@ static ssize_t proc_sys_call_handler(str
 			goto out_free_buf;
 	}
 
-	error = count;
+	/* the write path consumed at most the original iterator length */
+	error = write ? min(count, orig_count) : count;
 out_free_buf:
 	kvfree(kbuf);
 out:


