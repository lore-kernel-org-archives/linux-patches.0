Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFD0BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D80C4339B;
	Tue,  7 Mar 2023 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209322;
	bh=uw+d/MGSWEKxdDrXow9nFnZ5jR24MWhjnbMpVFslErw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ib1iaaoDMV6f4tFKiXnAl0D74DqET3EHwPjE9uaCFkn09xwg2KPfbOx7UV9X9UB5y
	 +2VuM51RgHIm1oNQAKpYb1Uu7L7SC7JpBfX3oB+W1wiDisigCQq+IE6uX6lKElJ/v9
	 F5vHiizrct74AEkzZQAK9h79tiURYzZ3nuX0AtuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huaweicloud.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0181/1001] lib/mpi: Fix buffer overrun when SG is too long
Date: Tue,  7 Mar 2023 17:49:13 +0100
Message-Id: <20230307170029.766186632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 7361d1bc307b926cbca214ab67b641123c2d6357 ]

The helper mpi_read_raw_from_sgl sets the number of entries in
the SG list according to nbytes.  However, if the last entry
in the SG list contains more data than nbytes, then it may overrun
the buffer because it only allocates enough memory for nbytes.

Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/mpicoder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 39c4c67310946..3cb6bd148fa9e 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -504,7 +504,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	while (sg_miter_next(&miter)) {
 		buff = miter.addr;
-		len = miter.length;
+		len = min_t(unsigned, miter.length, nbytes);
+		nbytes -= len;
 
 		for (x = 0; x < len; x++) {
 			a <<= 8;
-- 
2.39.2



