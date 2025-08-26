Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA60134DCCA;
	Tue, 26 Aug 2025 14:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217104; cv=none; b=Pg9JksyAqMwzLS6yBUrFQdzB7nuI3nk6Y8srwyObH5NwhmgaN4VlrX64UeyupAxesm3dgb4IfZfjeOt7hFIvQjvY02hLqLEQ7ss3eSvDBqw1PRshAeFxPjhzlAtmSLAJxnOEhGqeunMdN/vGSD2RIoqTAYCNfw7ciS1E7DmQfao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217104; c=relaxed/simple;
	bh=yF5wpU/StNwspKI2Q0txFvH4e4Wnx0Ra+9DMUNQIfqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFz4MZ2ne9CIQBfRlRiJPtRO987iyZC14sseMfNUsksemGpNrC4wE6NULYntSJV1e1XyzW8s4tTEJjyiF0ulEPku1DCFedVIsGxwH5uDNVGEsgarCr9JTOGHReGA7u6/FXd6Ax7INWJ88t0ucrnPDAiWG5stOIlWtazdGo1+55U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKnC7wMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKnC7wMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36581C4CEF1;
	Tue, 26 Aug 2025 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217104;
	bh=yF5wpU/StNwspKI2Q0txFvH4e4Wnx0Ra+9DMUNQIfqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKnC7wMoPzA6LtQsrxjXY4phKKcIhfJj1ZVvwq6s6zDCoqc6JKV+yDcXDA5XgyBzf
	 D3+2utssCI5MAs+9dEcXPdPCcUkZvRU+rdFfwoRAdPobgQ32HllfBoEBUno+9XedB4
	 53pr731QdlEjDHc3BFoLo41QLU9eypVgd7bhjmgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 018/523] memstick: core: Zero initialize id_reg in h_memstick_read_dev_id()
Date: Tue, 26 Aug 2025 13:03:48 +0200
Message-ID: <20250826110925.039136124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 21b34a3a204ed616373a12ec17dc127ebe51eab3 upstream.

A new warning in clang [1] points out that id_reg is uninitialized then
passed to memstick_init_req() as a const pointer:

  drivers/memstick/core/memstick.c:330:59: error: variable 'id_reg' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
    330 |                 memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,
        |                                                                         ^~~~~~

Commit de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull
warning") intentionally passed this variable uninitialized to avoid an
-Wnonnull warning from a NULL value that was previously there because
id_reg is never read from the call to memstick_init_req() in
h_memstick_read_dev_id(). Just zero initialize id_reg to avoid the
warning, which is likely happening in the majority of builds using
modern compilers that support '-ftrivial-auto-var-init=zero'.

Cc: stable@vger.kernel.org
Fixes: de182cc8e882 ("drivers/memstick/core/memstick.c: avoid -Wnonnull warning")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2105
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250715-memstick-fix-uninit-const-pointer-v1-1-f6753829c27a@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(memstick_init_req);
 static int h_memstick_read_dev_id(struct memstick_dev *card,
 				  struct memstick_request **mrq)
 {
-	struct ms_id_register id_reg;
+	struct ms_id_register id_reg = {};
 
 	if (!(*mrq)) {
 		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,


