Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178EC15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D08C433C1;
	Tue,  8 Nov 2022 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915665;
	bh=Wiuhcs5szipMvq297UpLPxghDLhGbRvOyiXKFWSQ16U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSuYGMXMhpNDRhkUx2CJVujtr24f0L/Zxzw35tfkx5INhVTcj4GuKG6mfffks3wuS
	 UYfRMFsvw8+xPBfnfrd2jQ2AicS7tB0ka/O1yy3LYoZh201o0MCc5y3+/Q/jW95+Z0
	 gbItX/889HBISf2IyjHqVcuJ/DZAM6x3rQfuQRLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/118] s390/boot: add secure boot trailer
Date: Tue,  8 Nov 2022 14:38:55 +0100
Message-Id: <20221108133343.178844248@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit aa127a069ef312aca02b730d5137e1778d0c3ba7 ]

This patch enhances the kernel image adding a trailer as required for
secure boot by future firmware versions.

Cc: <stable@vger.kernel.org> # 5.2+
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/compressed/vmlinux.lds.S | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/compressed/vmlinux.lds.S b/arch/s390/boot/compressed/vmlinux.lds.S
index 9427e2cd0c15..11bf3919610e 100644
--- a/arch/s390/boot/compressed/vmlinux.lds.S
+++ b/arch/s390/boot/compressed/vmlinux.lds.S
@@ -91,8 +91,17 @@ SECTIONS
 		_compressed_start = .;
 		*(.vmlinux.bin.compressed)
 		_compressed_end = .;
-		FILL(0xff);
-		. = ALIGN(4096);
+	}
+
+#define SB_TRAILER_SIZE 32
+	/* Trailer needed for Secure Boot */
+	. += SB_TRAILER_SIZE; /* make sure .sb.trailer does not overwrite the previous section */
+	. = ALIGN(4096) - SB_TRAILER_SIZE;
+	.sb.trailer : {
+		QUAD(0)
+		QUAD(0)
+		QUAD(0)
+		QUAD(0x000000207a49504c)
 	}
 	_end = .;
 
-- 
2.35.1



