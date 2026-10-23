Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774140;
	b=Z6xR+WMQ3paAiUrgt6DuUENaGxCkTVVLZMJQwgJKQ/hhkiKp5c7HMPJg6+07Gr/iOQS4
	 lcedbQhEtrWMK4MeGEj/5UKHuohWtec8Q3Tke5emOnDP6IYGiwWX2cn9LnO4nChslrB7D
	 V1vaZ6Mg1v0UtONYA/rKGcCYTmB5BNgyV1D28LbpUp4xhLkPhJr7KeN1TVTZEhoVjhZAB
	 jBX8AAOdhKcGzZsOUV+IRf7janC1uZhWUTvRGfVzgrwJme3ZL3jVsPitPeW3JJv8uOyLZ
	 uIvCmfPZqG790nb/doig8pK9HxH9Sddn9UBgR3Z+3tat/qDHxCxd+vaDsTwjDHhaZ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mcfOtY9y0XSKTPn+Y/vRIRPR1ytLUbuTwbMnTfOwjU=;
	b=WC1oxxNcoOGGeopl9gOZRQQFW8ruGmmg160FSmJF9LtTUr1uEwuJlAADefcUNRf+ScW5
	 PvCSQgyTQxjn9caxN2DLR+V0eEBU1MU/0qEpunXqwQ3WkgzCBGEdGFMpqRCt4G6zIGxNF
	 puGrr+JDTcFfo3u7+XLMHhP54ZvEJ21QleUHupM71NaevXvhUzb1dt7PxuUpKW78P1DFD
	 MV0sHLkf1K8ut9a4TAn1D9vfsksaBvhR9QJZHOS/IGtefns8JVFPMtWX+oqtv4seSw6AP
	 66Dum0o66rqV+UQk9b+btau7lxK0iENiLXrxdThVjOpgd8VmPHtkFxbMC9mNhQQXk+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIlkQq1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB548606A32D;
	Fri, 23 Oct 2026 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIlkQq1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020F51F031EE;
	Fri, 23 Oct 2026 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774139;
	bh=9mcfOtY9y0XSKTPn+Y/vRIRPR1ytLUbuTwbMnTfOwjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIlkQq1POmrotWLuZzBQaI7j4aOBZW8NxIOwkcpRC9rnGnPeBvbHEpT3xI0ZsUFlc
	 m0ZQkU+w0ICxJ2/y3+fBJurlxcualSMAW4Q68Qp2Fx5ImXkIBhb9++Xc+NCnmRIRpx
	 9itQReuplIVHpNQDcmikpfjM0a/3BMnnq5vHbVJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 097/193] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Date: Fri, 23 Oct 2026 18:36:14 +0200
Message-ID: <20261023163716.498189200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

commit 89bab1dba8a0167ef0d819e0f55b6bafa038e87f upstream.

The mmap reader can warn when it catches up with a writer that is still
committing events. rb_get_reader_page() returns NULL in this case, but
ring_buffer_map_get_reader() treats that result as an error.

The initial rb_per_cpu_empty() check filters out an empty buffer, but it
does not guarantee that the next reader page has committed data. Writers
do not take reader_lock and can advance commit_page before publishing the
committed length on the new page. rb_get_reader_page() can swap to that
page, catch up with the writer and return NULL.

Handle NULL through the existing no-data exit without warning. Remove the
caller's reader_page == commit_page check as well, since the reader-page
helper already handles that case. The existing metadata update and return
path remain in place.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260924084946.20104-1-krystianmkaniewski@gmail.com
Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7543,12 +7543,8 @@ consume:
 		goto out;
 	}
 
-	/* Did the reader catch up with the writer? */
-	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
-		goto out;
-
 	reader = rb_get_reader_page(cpu_buffer);
-	if (WARN_ON(!reader))
+	if (!reader)
 		goto out;
 
 	/* Check if any events were dropped */


