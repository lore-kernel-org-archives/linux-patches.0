Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E262AE90;
	Tue, 12 Aug 2025 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026111; cv=none; b=hkA+8f89K0BGH1luweLx/0kwcTM16qkiREHG2y3CGUyorTZe3/cl3Xy6biEmQf5PakTODcGkxajYt5RMDSFmCX3hfeQaV/tcD3aoghuA1cI3RDhPccWO6HLdrPtO27wZI/wZ4ThfHTuuq6pBNQ3UpSIEiZSw87sXQZS09erW2Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026111; c=relaxed/simple;
	bh=UtAOKYJyT9EzwditwGyFxYgRupWSHP42ZK7f9ihpI6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxokPNgrDxwSpXiZF1AHkIL3dqw07UT4bbQtcB94j2iK8v8yfcf97S3K8LgGEmnGTxNaMHliNE8SqGe++GBSmJ2D37sRR5sLirtaTSstnV4tZziGQLeSXh0unG0WWdKhmJq0SGwGUTeXz+MIGPmaEArtT/SGbgWmZ04JDs3Ykwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2X4n0nU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2X4n0nU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FCBC4CEF0;
	Tue, 12 Aug 2025 19:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026111;
	bh=UtAOKYJyT9EzwditwGyFxYgRupWSHP42ZK7f9ihpI6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2X4n0nUh6ZZGFNt5Z4+I1tfCb9WqbuemgNb+FwGkTc75CuSPPrX3VDOTsofTqM3j
	 QzKldq8H2I/GGyo98LWpNJyjvI6rsky3xseneAazkKX3BAsz6FRLB+NrCWUzVRC+83
	 Ma8yScOwDJYxTOidZSTC1P7XzDUmtgFwhUR3fKZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 222/480] fortify: Fix incorrect reporting of read buffer size
Date: Tue, 12 Aug 2025 19:47:10 +0200
Message-ID: <20250812174406.604177649@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 94fd44648dae2a5b6149a41faa0b07928c3e1963 ]

When FORTIFY_SOURCE reports about a run-time buffer overread, the wrong
buffer size was being shown in the error message. (The bounds checking
was correct.)

Fixes: 3d965b33e40d ("fortify: Improve buffer overflow reporting")
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20250729231817.work.023-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index e4ce1cae03bf..b3b53f8c1b28 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -596,7 +596,7 @@ __FORTIFY_INLINE bool fortify_memcpy_chk(__kernel_size_t size,
 	if (p_size != SIZE_MAX && p_size < size)
 		fortify_panic(func, FORTIFY_WRITE, p_size, size, true);
 	else if (q_size != SIZE_MAX && q_size < size)
-		fortify_panic(func, FORTIFY_READ, p_size, size, true);
+		fortify_panic(func, FORTIFY_READ, q_size, size, true);
 
 	/*
 	 * Warn when writing beyond destination field size.
-- 
2.39.5



