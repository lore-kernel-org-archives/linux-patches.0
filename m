Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F123E768F6;
	Tue, 23 Jan 2024 02:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975525; cv=none; b=NBh/U+F1a+bTauHGmJc/4vAMglsy20vjTg4M80woBqJ4qPp3dnmvhs8ySKfno63vz00TkCKiyeyJT1spQYw5DQrG+oZp6duz21Y4pfWFxwpHy13aNrzs7sXQeHSMmuu7AOrQEbNJnZ8WTePbuCChgN5XdargHExWHdCs0F/tszc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975525; c=relaxed/simple;
	bh=jhkBkCsMKS9nVMhlCI3AQBYjb66I8s19AwDaYtgEwNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFOkO0YY4CaFWjw/VKUUfhiibu3FiFN2+HzWPI5fcifK7BM3zBjlihIbIhSRAMHb+uQSfTUYSqzdKUSprusg/IKjHy4V60el//s4P/byXbUkm26Ikg+Rl1k8y8ECdBKl4VsM3h8XiHRvggEL13vhC6OAGQBCDHCz7LCz2MsqADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHggsgyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHggsgyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DABC433C7;
	Tue, 23 Jan 2024 02:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975524;
	bh=jhkBkCsMKS9nVMhlCI3AQBYjb66I8s19AwDaYtgEwNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHggsgyRdPSqlnUW67ScNTUfin6LgQmwKQiG85cOVJ+zFsLsHC9aNFINHk8PPMAMN
	 LgPW2OpKDrJ1Y5Z/TYfyJZ1cReK0j6a+CPEafiAQw7UqW/oVQtgLAwlxkAlmp8ZKes
	 SfAh1cn4uokM0fgWrjkYNHUUVj3fPHb7LIgvcn1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 477/583] selftests/sgx: Include memory clobber for inline asm in test enclave
Date: Mon, 22 Jan 2024 15:58:48 -0800
Message-ID: <20240122235826.578698033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>

[ Upstream commit 853a57a43ebdb8c024160c1a0990bae85f4bcc2f ]

Add the "memory" clobber to the EMODPE and EACCEPT asm blocks to tell the
compiler the assembly code accesses to the secinfo struct. This ensures
the compiler treats the asm block as a memory barrier and the write to
secinfo will be visible to ENCLU.

Fixes: 20404a808593 ("selftests/sgx: Add test for EPCM permission changes")
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/all/20231005153854.25566-4-jo.vanbulck%40cs.kuleuven.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/test_encl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sgx/test_encl.c b/tools/testing/selftests/sgx/test_encl.c
index c0d6397295e3..ae791df3e5a5 100644
--- a/tools/testing/selftests/sgx/test_encl.c
+++ b/tools/testing/selftests/sgx/test_encl.c
@@ -24,10 +24,11 @@ static void do_encl_emodpe(void *_op)
 	secinfo.flags = op->flags;
 
 	asm volatile(".byte 0x0f, 0x01, 0xd7"
-				:
+				: /* no outputs */
 				: "a" (EMODPE),
 				  "b" (&secinfo),
-				  "c" (op->epc_addr));
+				  "c" (op->epc_addr)
+				: "memory" /* read from secinfo pointer */);
 }
 
 static void do_encl_eaccept(void *_op)
@@ -42,7 +43,8 @@ static void do_encl_eaccept(void *_op)
 				: "=a" (rax)
 				: "a" (EACCEPT),
 				  "b" (&secinfo),
-				  "c" (op->epc_addr));
+				  "c" (op->epc_addr)
+				: "memory" /* read from secinfo pointer */);
 
 	op->ret = rax;
 }
-- 
2.43.0



