Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8126114270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05553C433C9;
	Tue, 25 Jul 2023 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282385;
	bh=oyJMKpX+tRVslhuKNrHjM4kIgy+eIZlE7fR7+clRX28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDQUueKyjyW4PAuCmEI7vOh9i5KqoLuOLx2B+CDzKeYiHd1X+6DK1o4rQeN554MOY
	 2cHCSHKy2odBJBzw8teumGtpok1/KcpYU9+CByLJ/O70qwH/+PPXzVcxNg1sOTpH8g
	 tn+oNRSwi6DVUyZOBApOmPSeW7aR/JH2ld5rb900=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <kuifeng@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 111/227] bpf: Print a warning only if writing to unprivileged_bpf_disabled.
Date: Tue, 25 Jul 2023 12:44:38 +0200
Message-ID: <20230725104519.380038361@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kui-Feng Lee <thinker.li@gmail.com>

[ Upstream commit fedf99200ab086c42a572fca1d7266b06cdc3e3f ]

Only print the warning message if you are writing to
"/proc/sys/kernel/unprivileged_bpf_disabled".

The kernel may print an annoying warning when you read
"/proc/sys/kernel/unprivileged_bpf_disabled" saying

  WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible
  via Spectre v2 BHB attacks!

However, this message is only meaningful when the feature is
disabled or enabled.

Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20230502181418.308479-1-kuifeng@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f1c8733f76b83..5524fcf6fb2a4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5394,7 +5394,8 @@ static int bpf_unpriv_handler(struct ctl_table *table, int write,
 		*(int *)table->data = unpriv_enable;
 	}
 
-	unpriv_ebpf_notify(unpriv_enable);
+	if (write)
+		unpriv_ebpf_notify(unpriv_enable);
 
 	return ret;
 }
-- 
2.39.2



