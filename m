Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A361C6899;
	Tue, 27 Aug 2024 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770352; cv=none; b=LaJCre9FERGqNCthPqp9VO3PKiUzg5AVJ3P6KNvVUZk/Icifw1s90bxTKyJEsp6Pis8VpWAsb96Qfj9Hq0NcyQmHhPrmluqTeuhmETiCcFGzxqXywV1+5uB620ow4owKDcol3k/iiduYSi8Gn8ViQVf8nrgw6aQG0rkaf1nHC1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770352; c=relaxed/simple;
	bh=TCce4rAJnXtZCCVcbq8VQUaW2UXpQIIgNUa31uyPUfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FceqLPy7kC4O+tERbZPis66aqEPfPnkUrFoDXRK+Gl9LU/CoLfIw8czAfDa1/DhBcKt7K7RxL62+xidVgIrtzNhS4aDWnjvW7GuFQaMdw3Xo/KCjBULR9TnMF2Vci4lWDB3c33KOgH+8NguFAKIjHLN1hiXHu798znU0qFFxb5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrTBFS22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrTBFS22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C910C61042;
	Tue, 27 Aug 2024 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770352;
	bh=TCce4rAJnXtZCCVcbq8VQUaW2UXpQIIgNUa31uyPUfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrTBFS22IrL+lEb950oRDjQP6NEnaTiaBqDB0ueSuT6bnNBe0Xbsul3vJLfrCsZpr
	 jgPE0OpmJF+lyzKMoNFDz6rRQIvTjfEv814chSQKDhEBtwKa1z2eZj8X/7aTbScX3x
	 BLvMAmG2ZkToowdxh3m4ataxUsEXrT2ZrWYcGQUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/341] s390/iucv: fix receive buffer virtual vs physical address confusion
Date: Tue, 27 Aug 2024 16:37:15 +0200
Message-ID: <20240827143851.177624331@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 4e8477aeb46dfe74e829c06ea588dd00ba20c8cc ]

Fix IUCV_IPBUFLST-type buffers virtual vs physical address confusion.
This does not fix a bug since virtual and physical address spaces are
currently the same.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index db41eb2d977f2..038e1ba9aec27 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1090,8 +1090,7 @@ static int iucv_message_receive_iprmdata(struct iucv_path *path,
 		size = (size < 8) ? size : 8;
 		for (array = buffer; size > 0; array++) {
 			copy = min_t(size_t, size, array->length);
-			memcpy((u8 *)(addr_t) array->address,
-				rmmsg, copy);
+			memcpy(phys_to_virt(array->address), rmmsg, copy);
 			rmmsg += copy;
 			size -= copy;
 		}
-- 
2.43.0



