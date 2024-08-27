Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AB81C689C;
	Tue, 27 Aug 2024 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770349; cv=none; b=L5dzPDquSq/jzTzbiO0NO7WCIm6qiulWy2ty88mJ/2T1Nz4W+I9eXWihao0Plez6h2x5LqJaBHmxln93d7K7nfKReSsnZO4NgPhILTK3OuV2BsOphlqtoym8IEFSm4nEMJl0J8o4vRdPOrqdLWK4FJ+XcR3CaJfI93YwpCUBN0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770349; c=relaxed/simple;
	bh=taEQLkR2KGb0eHfcbkFMs1pydCo2bDgpp5G9PPqK7Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaof25NkX08rbDLDYPu7BlcFxFFoe4Tqq0wMEArfKWepN204qV2+cxzToY/DJ1+YlpBzr7b5onJB6IAbCTRE6RyIGorMjQ5tyVTjBTrecmA+8+ImbvV6++HteKCEGAPc7sppVrmILZtYtEwD3Xih9M0K+E6nDQBIjDRi/LYvmt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQTkzHjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQTkzHjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEF6C61042;
	Tue, 27 Aug 2024 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770349;
	bh=taEQLkR2KGb0eHfcbkFMs1pydCo2bDgpp5G9PPqK7Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQTkzHjvlZwI4egxeFvEhJ1XhNQ7tvCXCttBWjH5NhbZ/oE6A50KVe9iT0US6QwI6
	 L0Oy+MicCOBqt8cTQ6M7xKsPLs0iJailQLC797kwiNHabW+9NYbiaUiR4B/ZRzVfru
	 vo7mq6ZG4UO/C610shFVL6u3OpdeDYaAzy5OTZfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/341] openrisc: Call setup_memory() earlier in the init sequence
Date: Tue, 27 Aug 2024 16:37:14 +0200
Message-ID: <20240827143851.139349245@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Oreoluwa Babatunde <quic_obabatun@quicinc.com>

[ Upstream commit 7b432bf376c9c198a7ff48f1ed14a14c0ffbe1fe ]

The unflatten_and_copy_device_tree() function contains a call to
memblock_alloc(). This means that memblock is allocating memory before
any of the reserved memory regions are set aside in the setup_memory()
function which calls early_init_fdt_scan_reserved_mem(). Therefore,
there is a possibility for memblock to allocate from any of the
reserved memory regions.

Hence, move the call to setup_memory() to be earlier in the init
sequence so that the reserved memory regions are set aside before any
allocations are done using memblock.

Signed-off-by: Oreoluwa Babatunde <quic_obabatun@quicinc.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 9cf7fb60441f8..be56eaafc8b95 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -255,6 +255,9 @@ void calibrate_delay(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	/* setup memblock allocator */
+	setup_memory();
+
 	unflatten_and_copy_device_tree();
 
 	setup_cpuinfo();
@@ -278,9 +281,6 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
-	/* setup memblock allocator */
-	setup_memory();
-
 	/* paging_init() sets up the MMU and marks all pages as reserved */
 	paging_init();
 
-- 
2.43.0



