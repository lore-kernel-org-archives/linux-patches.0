Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623083;
	b=Fgt+b8sIqKrggrc0cNWZg+q6vYqXRvmJ9F561IJrGtgSYbp2/FkXmyLpIh8HH8DDjK8K
	 p0eecI+ByXZVKMcXlruq8B8EBPdae1+Ln4+RFCPhfyRFC6JuCLQv8ceBZTvnH7WyxDc5d
	 xII6KZ1gKgy4gVGJxVOCLjJ+EZKPEGHDt2cED4zC/24cdp3mD6uugWRdTfao9KOfogMdW
	 /ChKVkj82ZTqfRZ/qSF3C/MOI5AfugGgtoVALQFC/ylTwHU9RekqDMkWPGOeOK+yHhdqS
	 oy/VRWhqVyVCfDrkiU46gC4yNRk/N+XmLY24Q6DrHc7WOCODe5h3pE9qD7svhbih62Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JT6980Tf02x4RLpw4R47QFCSQbBI/c4OQ8fsSnlnOiU=;
	b=vsgWTGihfOLO7t2AuGccgiMTQyFNKTQBde5QJeUXbpDjXNfWCqZFob6ZVC6EInBzZthk
	 rFKrqVRvFIJoafZP+u0g/utVXCHEGyE+wwaU6MWLUqdqeUBjAIPPuUHozJTVUvaBTNQEI
	 YuYWCu8r91rjyAS14ZqbilodZ1IOn8MNm7cqsxQt/uweU22yubr+NNzNh2B9oBNdlMji6
	 0GNCc7QF3ppl1tnIaCbtfsnD4E7G8m3E/8TEPyrI/2K6KrIpX0VeqJpwxUMnGtbIOYqXp
	 IkyD0qdNI7ozEHdl7L4LMTD3D7yqHhI0fpEnl3c5KFU24g0U4TtCHUuRQBfrGY0srmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NiKulDjS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE5606A31E;
	Wed, 25 Nov 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NiKulDjS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6411F000C4;
	Wed, 25 Nov 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623083;
	bh=JT6980Tf02x4RLpw4R47QFCSQbBI/c4OQ8fsSnlnOiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiKulDjSHFBWhc6nuiXklZI0Zq/Gil3J07M8mixN/Fggu0ZmJzcB4elI2atWuppxp
	 es9vYJEP0Pb6stCdWBwSO/qwAq5kmlB3W+XrAwwIJDD0UiZKlmZMXRsmLAbI96jFJj
	 +OeSGzlC8pgN4xqY9Rb63IjlZK10iRK/D5rhUzL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 746/990] fs/proc: fix the write length returned by proc_sys_call_handler()
Date: Wed, 25 Nov 2026 15:35:13 +0100
Message-ID: <20261125143839.537208285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


