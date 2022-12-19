Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4876FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D9C433D2;
	Mon, 19 Dec 2022 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477976;
	bh=Hbq50VbUFEVVqKD0Q5oDKqIw7LVPtOiJhJHjvE8rWLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mURVp8HcCte54BeFcDJrtUi1Gt69kynQgdZ/gNVQ0d9UQT4TWMQdtZD01hupw+IzJ
	 IB01Iuv7EdpsHwctQHkN1paJLn+eDlq2ekLFfpsSCbQjmSujV4McOz/dlRcdZCiddJ
	 iGoKWRs+dkIR2TXV+smoonD2XkOEIH+KT/7IJI9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 07/28] selftests/bpf: Add bpf_testmod_fentry_* functions
Date: Mon, 19 Dec 2022 20:22:54 +0100
Message-Id: <20221219182944.492514965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

commit fee356ede980b6c2c8db612e18b25738356d6744 upstream.

Adding 3 bpf_testmod_fentry_* functions to have a way to test
kprobe multi link on kernel module. They follow bpf_fentry_test*
functions prototypes/code.

Adding equivalent functions to all bpf_fentry_test* does not
seems necessary at the moment, could be added later.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-7-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c |   24 ++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -88,6 +88,23 @@ __weak noinline struct file *bpf_testmod
 	}
 }
 
+noinline int bpf_testmod_fentry_test1(int a)
+{
+	return a + 1;
+}
+
+noinline int bpf_testmod_fentry_test2(int a, u64 b)
+{
+	return a + b;
+}
+
+noinline int bpf_testmod_fentry_test3(char a, int b, u64 c)
+{
+	return a + b + c;
+}
+
+int bpf_testmod_fentry_ok;
+
 noinline ssize_t
 bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		      struct bin_attribute *bin_attr,
@@ -119,6 +136,13 @@ bpf_testmod_test_read(struct file *file,
 			return snprintf(buf, len, "%d\n", writable.val);
 	}
 
+	if (bpf_testmod_fentry_test1(1) != 2 ||
+	    bpf_testmod_fentry_test2(2, 3) != 5 ||
+	    bpf_testmod_fentry_test3(4, 5, 6) != 15)
+		goto out;
+
+	bpf_testmod_fentry_ok = 1;
+out:
 	return -EIO; /* always fail */
 }
 EXPORT_SYMBOL(bpf_testmod_test_read);


