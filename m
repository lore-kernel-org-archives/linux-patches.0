Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705512;
	b=0vMqM8R9Kb0vTGA43Jpkv/H78OeFExoYg0QY3IXlBZrzVldDg21tKnrbcCJUs7JVjBMX
	 Imn2qWGhrGw5krvQMoXsLFAcfMLVUCoYKS28X1zGnvNTinKWI1Xv+ctKwCWmuBO4Iem94
	 ecP9aEzDNRRSGnaApExN96Ro3brzzB/qj8vtArAXNBl8MZjWdpIOhtuvOM6BPwodWGIQu
	 Dy8s/fkwuqhY05QSQD/SdbNjRDAT2YMp66BUbiqJS6iIyzo/yWM6k22mo1UC5lJmEnvSi
	 WqPnLqXcc6SVUaIEXFItwNakwOC6SHU6SqgNPVItT0HLlaq1TPNDNUokQFiM7I+IO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VqQAkbmYevU9qKu6Ms4j4CD1ePIf0Ci51O8l9wqdrgQ=;
	b=yNfFb96Bto/iNZ9CXFgCTZd9UIGp7tRJNSeqLLtkUqwGhi0xvNK0YZUPfaTw/KFD0XYp
	 NMjafHwVx4qZqB+uAkT11WGLxaYx6gth9tDAXL4UKBOZHC7HGzCEIzclPi1p7PggJm0Aq
	 FWG1l/DreEBVRevlNzeVdtYufbfFXcn1q0jjRtA/M3JMvvI9K2+p/Aabrkradt8sIxw4R
	 42Ei9vCMkAvgwSjo7f9seuT5A+wokFlRwBKno6mbQ+XRR83fusgcuqK1t1jd62VbgEBYZ
	 QsgFIFVNPahP5MrTXDQC/bCF8Aj/fJzhVSaqfnrJWaw7yIMBf6bWi5VSRU00TDSDl2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHf4ryKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A1B606A68D;
	Thu, 26 Nov 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VHf4ryKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DA61F000D1;
	Thu, 26 Nov 2026 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705511;
	bh=VqQAkbmYevU9qKu6Ms4j4CD1ePIf0Ci51O8l9wqdrgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHf4ryKwx6Mdrz1B0Zgwr3vasD9qTlLhntpQ0puij/4FRfWjVkNf/uDW8c7vXKQsx
	 +kkkDOnUuEuFIGSNEKXsGeqhbDNf+7SRQGQeO+Bk7ksdxUo9PUE3BaKz6I6G+/huyK
	 dGMLl5HPFU11uYhEin40RW9Au0Jw68PhBtTdv3l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 178/319] aio: dont let exit_aio() return before complete() is done
Date: Thu, 26 Nov 2026 15:39:06 +0100
Message-ID: <20261126144010.765124452@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit ac4b449b39e605123c12ea10042cafc9b6f39603 upstream.

exit_aio() kills all contexts in one go and waits for them with a
single on-stack struct ctx_rq_wait. The count starts at table->nr, each
killed context drops one count in free_ioctx_reqs() and exit_aio()
subtracts the empty slots afterwards. Whoever drops the last count
either calls complete() or, if it is exit_aio(), skips the wait.

With a full table skipped is zero and atomic_sub_and_test(0, ...) only
tells us whether the count already hit zero. free_ioctx_reqs() runs from
the percpu_ref RCU callback, so if exit_aio() is off the CPU long enough
the last callback can have done its atomic_dec_and_test() but not yet
called complete():

    free_ioctx_reqs()                    exit_aio()
    atomic_dec_and_test() // 1 -> 0
                                         atomic_sub_and_test(0) // true
                                         kfree(table)
                                         return
    complete(&wait.comp)

complete() then locks and writes a completion on a stack frame that is
gone. So hold an extra count for exit_aio() itself. Then the last count
is always dropped by exit_aio() after it waited, or by a callback while
exit_aio() waits for it. An unprivileged user gets there with four
io_setup() calls and an exit without io_destroy().

Reported-by: Kyle Zeng <kylebot@openai.com>
Fixes: dc48e56d7616 ("aio: fix serial draining in exit_aio()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030-work-aio-exit_aio-v1-1-83942022a4c4@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -893,7 +893,7 @@ void exit_aio(struct mm_struct *mm)
 	if (!table)
 		return;
 
-	atomic_set(&wait.count, table->nr);
+	atomic_set(&wait.count, table->nr + 1);
 	init_completion(&wait.comp);
 
 	skipped = 0;
@@ -917,7 +917,7 @@ void exit_aio(struct mm_struct *mm)
 		kill_ioctx(mm, ctx, &wait);
 	}
 
-	if (!atomic_sub_and_test(skipped, &wait.count)) {
+	if (!atomic_sub_and_test(skipped + 1, &wait.count)) {
 		/* Wait until all IO for the context are done. */
 		wait_for_completion(&wait.comp);
 	}


