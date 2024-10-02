Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BCE1D096F;
	Wed,  2 Oct 2024 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879638; cv=none; b=poIVZBZl7Ki2PsXnNq7WUm9PDSzJK6uSOkwWvA3ojZ5Oq4ZDlEVTF+GqGm91bkzUF3lYxU+IPTxU9bZ9xK7MtkBE+9dLEMfsaBpUi6IvfI38ZdCkXA8OHSH0hZy+o7hrhxtLy04LoWLUGSRJT3vsz6Ul+QGOHCOnZrtSgRQSW68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879638; c=relaxed/simple;
	bh=CQ8cCa3SEbkn7exE7h7cxmcETAiFTwpUIFP95xBnipA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq8o4fFXkFkpMGH+Dbi9xKWatZbGBHiDmto7oraIhE4SptmZX8GSRp/QHTj+ipmQcpPoDCvPO7x/jquxoBTqZdRp8/BPI1FtkpsPbADCSjxgkAodpVQZPjjQ7/PIM1ktf2KpTy7AGq3NFksl35hsOdgMvpJYDnpB7kG/T8NXATY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCunbTB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCunbTB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3B9C4CECD;
	Wed,  2 Oct 2024 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879638;
	bh=CQ8cCa3SEbkn7exE7h7cxmcETAiFTwpUIFP95xBnipA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCunbTB7QVp74JpNtk7ghyCfUnZqFysBPu8vb8vKQLOv8n1wGG/rT+/pzmD0hElrZ
	 aD5R+cOpKrR65K8JdHmz7ByzhhE1Ti4vQNhIRWGcGSa3TGOSM//N2/Z54U77CI0I6M
	 lzj4Et9Pm8ZLGJ1O2DF2ac3XlS/J3auFl2WRRuCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/538] tools/runqslower: Fix LDFLAGS and add LDLIBS support
Date: Wed,  2 Oct 2024 14:57:06 +0200
Message-ID: <20241002125759.641125729@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit f86601c3661946721e8f260bdd812b759854ac22 ]

Actually use previously defined LDFLAGS during build and add support for
LDLIBS to link extra standalone libraries e.g. 'argp' which is not provided
by musl libc.

Fixes: 585bf4640ebe ("tools: runqslower: Add EXTRA_CFLAGS and EXTRA_LDFLAGS support")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/bpf/20240723003045.2273499-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/runqslower/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index d8288936c9120..c4f1f1735af65 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -15,6 +15,7 @@ INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../include/uapi)
 CFLAGS := -g -Wall $(CLANG_CROSS_FLAGS)
 CFLAGS += $(EXTRA_CFLAGS)
 LDFLAGS += $(EXTRA_LDFLAGS)
+LDLIBS += -lelf -lz
 
 # Try to detect best kernel BTF source
 KERNEL_REL := $(shell uname -r)
@@ -51,7 +52,7 @@ clean:
 libbpf_hdrs: $(BPFOBJ)
 
 $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
 
 $(OUTPUT)/runqslower.o: runqslower.h $(OUTPUT)/runqslower.skel.h	      \
 			$(OUTPUT)/runqslower.bpf.o | libbpf_hdrs
-- 
2.43.0



