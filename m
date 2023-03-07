Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62EFBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB3EC433D2;
	Tue,  7 Mar 2023 18:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214055;
	bh=PvVmhNWcGfmoX70Q35VETDXUPrnkRGlJ9jQ2jhJFUeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMJm3T/03xqcsv1SF0nuSjbrqZ5AnAWeZCi+dZQLDAEKl7J/bsSy/9Om1N3FoJzn9
	 xzFS3AIG142iskkSVPrYz4ysADvcwVphGiGMhUGi40AXmpyXG+ZuypcyinRJ+/eIH8
	 wOk8AdPFwznTefFGz1w6T1IIqRiSzSK9PEFd9wtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 666/885] s390: discard .interp section
Date: Tue,  7 Mar 2023 18:00:00 +0100
Message-Id: <20230307170031.108261952@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit e9c9cb90e76ffaabcc7ca8f275d9e82195fd6367 upstream.

When debugging vmlinux with QEMU + GDB, the following GDB error may
occur:

    (gdb) c
    Continuing.
    Warning:
    Cannot insert breakpoint -1.
    Cannot access memory at address 0xffffffffffff95c0

    Command aborted.
    (gdb)

The reason is that, when .interp section is present, GDB tries to
locate the file specified in it in memory and put a number of
breakpoints there (see enable_break() function in gdb/solib-svr4.c).
Sometimes GDB finds a bogus location that matches its heuristics,
fails to set a breakpoint and stops. This makes further debugging
impossible.

The .interp section contains misleading information anyway (vmlinux
does not need ld.so), so fix by discarding it.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -228,5 +228,6 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(.eh_frame)
+		*(.interp)
 	}
 }


