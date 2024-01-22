Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09357133435;
	Tue, 23 Jan 2024 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971903; cv=none; b=Mzw0Q8Re8awxWTvJY6vnG8xwq+YgdFD/rvKEMalXb7b5O22ri7tdrZjVs0w8R+ffR9yjn1VH/QHa5el+ofc4tt9D6hh/8aMdu/jx0NFjrmOlZs4rIX0VF6zQMKEKxQ17+jtUD/Bpz88196LW4RUtIMi7OXTuQXJambrlIIf2kL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971903; c=relaxed/simple;
	bh=T/UFyxeZ55kSqrp/vFu9GkL1rDtU5HVUyqHEe/hwx98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM8FCrJUJbjna9A7Mx894LnyqL60fR/q3G/tnjQifplQIx0MSaaBpHqnmz0n49Fd2ouyN4uzXI63NxJ4SsVOrMTShnUvbkr99PDr/l9Fl/vuzk+9wOe2/L4b7mNyCmlXjXxl8DQMYBREATSF7KmFKz5YdJRtNpfQnGzUj/DmrNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksHzIny5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksHzIny5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FE6C433F1;
	Tue, 23 Jan 2024 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971902;
	bh=T/UFyxeZ55kSqrp/vFu9GkL1rDtU5HVUyqHEe/hwx98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksHzIny53B+rPJs2P120datB1OXx1bmvNhTTUUfdsgEMtSQLIe7wD/ZcFddnpimkz
	 koImKgMlX/VnFhZkSxwgbRbZ/nOUd+7oTnS5S06jIz9qMpwF7j7hj/yRo/+T2dXJEH
	 UxkFPsn4qBbHOs+3bf+8Ubv5Hg1kvBOrxQ5VzRZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 346/417] selftests/sgx: Fix uninitialized pointer dereference in error path
Date: Mon, 22 Jan 2024 15:58:34 -0800
Message-ID: <20240122235803.769994045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>

[ Upstream commit 79eba8c924f7decfa71ddf187d38cb9f5f2cd7b3 ]

Ensure ctx is zero-initialized, such that the encl_measure function will
not call EVP_MD_CTX_destroy with an uninitialized ctx pointer in case of an
early error during key generation.

Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/all/20231005153854.25566-2-jo.vanbulck%40cs.kuleuven.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/sigstruct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index a07896a46364..d73b29becf5b 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -318,9 +318,9 @@ bool encl_measure(struct encl *encl)
 	struct sgx_sigstruct *sigstruct = &encl->sigstruct;
 	struct sgx_sigstruct_payload payload;
 	uint8_t digest[SHA256_DIGEST_LENGTH];
+	EVP_MD_CTX *ctx = NULL;
 	unsigned int siglen;
 	RSA *key = NULL;
-	EVP_MD_CTX *ctx;
 	int i;
 
 	memset(sigstruct, 0, sizeof(*sigstruct));
@@ -384,7 +384,8 @@ bool encl_measure(struct encl *encl)
 	return true;
 
 err:
-	EVP_MD_CTX_destroy(ctx);
+	if (ctx)
+		EVP_MD_CTX_destroy(ctx);
 	RSA_free(key);
 	return false;
 }
-- 
2.43.0



