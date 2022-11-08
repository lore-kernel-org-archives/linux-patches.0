Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE715CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BBBC433C1;
	Tue,  8 Nov 2022 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916809;
	bh=Enubm5nSAt5pDKW3LGllasN5GiNRBGOeVDohoUocnLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG2sjCzCDlkC8TmdD/VeEE/2jVvYaOxJF1gszH53ET0/YxWYn8qjzJxZcRyDW+Tpo
	 KI2hvj1TtwVV8u2SSG2dPO9C5SWkVsumE44EAnOcW1WPNnFkvtxEdVvNLSTAyZ3kVh
	 clHso388XkyoRIpGiFImJMUVQIPMiksZe5XAw0Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 140/197] fprobe: Check rethook_alloc() return in rethook initialization
Date: Tue,  8 Nov 2022 14:39:38 +0100
Message-Id: <20221108133401.305366497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael Mendonca <rafaelmendsr@gmail.com>

commit d05ea35e7eea14d32f29fd688d3daeb9089de1a5 upstream.

Check if fp->rethook succeeded to be allocated. Otherwise, if
rethook_alloc() fails, then we end up dereferencing a NULL pointer in
rethook_add_node().

Link: https://lore.kernel.org/all/20221025031209.954836-1-rafaelmendsr@gmail.com/

Fixes: 5b0ab78998e3 ("fprobe: Add exit_handler support")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -141,6 +141,8 @@ static int fprobe_init_rethook(struct fp
 		return -E2BIG;
 
 	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);
+	if (!fp->rethook)
+		return -ENOMEM;
 	for (i = 0; i < size; i++) {
 		struct fprobe_rethook_node *node;
 


