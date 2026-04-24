Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5365C19A288;
	Fri, 24 Apr 2026 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038210; cv=none; b=G/gc1+M8BUYM/WywifZNvKReQosdtMIyY1eJF6T2UzeQlZewj9Dgj6moz1Ycko1poAD/XLFCCbbnQDAEtkVGWH8JnSfq093tjNv006Or7wWmT6atlflNSJPH7XGKqjaQtbCywiamumHCh7oZw1krfHI34rD/n6js6SJ08JMGVu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038210; c=relaxed/simple;
	bh=KGbeaPzcsxf77mDFr72ZeVSqy+Kxrb5X0TWtUxejTPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D40/RdwZehJ85YETLlRel+nW5/hEWOjPz8ddQBn/jZXcINW3KUOgmNMkU866ZEPD48+h66g2yQUzHu+Ncaw1zotmjt2ErKHnA2c8YUZHPB836YcmYQYStU1Er3FbEA8tlbdt0Imi8sGCyKxkSawSYrUFm6wtZtf9V3GBz0gGRRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7L7O3BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7L7O3BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE8AC19425;
	Fri, 24 Apr 2026 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038210;
	bh=KGbeaPzcsxf77mDFr72ZeVSqy+Kxrb5X0TWtUxejTPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7L7O3BUhcpEOw/p4S1ndte/562oj7V5xiOS3DbtrtQJ08RlaEQr1kTk+PPQkUwAC
	 GTgCehkXpyx2qnw+BTQ5BhN7ig0fD41gRR4u7cN2YWSZ4CPWIw7Hxay0N1iqwVMbHU
	 6M/QuW5jN+9YOk7vaW/FTNhZfSQQAH7F0auihXJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Chen <chenste@linux.microsoft.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Baoquan He <bhe@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 03/35] ima: verify if the segment size has changed
Date: Fri, 24 Apr 2026 15:31:10 +0200
Message-ID: <20260424132412.209699927@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Chen <chenste@linux.microsoft.com>

[ Upstream commit d0a00ce470e3ea19ba3b9f1c390aee739570a44a ]

kexec 'load' may be called multiple times. Free and realloc the buffer
only if the segment_size is changed from the previous kexec 'load' call.

Signed-off-by: Steven Chen <chenste@linux.microsoft.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com> # ppc64/kvm
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_kexec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index c9e5b1d6b0ab8..cc418a7e27f20 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -34,6 +34,14 @@ static void ima_free_kexec_file_buf(struct seq_file *sf)
 
 static int ima_alloc_kexec_file_buf(size_t segment_size)
 {
+	/*
+	 * kexec 'load' may be called multiple times.
+	 * Free and realloc the buffer only if the segment_size is
+	 * changed from the previous kexec 'load' call.
+	 */
+	if (ima_kexec_file.buf && ima_kexec_file.size == segment_size)
+		goto out;
+
 	ima_free_kexec_file_buf(&ima_kexec_file);
 
 	/* segment size can't change between kexec load and execute */
@@ -42,6 +50,8 @@ static int ima_alloc_kexec_file_buf(size_t segment_size)
 		return -ENOMEM;
 
 	ima_kexec_file.size = segment_size;
+
+out:
 	ima_kexec_file.read_pos = 0;
 	ima_kexec_file.count = sizeof(struct ima_kexec_hdr);	/* reserved space */
 
-- 
2.53.0



