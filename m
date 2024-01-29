Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A935E157050;
	Mon, 29 Jan 2024 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548021; cv=none; b=VIFUD6xCRzctepCH8qDl1n3ovpQjptAGdsY5gCU1kCms0dINrenKG54hwfVr4a0oQ9uo3yEwxJlWZfQZxb7zV6U6PZXdDkg6jv0vn695xJHrtfy37GiFBE9cm9NHTmzZzmE291XSEWu4YxiKcwwsvhNfLyxfHX/pEcWFkuT97LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548021; c=relaxed/simple;
	bh=gLcLwxcYejvWdjn8HgLeKZbYDKfFEdqErBHYQMczFrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmQfRJZboxETs/cY6SnU/6VpGOe6SvRJSi8GFfbBmHMS8N3owGmlxPGBt7T7lDRf5u9xd2lOLfDRPMaGOCRjanZLCk+CYFgEiQO/MfpDeanZNyDtFClkgESl10yMkma0CySqmTbiUp/sn7aJ4G7suxJKgcNbEWX2CVDdHgKwkCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGvwl7Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGvwl7Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093C7C43394;
	Mon, 29 Jan 2024 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548021;
	bh=gLcLwxcYejvWdjn8HgLeKZbYDKfFEdqErBHYQMczFrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGvwl7Fjz0Eus3L6mMU3WD0xZp6xonMoMngQ3SYThOXE+/ABFF15uhVncghj8vtNR
	 IQ7CGgYq9QIAmUVZDdZZGknKV1qKfnw1pk6kgS1OrFJDxP5asxilbREzVApCxnhEsJ
	 5ANgxey1l4fugDsZOEHP6QPVRfr5KOYEVOlEaNFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.7 014/346] crypto: lib/mpi - Fix unexpected pointer access in mpi_ec_init
Date: Mon, 29 Jan 2024 09:00:45 -0800
Message-ID: <20240129170016.779414252@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit ba3c5574203034781ac4231acf117da917efcd2a upstream.

When the mpi_ec_ctx structure is initialized, some fields are not
cleared, causing a crash when referencing the field when the
structure was released. Initially, this issue was ignored because
memory for mpi_ec_ctx is allocated with the __GFP_ZERO flag.
For example, this error will be triggered when calculating the
Za value for SM2 separately.

Fixes: d58bb7e55a8a ("lib/mpi: Introduce ec implementation to MPI library")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/mpi/ec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/crypto/mpi/ec.c
+++ b/lib/crypto/mpi/ec.c
@@ -584,6 +584,9 @@ void mpi_ec_init(struct mpi_ec_ctx *ctx,
 	ctx->a = mpi_copy(a);
 	ctx->b = mpi_copy(b);
 
+	ctx->d = NULL;
+	ctx->t.two_inv_p = NULL;
+
 	ctx->t.p_barrett = use_barrett > 0 ? mpi_barrett_init(ctx->p, 0) : NULL;
 
 	mpi_ec_get_reset(ctx);


