Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFA32EF64A;
	Tue, 22 Jul 2025 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193570; cv=none; b=HLgfLrBAj1zQKw57bQZfjcV7z+zabe6qNQGznGEAa3EkiTGDdswrNIKCGOdtJAA90MV5v3mi3/Z/CaOPZ6Nyw/RlxyUvVmFOswRUCauDZL90QsauJPoYyv+mYhJxMy9XnXoIR7hfoY48EaNV20+gglpwOds4GRSws29cFU+4tbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193570; c=relaxed/simple;
	bh=IOOL2zqinpgvYpTFgpiceBVgjcn+QdDFp++Zp8Sct60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMz80Q1X6GHXd2k3riPhrtKOj8tjTzkNY2tsrBFmYI2mdKFJk7lwxpyuhNzgZd39eh5lgbg0TOe77MJxmM1xfS9ppvaWacf/R7/6pwjNBIz9e8nF7YuZML+LUiqrdDWyUD70b/K1V8Csl1KrPSMeIokZRVC0HDTPIHrPQpkOGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnKRj4+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnKRj4+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8DEC4CEF6;
	Tue, 22 Jul 2025 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193570;
	bh=IOOL2zqinpgvYpTFgpiceBVgjcn+QdDFp++Zp8Sct60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnKRj4+un4GV9xBpgZluDbXtezGgI+yCXuniy54WzfASys/r2gFkg4eM5cdyqvSl+
	 M6td24DobhSkXqI49VhyGCh67AMA6EH7UR45VoeOqK3l6ro88Gp1PAz6kynZd0HBIg
	 HwW4D3XD+oZ5FpIXoYdj0GuW2zoYKMZ8EkCUt8AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e2c932aec5c8a6e1d31c@syzkaller.appspotmail.com,
	Yonghong Song <yonghong.song@linux.dev>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 105/187] bpf: Reject %p% format string in bprintf-like helpers
Date: Tue, 22 Jul 2025 15:44:35 +0200
Message-ID: <20250722134349.675050096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit f8242745871f81a3ac37f9f51853d12854fd0b58 ]

static const char fmt[] = "%p%";
    bpf_trace_printk(fmt, sizeof(fmt));

The above BPF program isn't rejected and causes a kernel warning at
runtime:

    Please remove unsupported %\x00 in format string
    WARNING: CPU: 1 PID: 7244 at lib/vsprintf.c:2680 format_decode+0x49c/0x5d0

This happens because bpf_bprintf_prepare skips over the second %,
detected as punctuation, while processing %p. This patch fixes it by
not skipping over punctuation. %\x00 is then processed in the next
iteration and rejected.

Reported-by: syzbot+e2c932aec5c8a6e1d31c@syzkaller.appspotmail.com
Fixes: 48cac3f4a96d ("bpf: Implement formatted output helpers with bstr_printf")
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/a0e06cc479faec9e802ae51ba5d66420523251ee.1751395489.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a71aa4cb85fae..52d02bc0abb2b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -883,6 +883,13 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 		if (fmt[i] == 'p') {
 			sizeof_cur_arg = sizeof(long);
 
+			if (fmt[i + 1] == 0 || isspace(fmt[i + 1]) ||
+			    ispunct(fmt[i + 1])) {
+				if (tmp_buf)
+					cur_arg = raw_args[num_spec];
+				goto nocopy_fmt;
+			}
+
 			if ((fmt[i + 1] == 'k' || fmt[i + 1] == 'u') &&
 			    fmt[i + 2] == 's') {
 				fmt_ptype = fmt[i + 1];
@@ -890,11 +897,9 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 				goto fmt_str;
 			}
 
-			if (fmt[i + 1] == 0 || isspace(fmt[i + 1]) ||
-			    ispunct(fmt[i + 1]) || fmt[i + 1] == 'K' ||
+			if (fmt[i + 1] == 'K' ||
 			    fmt[i + 1] == 'x' || fmt[i + 1] == 's' ||
 			    fmt[i + 1] == 'S') {
-				/* just kernel pointers */
 				if (tmp_buf)
 					cur_arg = raw_args[num_spec];
 				i++;
-- 
2.39.5



