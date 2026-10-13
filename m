Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B742C4FA;
	Tue, 13 Oct 2026 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893942; cv=none; b=FKeABcGz6O6xQkxS+0m+bGjqAt0/5FzANmrYb6iY2+UwIjNY5c7fAWs3zEq5UalkqQGuXK/sv3ktGH6wUqcdh/6E+QZYVkmxrDBJ4JBhIq0yeXShvHI4W1FUlau4vB3/arvxJXVReatih4gxESubGnRRn49MFYsdAb/iW1KNVy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893942; c=relaxed/simple;
	bh=NUgcTJp3QA9ARN2zYCNu3yE+rfqXeENjSll+L/jFofg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc5ZjFLdXvFdtuJa6XGKb3LcAbIj4RegwbkoD7omo2CGH34q8XziObv+OBetQuNMhcceW9EwFEKxaad+8yg0FvffFUX1B3fMGtlcs0UJPGruhIqaMW9Txy8+bktvRzH+qsWHoGQR0YiNrcRpif+KdEm5DMFrraB3kGIaFoM2wO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9Bq4hpa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9Bq4hpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D221F000FF;
	Tue, 13 Oct 2026 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893941;
	bh=TgKAqe3tGRA4SrWt0ZXrwThyYuZ/wEVg1QBpUF8bzb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9Bq4hpaVxczjTstoxlhEF/kO0cwR9HIsye5dTY4VEqXD5vIfCDcpJkZbcKWuzm/o
	 WPdYggE51/860fI2sfpJLcRAJjgI1wtS6quruLxMiiY5eP7w8Grn0hV2f/vXXIX1+W
	 OBRYrDpdlhURY0x8k1YahGqgTtWD5TrsbP6jXYoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jenswi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/621] optee: ffa: Add NULL check in optee_ffa_lend_protmem
Date: Tue, 13 Oct 2026 13:35:46 +0200
Message-ID: <20261013112929.180947007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 650c88738ae8976f46ba71b24dd8aa311adc6fde ]

Sashiko (locally) reports a possible null dereference under memory
pressure due to the lack of validation of the allocated pointer.

Fix that by adding the missing check.

Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Reviewed-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Jens Wiklander <jenswi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index 51e90692ce5cc..058b7b073a903 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
 	int rc;
 
 	mem_attr = kcalloc(ma_count, sizeof(*mem_attr), GFP_KERNEL);
+	if (!mem_attr)
+		return -ENOMEM;
+
 	for (n = 0; n < ma_count; n++) {
 		mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
 		mem_attr[n].attrs = mem_attrs[n] >> 16;
-- 
2.53.0



