Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2580F768F6;
	Tue, 23 Jan 2024 02:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975524; cv=none; b=lchULEGp+ja6lD3CxRmuKLCWSCaU9ZC7FcF7S2bbb1tvY6HbgX60966w+FXJPmoUWKh9StXJ1H83goqpOlbzIO3UWCYsdL5gs6EcNRCgnOLxOowwP8t+ZSQacsZ2m3j2NFLRtmst3XGqPti2BYAAahQY+VNvW7qNXco9RDM0RPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975524; c=relaxed/simple;
	bh=/8777Ancit4khwf1AMQmWJsRB67PYGm5Q+sdztVoj4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHYE+7yUiqxhQ4EBgiLk6fuN/HQs3x433lS6SYbfS4G22RtZJd8hUpSW3e29ad1oVf9gRhSmeBEQ/lfg3B2apJPxD+6d2ydR1AnALH7b54YPinxlGAsY2cZYbWC9K0HFOdiaJBcwQF03QK0mQ21s/NFf0hGC3fHXhTf7Ok6xPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRm3lzaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRm3lzaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03CAC433B2;
	Tue, 23 Jan 2024 02:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975524;
	bh=/8777Ancit4khwf1AMQmWJsRB67PYGm5Q+sdztVoj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRm3lzaRdbllO8SwwdaRbdjszPDbaEF0JO1LNsFANM6YXJ5zm5S3OYoQtJpGKdgG0
	 v5kKXzKmK/0jSa1g13gqm5FausPASC1Ef5bGgAln8lOOricYk1uOmtdKCY1zZi59nX
	 QJMCKnRoMk71v8iRmusb8sI3FbwiD8mjHTCyfMbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 476/583] selftests/sgx: Fix uninitialized pointer dereferences in encl_get_entry
Date: Mon, 22 Jan 2024 15:58:47 -0800
Message-ID: <20240122235826.551657905@linuxfoundation.org>
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

[ Upstream commit b84fc2e0139ba4b23b8039bd7cfd242894fe8f8b ]

Ensure sym_tab and sym_names are zero-initialized and add an early-out
condition in the unlikely (erroneous) case that the enclave ELF file would
not contain a symbol table.

This addresses -Werror=maybe-uninitialized compiler warnings for gcc -O2.

Fixes: 33c5aac3bf32 ("selftests/sgx: Test complete changing of page type flow")
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/all/20231005153854.25566-3-jo.vanbulck%40cs.kuleuven.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/load.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 94bdeac1cf04..c9f658e44de6 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -136,11 +136,11 @@ static bool encl_ioc_add_pages(struct encl *encl, struct encl_segment *seg)
  */
 uint64_t encl_get_entry(struct encl *encl, const char *symbol)
 {
+	Elf64_Sym *symtab = NULL;
+	char *sym_names = NULL;
 	Elf64_Shdr *sections;
-	Elf64_Sym *symtab;
 	Elf64_Ehdr *ehdr;
-	char *sym_names;
-	int num_sym;
+	int num_sym = 0;
 	int i;
 
 	ehdr = encl->bin;
@@ -161,6 +161,9 @@ uint64_t encl_get_entry(struct encl *encl, const char *symbol)
 		}
 	}
 
+	if (!symtab || !sym_names)
+		return 0;
+
 	for (i = 0; i < num_sym; i++) {
 		Elf64_Sym *sym = &symtab[i];
 
-- 
2.43.0



